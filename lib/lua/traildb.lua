local ffi = require("ffi")

ffi.cdef[[
typedef uint8_t  tdb_field; //  8 bits
typedef uint32_t tdb_val;   // 24 bits
typedef uint32_t tdb_item;  // val, field

typedef struct _tdb_cons tdb_cons;
typedef struct _tdb_file tdb_file;
typedef struct _tdb_lexicon tdb_lexicon;
typedef struct _tdb tdb;

typedef void *(*tdb_fold_fn)(const tdb *, uint64_t, const tdb_item *, void *);

tdb_cons *tdb_cons_new(const char *root,
                       const char *ofield_names,
                       uint32_t num_ofields);
void tdb_cons_free(tdb_cons *cons);

int tdb_cons_add(tdb_cons *cons,
                 const uint8_t cookie[16],
                 const uint32_t timestamp,
                 const char *values);
int tdb_cons_append(tdb_cons *cons, const tdb *db);
int tdb_cons_finalize(tdb_cons *cons, uint64_t flags);

int tdb_cookie_raw(const uint8_t hexcookie[32], uint8_t cookie[16]);
int tdb_cookie_hex(const uint8_t cookie[16], uint8_t hexcookie[32]);

tdb *tdb_open(const char *root);
void tdb_close(tdb *db);

int tdb_lexicon_read(tdb *db, tdb_field field, const tdb_lexicon **lex);
uint32_t tdb_lexicon_size(tdb *db, tdb_field field);

int tdb_get_field(tdb *db, const char *field_name);
const char *tdb_get_field_name(tdb *db, tdb_field field);

tdb_item tdb_get_item(tdb *db, tdb_field field, const char *value);
const char *tdb_get_value(tdb *db, tdb_field field, tdb_val val);
const char *tdb_get_item_value(tdb *db, tdb_item item);

const uint8_t *tdb_get_cookie(const tdb *db, uint64_t cookie_id);
uint64_t tdb_get_cookie_offs(const tdb *db, uint64_t cookie_id);
uint64_t tdb_get_cookie_id(const tdb *db, const uint8_t cookie[16]);

int tdb_has_cookie_index(const tdb *db);

const char *tdb_error(const tdb *db);

uint64_t tdb_num_cookies(const tdb *db);
uint64_t tdb_num_events(const tdb *db);
uint32_t tdb_num_fields(const tdb *db);
uint32_t tdb_min_timestamp(const tdb *db);
uint32_t tdb_max_timestamp(const tdb *db);


int tdb_split(const tdb *db,
              unsigned int num_parts,
              const char *fmt,
              uint64_t flags);

int tdb_split_with(const tdb *db,
                   unsigned int num_parts,
                   const char *fmt,
                   uint64_t flags,
                   tdb_fold_fn split_fn);

uint32_t tdb_decode_trail(const tdb *db,
                          uint64_t cookie_id,
                          uint32_t *dst,
                          uint32_t dst_size,
                          int edge_encoded);

void *tdb_fold(const tdb *db, tdb_fold_fn fun, void *acc);
]]

return ffi.load('traildb')
