Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab1EFAmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:42:44 -0400
Received: from kroah.org ([198.145.64.141]:37216 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416Ab1EFAZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:16 2011
Message-Id: <20110506002216.239097490@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rezwanul Kabir <Rezwanul_Kabir@dell.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [112/143] dell-laptop: Add another Dell laptop family to the DMI whitelist
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Rezwanul Kabir <Rezwanul_Kabir@dell.com>

commit 410d44c74cf9942e3055d5b7d73953fac8efbacb upstream.

This is to support Precision M4500 and others.

Signed-off-by: Rezwanul Kabir <Rezwanul_Kabir@dell.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/dell-laptop.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -72,6 +72,12 @@ static const struct dmi_system_id __init
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
@@ -404,4 +410,5 @@ MODULE_AUTHOR("Matthew Garrett <mjg@redh
 MODULE_DESCRIPTION("Dell laptop driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("dmi:*svnDellInc.:*:ct8:*");
+MODULE_ALIAS("dmi:*svnDellInc.:*:ct9:*");
 MODULE_ALIAS("dmi:*svnDellComputerCorporation.:*:ct8:*");


