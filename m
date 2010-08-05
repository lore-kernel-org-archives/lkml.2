Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607Ab0HEW1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:27:13 -0400
Received: from kroah.org ([198.145.64.141]:37828 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934576Ab0HEWZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:25:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/28] scsi: Remove owner field from attribute initialization in LPFC driver
Date: Thu,  5 Aug 2010 15:24:12 -0700
Message-Id: <1281047058-23716-22-git-send-email-gregkh@suse.de>
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
 drivers/scsi/lpfc/lpfc_attr.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 868874c..162704c 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2778,7 +2778,6 @@ static struct bin_attribute sysfs_drvr_stat_data_attr = {
 	.attr = {
 		.name = "lpfc_drvr_stat_data",
 		.mode = S_IRUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = LPFC_MAX_TARGET * MAX_STAT_DATA_SIZE_PER_TARGET,
 	.read = sysfs_drvr_stat_data_read,
-- 
1.7.2

