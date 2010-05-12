Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0ELQ6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 12:58:33 -0400
Received: from kroah.org ([198.145.64.141]:59291 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab0ELQ6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 12:58:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: mjg@redhat.com
Cc: mzxreary@0pointer.de, rpurdie@linux.intel.com, jlee@novell.com,
       linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
       greg@kroah.com, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/4] msi-laptop: Add N014 N051 dmi information to scm models table
Date: Wed, 12 May 2010 09:58:07 -0700
Message-Id: <1273683490-27090-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100512141149.GB20564@kroah.com>
References: <20100512141149.GB20564@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee, Chun-Yi <jlee@novell.com>

Add new MSI netbook N014 and N051 dmi information to scm models table.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/msi-laptop.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 996223a..bcd9c0d 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -469,6 +469,26 @@ static struct dmi_system_id __initdata msi_dmi_table[] = {
 		},
 		.callback = dmi_check_cb
 	},
+	{
+		.ident = "MSI N051",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR,
+				"MICRO-STAR INTERNATIONAL CO., LTD"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MS-N051"),
+			DMI_MATCH(DMI_CHASSIS_VENDOR,
+			"MICRO-STAR INTERNATIONAL CO., LTD")
+		},
+		.callback = dmi_check_cb
+	},
+	{
+		.ident = "MSI N014",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR,
+				"MICRO-STAR INTERNATIONAL CO., LTD"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MS-N014"),
+		},
+		.callback = dmi_check_cb
+	},
 	{ }
 };
 
@@ -788,3 +808,5 @@ MODULE_ALIAS("dmi:*:svnMicro-StarInternational:pnMS-1058:pvr0581:rvnMSI:rnMS-105
 MODULE_ALIAS("dmi:*:svnMicro-StarInternational:pnMS-1412:*:rvnMSI:rnMS-1412:*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
 MODULE_ALIAS("dmi:*:svnNOTEBOOK:pnSAM2000:pvr0131*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
 MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N034:*");
+MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N051:*");
+MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N014:*");
-- 
1.7.1

