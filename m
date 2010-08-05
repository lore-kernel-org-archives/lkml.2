Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925Ab0HEW1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:27:04 -0400
Received: from kroah.org ([198.145.64.141]:37835 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934580Ab0HEWZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:25:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/28] scsi: Remove owner field from attribute initialization in ARCMSR driver
Date: Thu,  5 Aug 2010 15:24:13 -0700
Message-Id: <1281047058-23716-23-git-send-email-gregkh@suse.de>
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
 drivers/scsi/arcmsr/arcmsr_attr.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index 07fdfe5..a4e04c5 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -192,7 +192,6 @@ static struct bin_attribute arcmsr_sysfs_message_read_attr = {
 	.attr = {
 		.name = "mu_read",
 		.mode = S_IRUSR ,
-		.owner = THIS_MODULE,
 	},
 	.size = 1032,
 	.read = arcmsr_sysfs_iop_message_read,
@@ -202,7 +201,6 @@ static struct bin_attribute arcmsr_sysfs_message_write_attr = {
 	.attr = {
 		.name = "mu_write",
 		.mode = S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 1032,
 	.write = arcmsr_sysfs_iop_message_write,
@@ -212,7 +210,6 @@ static struct bin_attribute arcmsr_sysfs_message_clear_attr = {
 	.attr = {
 		.name = "mu_clear",
 		.mode = S_IWUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = 1,
 	.write = arcmsr_sysfs_iop_message_clear,
-- 
1.7.2

