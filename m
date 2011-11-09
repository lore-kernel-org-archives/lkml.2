Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252Ab1KJFVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:21:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933942Ab1KJDXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:23:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:07 2011
Message-Id: <20111109212707.555015724@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>
Subject: [071/262] Platform: samsung_laptop: add support for X520 machines.
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tommaso Massimi <tmassimi@gmail.com>

commit 7500eeb08a179e61a4219288c21407d63d1e9c64 upstream.

my samsung laptop would be very happy if you add
these lines to the file drivers/platform/x86/samsung-laptop.c

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Matthew Garrett <mjg@redhat.com>

---
 drivers/platform/x86/samsung-laptop.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -685,6 +685,15 @@ static struct dmi_system_id __initdata s
 		},
 		.callback = dmi_check_cb,
 	},
+		{
+		.ident = "X520",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X520"),
+			DMI_MATCH(DMI_BOARD_NAME, "X520"),
+		},
+		.callback = dmi_check_cb,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);


