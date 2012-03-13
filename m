Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965171Ab2CMAko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:40:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:48546 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759075Ab2CMAYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Rezwanul Kabir <Rezwanul_Kabir@dell.com>,
        Matthew Garrett <mjg@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 149/196] dell-laptop: Add another Dell laptop family to the DMI whitelist
Date: Mon, 12 Mar 2012 20:21:02 -0400
Message-Id: <1331598109-31424-104-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rezwanul Kabir <Rezwanul_Kabir@dell.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 410d44c74cf9942e3055d5b7d73953fac8efbacb upstream.

This is to support Precision M4500 and others.

Signed-off-by: Rezwanul Kabir <Rezwanul_Kabir@dell.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/platform/x86/dell-laptop.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 6110601..0fb56e0 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -83,6 +83,12 @@ static const struct dmi_system_id __initdata dell_device_table[] = {
 		},
 	},
 	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "9"), /*Laptop*/
+		},
+	},
+	{
 		.ident = "Dell Computer Corporation",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
@@ -628,4 +634,5 @@ MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
 MODULE_DESCRIPTION("Dell laptop driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("dmi:*svnDellInc.:*:ct8:*");
+MODULE_ALIAS("dmi:*svnDellInc.:*:ct9:*");
 MODULE_ALIAS("dmi:*svnDellComputerCorporation.:*:ct8:*");
-- 
1.7.9.3

