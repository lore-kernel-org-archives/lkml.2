Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab0ELQ6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 12:58:35 -0400
Received: from kroah.org ([198.145.64.141]:59301 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab0ELQ6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 12:58:33 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: mjg@redhat.com
Cc: mzxreary@0pointer.de, rpurdie@linux.intel.com, jlee@novell.com,
       linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
       greg@kroah.com, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/4] msi-laptop: Add MSI CR620 notebook dmi information to scm models table
Date: Wed, 12 May 2010 09:58:08 -0700
Message-Id: <1273683490-27090-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100512141149.GB20564@kroah.com>
References: <20100512141149.GB20564@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee, Chun-Yi <jlee@novell.com>

Add new MSI notebook CR620 dmi information to scm models table.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/msi-laptop.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index bcd9c0d..45197d7 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -489,6 +489,15 @@ static struct dmi_system_id __initdata msi_dmi_table[] = {
 		},
 		.callback = dmi_check_cb
 	},
+	{
+		.ident = "MSI CR620",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR,
+				"Micro-Star International"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CR620"),
+		},
+		.callback = dmi_check_cb
+	},
 	{ }
 };
 
@@ -810,3 +819,4 @@ MODULE_ALIAS("dmi:*:svnNOTEBOOK:pnSAM2000:pvr0131*:cvnMICRO-STARINT'LCO.,LTD:ct1
 MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N034:*");
 MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N051:*");
 MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N014:*");
+MODULE_ALIAS("dmi:*:svnMicro-StarInternational*:pnCR620:*");
-- 
1.7.1

