"""Run every SQL file in sql/ (except the schema) and print results. Needs only Python."""
import sqlite3, sys, glob
db = sys.argv[1]
con = sqlite3.connect(db)
for fn in sorted(glob.glob("sql/*.sql")):
    if "schema" in fn: continue
    print(f"\n== {fn}")
    sql = "\n".join(l for l in open(fn) if not l.startswith("."))
    for stmt in [s for s in sql.split(";") if s.strip() and not all(l.strip().startswith("--") or not l.strip() for l in s.splitlines())]:
        cur = con.execute(stmt)
        cols = [c[0] for c in cur.description]
        rows = cur.fetchall()
        print(" | ".join(cols))
        for r in rows[:15]: print(" | ".join(str(x) for x in r))
        if len(rows) > 15: print(f"... {len(rows)} rows")
