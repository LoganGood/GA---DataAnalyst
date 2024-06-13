SELECT computer_type, COUNT(computer_type) AS [Count] 
FROM (SELECT DISTINCT computer_name, computer_type FROM computers)
WHERE computer_type = 'Admin' OR computer_type = 'Regular'
GROUP BY computer_type;

SELECT c.computer_name, c.computer_type, c.operating_system, ip.program_name, ip.program_version FROM computers c
INNER JOIN installed_programs ip ON c.computer_name = ip.computer_name
AND c.computer_type != 'Admin'
AND (ip.program_name LIKE  '%bitwarden%'
	OR ip.program_name LIKE '%quickpass%'
	OR ip.program_name LIKE '%1password%')
GROUP BY c.computer_name 

SELECT ip.program_name, ip.program_version, COUNT(ip.computer_name) AS computer_count
FROM installed_programs ip
INNER JOIN (SELECT program_name, MAX(program_version) AS max_version
	FROM installed_programs
	GROUP BY program_name) ip2 ON ip.program_name = ip2.program_name 
	AND ip.program_version = ip2.max_version
	AND (ip.program_name LIKE  '%bitwarden%'
	OR ip.program_name LIKE '%quickpass%'
	OR ip.program_name LIKE '%1password%')
	GROUP BY ip.program_name
	
SELECT lr.computer_name, lr.login_ip, lr.login_timestamp, c.computer_type, ip.program_name
FROM login_records lr
INNER JOIN (SELECT computer_name, computer_type
		FROM computers 
		WHERE computer_type LIKE '%Admin%') c
	ON lr.computer_name = c.computer_name
	AND lr.login_timestamp >= '2023-05-01'
INNER JOIN (SELECT computer_name, program_name
		FROM installed_programs
		WHERE program_name LIKE '%python%') ip
	ON c.computer_name = ip.computer_name
LEFT JOIN ip_whitelist wl
	ON lr.login_ip = wl.login_ip 
WHERE wl.login_ip IS NULL 
GROUP BY c.computer_name
ORDER BY lr.login_timestamp DESC 

SELECT * FROM ip_whitelist iw 
