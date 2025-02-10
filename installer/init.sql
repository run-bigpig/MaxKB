-- 检查数据库是否存在，如果不存在则创建
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'kgai') THEN
        CREATE DATABASE "kgai";
END IF;
END $$;

-- 连接到新创建的数据库
\c "kgai";

-- 检查扩展是否存在，如果不存在则创建
CREATE EXTENSION IF NOT EXISTS "vector";