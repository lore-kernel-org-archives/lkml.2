Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab1EFAk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:40:58 -0400
Received: from kroah.org ([198.145.64.141]:37290 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459Ab1EFAZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:17 2011
Message-Id: <20110506002217.276457898@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Edgar (gimli) Hucek" <gimli@dark-green.com>,
        Richard Purdie <rpurdie@linux.intel.com>
Subject: [122/143] backlight: MacBookAir3,1(3,2) mbp-nvidia-bl support
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Edgar (gimli) Hucek <gimli@dark-green.com>

commit bd760e1e5b34351e0705705e5163cb89c1316d71 upstream.

Add support for the MacBookAir3,1 and MacBookAir3,2 to the mbp-nvidia-bl
driver.

Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/video/backlight/mbp_nvidia_bl.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -272,6 +272,24 @@ static const struct dmi_system_id __init
 		},
 		.driver_data	= (void *)&nvidia_chipset_data,
 	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookAir 3,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,1"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookAir 3,2",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,2"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
 	{ }
 };
 


