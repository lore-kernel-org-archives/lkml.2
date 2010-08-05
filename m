Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886Ab0HEWar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:30:47 -0400
Received: from kroah.org ([198.145.64.141]:37842 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934586Ab0HEWZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:25:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/28] leds: Remove owner field from attribute initialization in bd2802 driver
Date: Thu,  5 Aug 2010 15:24:14 -0700
Message-Id: <1281047058-23716-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <guenter.roeck@ericsson.com>

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/leds/leds-bd2802.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index 5dcdf9d..19dc4b6 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -351,7 +351,7 @@ static ssize_t bd2802_store_reg##reg_addr(struct device *dev,		\
 	return count;							\
 }									\
 static struct device_attribute bd2802_reg##reg_addr##_attr = {		\
-	.attr = {.name = reg_name, .mode = 0644, .owner = THIS_MODULE},	\
+	.attr = {.name = reg_name, .mode = 0644},			\
 	.store = bd2802_store_reg##reg_addr,				\
 };
 
@@ -482,7 +482,6 @@ static struct device_attribute bd2802_adv_conf_attr = {
 	.attr = {
 		.name = "advanced_configuration",
 		.mode = 0644,
-		.owner = THIS_MODULE
 	},
 	.show = bd2802_show_adv_conf,
 	.store = bd2802_store_adv_conf,
@@ -519,7 +518,6 @@ static struct device_attribute bd2802_##attr_name##_attr = {		\
 	.attr = {							\
 		.name = name_str,					\
 		.mode = 0644,						\
-		.owner = THIS_MODULE					\
 	},								\
 	.show = bd2802_show_##attr_name,				\
 	.store = bd2802_store_##attr_name,				\
-- 
1.7.2

