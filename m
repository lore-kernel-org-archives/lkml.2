Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab1EFAm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:42:59 -0400
Received: from kroah.org ([198.145.64.141]:37209 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab1EFAZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:16 2011
Message-Id: <20110506002216.126296204@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Erik Andren <erik.andren@gmail.com>
Subject: [111/143] dell-laptop: Add another Dell laptop to the DMI whitelist
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Erik Andren <erik.andren@gmail.com>

commit cb6a7937f4328a267e0806680ade500ed2c3c01a upstream.

The Latitude C640 has another variation of dell in its DMI vendor entry.
Add it to the whitelist in order to enjoy the sweet fruits of software
backlight toggling.

Signed-off-by: Erik Andren <erik.andren@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/dell-laptop.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -71,6 +71,13 @@ static const struct dmi_system_id __init
 			DMI_MATCH(DMI_CHASSIS_TYPE, "8"),
 		},
 	},
+	{
+		.ident = "Dell Computer Corporation",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "8"),
+		},
+	},
 	{ }
 };
 
@@ -397,3 +404,4 @@ MODULE_AUTHOR("Matthew Garrett <mjg@redh
 MODULE_DESCRIPTION("Dell laptop driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("dmi:*svnDellInc.:*:ct8:*");
+MODULE_ALIAS("dmi:*svnDellComputerCorporation.:*:ct8:*");


