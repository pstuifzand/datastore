
CREATE TABLE IF NOT EXISTS `entities` (
    `added_id` int(11) NOT NULL auto_increment,
    `id` binary(16) NOT NULL,
    `created` datetime NOT NULL,
    `updated` timestamp NOT NULL default '0000-00-00 00:00:00' on update CURRENT_TIMESTAMP,
    `body` mediumblob NOT NULL,
    PRIMARY KEY  (`added_id`),
    UNIQUE KEY `id` (`id`),
    KEY `updated` (`updated`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

