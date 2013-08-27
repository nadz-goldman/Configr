-- create database configr CHARACTER SET utf8 COLLATE utf8_general_ci;
-- GRANT ALL PRIVILEGES ON configr.* TO switcher@localhost IDENTIFIED BY 'SwitcherDBMegaPass' WITH GRANT OPTION;
-- flush privileges;


SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE TABLE IF NOT EXISTS `devices` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `hostname` varchar(255) NOT NULL,
  `alias` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `hostgroup` varchar(255) NOT NULL,
  `parent_0` varchar(255) NOT NULL,
  `parent_1` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `kb` (
  `model` varchar(255) NOT NULL,
  `cmd` varchar(255) NOT NULL,
  `cmdtype` varchar(255) NOT NULL,
  `desc` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `links` (
  `hostname` varchar(255) NOT NULL,
  `parent` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `links_ports` (
  `parent` varchar(255) NOT NULL,
  `child` varchar(255) NOT NULL,
  `parent_port` int(11) NOT NULL,
  `child_port` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `live_hosts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `mac` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `ip` varchar(255) NOT NULL,
  `mac` varchar(255) NOT NULL,
  `vlan` varchar(255) NOT NULL,
  `port` varchar(255) NOT NULL,
  `first_seen` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `simple` (
  `address` varchar(255) NOT NULL,
  `hostname` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `snmp_info` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL,
  `uptime` varchar(255) NOT NULL,
  `contact` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;
