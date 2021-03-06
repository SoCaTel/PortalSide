-- MySQL Script generated by MySQL Workbench
-- Fri Oct 23 10:59:52 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema socatel
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema socatel
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `socatel` DEFAULT CHARACTER SET utf8 ;
USE `socatel` ;

-- -----------------------------------------------------
-- Table `socatel`.`so_locality`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_locality` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_locality` (
  `locality_id` INT NOT NULL,
  `locality_name` VARCHAR(45) NULL,
  `locality_parent_id` INT NULL,
  PRIMARY KEY (`locality_id`),
  INDEX `fk_so_locality_so_locality1_idx` (`locality_parent_id` ASC) ,
  CONSTRAINT `fk_so_locality_so_locality1`
    FOREIGN KEY (`locality_parent_id`)
    REFERENCES `socatel`.`so_locality` (`locality_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_organisation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_organisation` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_organisation` (
  `organisation_id` INT NOT NULL AUTO_INCREMENT,
  `organisation_name` VARCHAR(100) NOT NULL,
  `organisation_structure` TINYINT NOT NULL,
  `organisation_website` TEXT NOT NULL,
  `twitter_screen_name` TEXT NULL,
  `twitter_account_description` TEXT NULL,
  `twitter_user_id` INT NULL,
  `twitter_oauth_token` TEXT NULL,
  `twitter_oauth_secret` TEXT NULL,
  `facebook_oauth_token` TEXT NULL,
  `facebook_page_id` TEXT NULL,
  PRIMARY KEY (`organisation_id`),
  UNIQUE INDEX `organisation_name_UNIQUE` (`organisation_name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_language`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_language` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_language` (
  `language_id` INT NOT NULL AUTO_INCREMENT,
  `language_code` VARCHAR(2) NOT NULL,
  `language_name` VARCHAR(50) NULL,
  PRIMARY KEY (`language_id`),
  UNIQUE INDEX `language_code_UNIQUE` (`language_code` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_group` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_group` (
  `group_id` INT NOT NULL AUTO_INCREMENT,
  `locality_id` INT NOT NULL,
  `user_initiator_id` INT NOT NULL,
  `group_name` VARCHAR(100) NULL COMMENT 'title',
  `group_description` TEXT NULL COMMENT 'describe the theme or topic',
  `group_status` TINYINT NOT NULL DEFAULT 0 COMMENT '0:SUGGESTED, 1:WAITING, 2:IDEATION, 3:VALIDATION, 4:CODESIGN, 5:IMPLEMENTATION, 6:COMPLETED, 7:REJECTED',
  `group_create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `language_id` INT NOT NULL,
  `group_next_step_time` TIMESTAMP NULL,
  `group_step1_summary` TEXT NULL,
  `group_step2_summary` TEXT NULL,
  `group_step3_summary` TEXT NULL,
  `group_step4_summary` TEXT NULL,
  `group_meeting_display` TINYINT NOT NULL DEFAULT 0 COMMENT '0: Hidden, 1: Display',
  `group_meeting_code` VARCHAR(40) NULL,
  PRIMARY KEY (`group_id`),
  INDEX `fk_so_group_so_locality1_idx` (`locality_id` ASC) ,
  INDEX `fk_so_group_so_user1_idx` (`user_initiator_id` ASC) ,
  INDEX `fk_so_group_so_language1_idx` (`language_id` ASC) ,
  CONSTRAINT `fk_so_group_so_locality1`
    FOREIGN KEY (`locality_id`)
    REFERENCES `socatel`.`so_locality` (`locality_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_group_so_user1`
    FOREIGN KEY (`user_initiator_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_group_so_language1`
    FOREIGN KEY (`language_id`)
    REFERENCES `socatel`.`so_language` (`language_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'In the user interface, this is called topic. In D1.1 requirement, this is called group.';


-- -----------------------------------------------------
-- Table `socatel`.`so_feedback`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_feedback` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_feedback` (
  `feedback_id` INT NOT NULL AUTO_INCREMENT,
  `feedback_title` VARCHAR(255) NOT NULL,
  `feedback_description` TEXT NOT NULL,
  `feedback_question` TEXT NOT NULL,
  `feedback_visible` TINYINT NOT NULL DEFAULT 0 COMMENT '0: , 1: hidden',
  `feedback_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `feedback_by_org` TINYINT NOT NULL COMMENT '0: by_user, 1: by_org',
  `post_id` INT NOT NULL,
  `group_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`feedback_id`),
  INDEX `fk_so_feedback_so_post1_idx` (`post_id` ASC) ,
  INDEX `fk_so_feedback_so_group1_idx` (`group_id` ASC) ,
  INDEX `fk_so_feedback_so_user1_idx` (`user_id` ASC) ,
  CONSTRAINT `fk_so_feedback_so_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `socatel`.`so_post` (`post_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_feedback_so_group1`
    FOREIGN KEY (`group_id`)
    REFERENCES `socatel`.`so_group` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_feedback_so_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_post`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_post` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_post` (
  `post_id` INT NOT NULL AUTO_INCREMENT,
  `group_id` INT NOT NULL,
  `author_user_id` INT NOT NULL,
  `post_text` TEXT NOT NULL,
  `post_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `post_upvotes` INT NOT NULL DEFAULT 0,
  `post_downvotes` INT NOT NULL DEFAULT 0,
  `post_parent_id` INT NULL,
  `post_type` TINYINT NULL COMMENT '0: Other, 1: Personal Experinece, 2: Idea',
  `post_phase` TINYINT NOT NULL DEFAULT 0 COMMENT '0: Ideation, 1: Validation, 2: Codesign, 3: Implementation',
  `organisation_id` INT NULL,
  `post_visible` TINYINT NOT NULL DEFAULT 0 COMMENT '0: , 1: hidden',
  `post_pin` TINYINT NOT NULL DEFAULT 0 COMMENT '0: not_pinned, 1:pinned',
  `feedback_id` INT NOT NULL,
  PRIMARY KEY (`post_id`),
  INDEX `fk_so_post_so_user1_idx` (`author_user_id` ASC) ,
  INDEX `fk_so_post_so_post1_idx` (`post_parent_id` ASC) ,
  INDEX `fk_so_post_so_group1_idx` (`group_id` ASC) ,
  INDEX `fk_so_post_so_organisation1_idx` (`organisation_id` ASC) ,
  INDEX `fk_so_post_so_feedback1_idx` (`feedback_id` ASC) ,
  CONSTRAINT `fk_so_post_so_user1`
    FOREIGN KEY (`author_user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_post_so_post1`
    FOREIGN KEY (`post_parent_id`)
    REFERENCES `socatel`.`so_post` (`post_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_post_so_group1`
    FOREIGN KEY (`group_id`)
    REFERENCES `socatel`.`so_group` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_post_so_organisation1`
    FOREIGN KEY (`organisation_id`)
    REFERENCES `socatel`.`so_organisation` (`organisation_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_post_so_feedback1`
    FOREIGN KEY (`feedback_id`)
    REFERENCES `socatel`.`so_feedback` (`feedback_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_chat`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_chat` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_chat` (
  `chat_id` INT NOT NULL AUTO_INCREMENT,
  `user_id_1` INT NOT NULL,
  `user_id_2` INT NOT NULL,
  `chat_lastseen_user_1` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `chat_lastseen_user_2` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `chat_lastmessage` TIMESTAMP NULL,
  PRIMARY KEY (`chat_id`),
  INDEX `fk_so_chat_so_user1_idx` (`user_id_1` ASC) ,
  INDEX `fk_so_chat_so_user2_idx` (`user_id_2` ASC) ,
  CONSTRAINT `fk_so_chat_so_user1`
    FOREIGN KEY (`user_id_1`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_chat_so_user2`
    FOREIGN KEY (`user_id_2`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_message`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_message` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_message` (
  `message_id` INT NOT NULL AUTO_INCREMENT,
  `message_text` TEXT NOT NULL,
  `user_id` INT NOT NULL,
  `message_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `chat_id` INT NOT NULL,
  PRIMARY KEY (`message_id`),
  INDEX `fk_so_message_so_user_to_idx` (`user_id` ASC) ,
  INDEX `timeuser` (`user_id` ASC, `message_time` ASC) ,
  INDEX `fk_so_message_so_chat1_idx` (`chat_id` ASC) ,
  CONSTRAINT `fk_so_message_so_user10`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_message_so_chat1`
    FOREIGN KEY (`chat_id`)
    REFERENCES `socatel`.`so_chat` (`chat_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_document`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_document` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_document` (
  `document_id` INT NOT NULL AUTO_INCREMENT,
  `post_id` INT NULL,
  `message_id` INT NULL,
  `group_id` INT NULL,
  `feedback_id` INT NULL,
  `document_name` VARCHAR(255) NULL COMMENT 'Document name in user interface.',
  `document_type` VARCHAR(255) NULL COMMENT 'Document physical file name.',
  `document_bytes` INT NULL,
  PRIMARY KEY (`document_id`),
  INDEX `fk_so_document_so_post1_idx` (`post_id` ASC) ,
  INDEX `fk_so_document_so_group1_idx` (`group_id` ASC) ,
  INDEX `fk_so_document_so_message1_idx` (`message_id` ASC) ,
  INDEX `fk_so_document_so_feedback1_idx` (`feedback_id` ASC) ,
  CONSTRAINT `fk_so_document_so_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `socatel`.`so_post` (`post_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_document_so_group1`
    FOREIGN KEY (`group_id`)
    REFERENCES `socatel`.`so_group` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_document_so_message1`
    FOREIGN KEY (`message_id`)
    REFERENCES `socatel`.`so_message` (`message_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_document_so_feedback1`
    FOREIGN KEY (`feedback_id`)
    REFERENCES `socatel`.`so_feedback` (`feedback_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_user` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `locality_id` INT NOT NULL COMMENT 'City',
  `locality_id_parent` INT NULL COMMENT 'parent locality id (country).',
  `user_username` VARCHAR(50) NOT NULL COMMENT 'Nickname',
  `user_email` VARCHAR(255) NOT NULL,
  `user_password` VARCHAR(100) NOT NULL,
  `user_create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `user_enabled` TINYINT NOT NULL DEFAULT 0 COMMENT '0: disabled(waiting to validate email); 1: enabled; 2: locked.',
  `user_anonymized` TINYINT NOT NULL DEFAULT 0 COMMENT '0: no, 1: yes',
  `user_role` TINYINT NOT NULL DEFAULT 0 COMMENT '0: user. 1:moderator. 2:admin.',
  `organisation_id` INT NULL,
  `user_org_role` TINYINT NULL DEFAULT 0 COMMENT '0: common. 1: Admin. 2: Owner.',
  `user_personal_data_usage` TINYINT NULL DEFAULT 1 COMMENT '1: enabled',
  `user_profile` TINYINT NULL COMMENT '0: Individual, 1: Professional',
  `user_gender` TINYINT NULL DEFAULT 0 COMMENT '0:undefined. 1: male. 2: female. 3:other.',
  `user_description` TEXT NULL,
  `language_id_first` INT NOT NULL,
  `language_id_second` INT NULL,
  `user_notif_email` TINYINT NULL DEFAULT 0,
  `user_notif_new_topic` TINYINT NULL DEFAULT 0,
  `user_notif_all` TINYINT NULL,
  `user_age_range` TINYINT NULL COMMENT '0: <18, 1: 19-25; 2: 26-49; 3: 60-65; 4: >65',
  `document_id` INT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_username_UNIQUE` (`user_username` ASC) ,
  UNIQUE INDEX `user_email_UNIQUE` (`user_email` ASC) ,
  INDEX `fk_so_user_so_locality1_idx` (`locality_id` ASC) ,
  INDEX `fk_so_user_so_organisation1_idx` (`organisation_id` ASC) ,
  INDEX `user_parent_locality_id` (`locality_id_parent` ASC) ,
  INDEX `fk_so_user_so_language1_idx` (`language_id_first` ASC) ,
  INDEX `fk_so_user_so_language2_idx` (`language_id_second` ASC) ,
  INDEX `fk_so_user_so_document1_idx` (`document_id` ASC) ,
  CONSTRAINT `fk_so_user_so_locality1`
    FOREIGN KEY (`locality_id`)
    REFERENCES `socatel`.`so_locality` (`locality_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_user_so_organisation1`
    FOREIGN KEY (`organisation_id`)
    REFERENCES `socatel`.`so_organisation` (`organisation_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_user_so_language1`
    FOREIGN KEY (`language_id_first`)
    REFERENCES `socatel`.`so_language` (`language_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_user_so_language2`
    FOREIGN KEY (`language_id_second`)
    REFERENCES `socatel`.`so_language` (`language_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_user_so_locality2`
    FOREIGN KEY (`locality_id_parent`)
    REFERENCES `socatel`.`so_locality` (`locality_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_user_so_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `socatel`.`so_document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `socatel`.`so_group_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_group_user` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_group_user` (
  `group_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `group_user_relation` TINYINT NULL COMMENT '0:subscribed, 1: create',
  PRIMARY KEY (`group_id`, `user_id`),
  INDEX `fk_so_group_user_so_user1_idx` (`user_id` ASC) ,
  CONSTRAINT `fk_so_group_user_so_group1`
    FOREIGN KEY (`group_id`)
    REFERENCES `socatel`.`so_group` (`group_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_group_user_so_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'This table stores the relationship with groups and users.';


-- -----------------------------------------------------
-- Table `socatel`.`so_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_history` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_history` (
  `history_id` INT NOT NULL AUTO_INCREMENT,
  `history_text` TEXT NULL,
  `user_id` INT NULL,
  `history_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `history_type` TINYINT NULL,
  `organisation_id` INT NULL,
  `group_id` INT NULL,
  `history_level` TINYINT NULL COMMENT '0: visible for user, 1: not visible for user',
  PRIMARY KEY (`history_id`),
  INDEX `fk_so_log_so_user1_idx` (`user_id` ASC) ,
  INDEX `fk_so_history_so_organisation1_idx` (`organisation_id` ASC) ,
  INDEX `fk_so_history_so_group1_idx` (`group_id` ASC) ,
  CONSTRAINT `fk_so_log_so_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_history_so_organisation1`
    FOREIGN KEY (`organisation_id`)
    REFERENCES `socatel`.`so_organisation` (`organisation_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_history_so_group1`
    FOREIGN KEY (`group_id`)
    REFERENCES `socatel`.`so_group` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_invitation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_invitation` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_invitation` (
  `invitation_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `organisation_id` INT NOT NULL,
  `invitation_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `invitation_status` TINYINT NOT NULL DEFAULT 0 COMMENT '0:sent. 1:cancellled. 2:accepted. 3:rejected.',
  `invitation_token` VARCHAR(100) NOT NULL,
  `invitation_role` TINYINT NOT NULL COMMENT '0:common user. 1:admin.',
  `invitation_email` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`invitation_id`),
  INDEX `fk_so_invitation_so_user1_idx` (`user_id` ASC) ,
  INDEX `fk_so_invitation_so_organisation1_idx` (`organisation_id` ASC) ,
  INDEX `ix_invitation_token` (`invitation_token` ASC) ,
  CONSTRAINT `fk_so_invitation_so_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_invitation_so_organisation1`
    FOREIGN KEY (`organisation_id`)
    REFERENCES `socatel`.`so_organisation` (`organisation_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_notification`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_notification` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_notification` (
  `notif_id` INT NOT NULL AUTO_INCREMENT,
  `notif_text` TEXT NULL,
  `user_id` INT NOT NULL,
  `notif_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `notif_new` TINYINT NULL DEFAULT 0 COMMENT '0: new notif 1: old notif.',
  `notif_url` TEXT NULL,
  `notif_reference` TEXT NULL,
  PRIMARY KEY (`notif_id`),
  INDEX `fk_so_message_so_user1_idx` (`user_id` ASC) ,
  INDEX `timeuser` (`user_id` ASC, `notif_time` ASC) ,
  CONSTRAINT `fk_so_message_so_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_verification_token`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_verification_token` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_verification_token` (
  `verification_token_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `verification_token_token` VARCHAR(100) NULL,
  `verification_token_expiry_date` TIMESTAMP NULL,
  PRIMARY KEY (`verification_token_id`),
  INDEX `fk_so_verification_token_so_user1_idx` (`user_id` ASC) ,
  INDEX `idx_user_token_token` (`verification_token_token` ASC) ,
  CONSTRAINT `fk_so_verification_token_so_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'This table is used when user first registers. The token is sent via email. If the token is valid, email is validated.';


-- -----------------------------------------------------
-- Table `socatel`.`so_theme`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_theme` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_theme` (
  `theme_id` INT NOT NULL AUTO_INCREMENT,
  `theme_name` VARCHAR(45) NULL,
  PRIMARY KEY (`theme_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_group_theme`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_group_theme` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_group_theme` (
  `group_id` INT NOT NULL,
  `theme_id` INT NOT NULL,
  PRIMARY KEY (`group_id`, `theme_id`),
  INDEX `fk_so_group_theme_so_theme1_idx` (`theme_id` ASC) ,
  CONSTRAINT `fk_so_group_theme_so_group1`
    FOREIGN KEY (`group_id`)
    REFERENCES `socatel`.`so_group` (`group_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_group_theme_so_theme1`
    FOREIGN KEY (`theme_id`)
    REFERENCES `socatel`.`so_theme` (`theme_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_service`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_service` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_service` (
  `service_id` INT NOT NULL AUTO_INCREMENT,
  `service_name` VARCHAR(255) NOT NULL,
  `organisation_id` INT NOT NULL,
  `group_id` INT NULL,
  `service_description` TEXT NULL,
  `native_service_description` TEXT NULL,
  `language_id` INT NOT NULL,
  `locality_id` INT NOT NULL,
  `service_status` TINYINT NOT NULL DEFAULT 0 COMMENT '0: suggested, 1: approved, 2: rejected',
  `service_website` TEXT NULL,
  `service_hashtag` TEXT NULL,
  `twitter_screen_name` TEXT NULL,
  `twitter_account_description` TEXT NULL,
  `twitter_user_id` INT NULL,
  `twitter_oauth_token` TEXT NULL,
  `twitter_oauth_secret` TEXT NULL,
  `facebook_oauth_token` TEXT NULL,
  `facebook_page_id` TEXT NULL,
  `document_id` INT NULL,
  PRIMARY KEY (`service_id`),
  INDEX `fk_so_service_so_organisation1_idx` (`organisation_id` ASC) ,
  INDEX `fk_so_service_so_group1_idx` (`group_id` ASC) ,
  INDEX `fk_so_service_so_language1_idx` (`language_id` ASC) ,
  INDEX `fk_so_service_so_locality1_idx` (`locality_id` ASC) ,
  INDEX `fk_so_service_so_document1_idx` (`document_id` ASC) ,
  CONSTRAINT `fk_so_service_so_organisation1`
    FOREIGN KEY (`organisation_id`)
    REFERENCES `socatel`.`so_organisation` (`organisation_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_service_so_group1`
    FOREIGN KEY (`group_id`)
    REFERENCES `socatel`.`so_group` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_service_so_language1`
    FOREIGN KEY (`language_id`)
    REFERENCES `socatel`.`so_language` (`language_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_service_so_locality1`
    FOREIGN KEY (`locality_id`)
    REFERENCES `socatel`.`so_locality` (`locality_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_service_so_document1`
    FOREIGN KEY (`document_id`)
    REFERENCES `socatel`.`so_document` (`document_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_user_post_vote`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_user_post_vote` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_user_post_vote` (
  `user_id` INT NOT NULL,
  `post_id` INT NOT NULL,
  `user_post_vote_type` TINYINT NULL COMMENT '0: no_vote, 1: down_vote, 2: up_vote',
  PRIMARY KEY (`user_id`, `post_id`),
  INDEX `fk_so_user_post_vote_so_post1_idx` (`post_id` ASC) ,
  CONSTRAINT `fk_so_user_post_vote_so_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_user_post_vote_so_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `socatel`.`so_post` (`post_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_proposition`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_proposition` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_proposition` (
  `proposition_id` INT NOT NULL AUTO_INCREMENT,
  `post_id` INT NULL,
  `proposition_text` TEXT NOT NULL,
  `proposition_type` TINYINT NULL COMMENT '0: Functionality, 1: Difficulty, 2: Benefit, 3: Cost, 4: Feasibility, 5: Market_Size',
  `user_id` INT NOT NULL,
  `proposition_upvotes` INT NOT NULL DEFAULT 0,
  `proposition_downvotes` INT NOT NULL DEFAULT 0,
  `proposition_visible` TINYINT NOT NULL DEFAULT 0 COMMENT '0: , 1: hidden',
  `proposition_pin` TINYINT NOT NULL DEFAULT 0 COMMENT '0: not_pinned, 1:pinned',
  `proposition_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `feedback_id` INT NULL,
  `proposition_hat` TINYINT NULL,
  PRIMARY KEY (`proposition_id`),
  INDEX `fk_so_proposition_so_post1_idx` (`post_id` ASC) ,
  INDEX `fk_so_proposition_so_user1_idx` (`user_id` ASC) ,
  INDEX `fk_so_proposition_so_feedback1_idx` (`feedback_id` ASC) ,
  CONSTRAINT `fk_so_proposition_so_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `socatel`.`so_post` (`post_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_proposition_so_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_proposition_so_feedback1`
    FOREIGN KEY (`feedback_id`)
    REFERENCES `socatel`.`so_feedback` (`feedback_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_password_reset_token`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_password_reset_token` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_password_reset_token` (
  `password_reset_token_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `password_reset_token_token` VARCHAR(100) NULL,
  `password_reset_token_expiry_date` TIMESTAMP NULL,
  PRIMARY KEY (`password_reset_token_id`),
  INDEX `fk_so_password_reset_token_so_user1_idx` (`user_id` ASC) ,
  INDEX `idx_user_password_reset_token_token` (`password_reset_token_token` ASC) ,
  CONSTRAINT `fk_so_verification_token_so_user10`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'This table is used when user first registers. The token is sent via email. If the token is valid, email is validated.';


-- -----------------------------------------------------
-- Table `socatel`.`so_proposition_user_vote`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_proposition_user_vote` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_proposition_user_vote` (
  `user_id` INT NOT NULL,
  `proposition_id` INT NOT NULL,
  `proposition_user_vote_type` TINYINT NULL,
  PRIMARY KEY (`user_id`, `proposition_id`),
  INDEX `fk_so_proposition_user_like_so_proposition1_idx` (`proposition_id` ASC) ,
  CONSTRAINT `fk_so_proposition_user_like_so_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_proposition_user_like_so_proposition1`
    FOREIGN KEY (`proposition_id`)
    REFERENCES `socatel`.`so_proposition` (`proposition_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_user_theme`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_user_theme` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_user_theme` (
  `user_id` INT NOT NULL,
  `theme_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `theme_id`),
  INDEX `fk_so_user_theme_so_theme1_idx` (`theme_id` ASC) ,
  CONSTRAINT `fk_so_user_theme_so_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_user_theme_so_theme1`
    FOREIGN KEY (`theme_id`)
    REFERENCES `socatel`.`so_theme` (`theme_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_skill`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_skill` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_skill` (
  `skill_id` INT NOT NULL AUTO_INCREMENT,
  `skill_name` VARCHAR(45) NULL,
  PRIMARY KEY (`skill_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_user_skill`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_user_skill` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_user_skill` (
  `user_id` INT NOT NULL,
  `skill_id` INT NOT NULL,
  PRIMARY KEY (`user_id`, `skill_id`),
  INDEX `fk_so_user_skill_so_skill1_idx` (`skill_id` ASC) ,
  CONSTRAINT `fk_so_user_skill_so_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_user_skill_so_skill1`
    FOREIGN KEY (`skill_id`)
    REFERENCES `socatel`.`so_skill` (`skill_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_report`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_report` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_report` (
  `report_id` INT NOT NULL AUTO_INCREMENT,
  `report_reason` TINYINT NOT NULL,
  `accuser_id` INT NOT NULL,
  `reported_id` INT NOT NULL,
  `post_id` INT NULL,
  `proposition_id` INT NULL,
  `report_text` TEXT NULL,
  `report_status` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`report_id`),
  INDEX `fk_so_report_so_user1_idx` (`accuser_id` ASC) ,
  INDEX `fk_so_report_so_user2_idx` (`reported_id` ASC) ,
  INDEX `fk_so_report_so_post1_idx` (`post_id` ASC) ,
  INDEX `fk_so_report_so_proposition1_idx` (`proposition_id` ASC) ,
  CONSTRAINT `fk_so_report_so_user1`
    FOREIGN KEY (`accuser_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_report_so_user2`
    FOREIGN KEY (`reported_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_report_so_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `socatel`.`so_post` (`post_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_report_so_proposition1`
    FOREIGN KEY (`proposition_id`)
    REFERENCES `socatel`.`so_proposition` (`proposition_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_service_theme`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_service_theme` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_service_theme` (
  `service_id` INT NOT NULL,
  `theme_id` INT NOT NULL,
  PRIMARY KEY (`service_id`, `theme_id`),
  INDEX `fk_so_service_theme_so_theme1_idx` (`theme_id` ASC) ,
  CONSTRAINT `fk_so_service_theme_so_service1`
    FOREIGN KEY (`service_id`)
    REFERENCES `socatel`.`so_service` (`service_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_service_theme_so_theme1`
    FOREIGN KEY (`theme_id`)
    REFERENCES `socatel`.`so_theme` (`theme_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_user_feedback_vote`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_user_feedback_vote` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_user_feedback_vote` (
  `feedback_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `user_feedback_vote_type` TINYINT NULL COMMENT '0: no_vote, 1: down_vote, 2: up_vote',
  PRIMARY KEY (`feedback_id`, `user_id`),
  INDEX `fk_so_user_feedback_vote_so_user1_idx` (`user_id` ASC) ,
  CONSTRAINT `fk_so_user_feedback_vote_so_feedback1`
    FOREIGN KEY (`feedback_id`)
    REFERENCES `socatel`.`so_feedback` (`feedback_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_user_feedback_vote_so_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_question` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_question` (
  `question_id` INT NOT NULL AUTO_INCREMENT,
  `question_text` VARCHAR(255) NOT NULL,
  `question_type` TINYINT NOT NULL,
  `group_id` INT NOT NULL,
  PRIMARY KEY (`question_id`),
  INDEX `fk_so_question_so_group1_idx` (`group_id` ASC) ,
  CONSTRAINT `fk_so_question_so_group1`
    FOREIGN KEY (`group_id`)
    REFERENCES `socatel`.`so_group` (`group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_answer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_answer` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_answer` (
  `answer_id` INT NOT NULL AUTO_INCREMENT,
  `answer_text` VARCHAR(255) NOT NULL,
  `question_id` INT NULL,
  `feedback_id` INT NULL,
  PRIMARY KEY (`answer_id`),
  INDEX `fk_so_answer_so_question1_idx` (`question_id` ASC) ,
  INDEX `fk_so_answer_so_feedback1_idx` (`feedback_id` ASC) ,
  CONSTRAINT `fk_so_answer_so_question1`
    FOREIGN KEY (`question_id`)
    REFERENCES `socatel`.`so_question` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_answer_so_feedback1`
    FOREIGN KEY (`feedback_id`)
    REFERENCES `socatel`.`so_feedback` (`feedback_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `socatel`.`so_user_answer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `socatel`.`so_user_answer` ;

CREATE TABLE IF NOT EXISTS `socatel`.`so_user_answer` (
  `answer_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`answer_id`, `user_id`),
  INDEX `fk_so_user_answer_so_user1_idx` (`user_id` ASC) ,
  CONSTRAINT `fk_so_user_answer_so_answer1`
    FOREIGN KEY (`answer_id`)
    REFERENCES `socatel`.`so_answer` (`answer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_so_user_answer_so_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `socatel`.`so_user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
