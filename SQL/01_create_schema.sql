
-- Drop existing schema (if exists)
DROP USER PWC_INNOTECH_PROJECT CASCADE;

-- Create schema (user)
CREATE USER PWC_INNOTECH_PROJECT IDENTIFIED BY 123;

-- Grant required privileges
GRANT DBA TO PWC_INNOTECH_PROJECT;


