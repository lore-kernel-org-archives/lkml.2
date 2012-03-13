Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030178Ab2CMAii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:38:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:48619 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964Ab2CMAYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "Edgar (gimli) Hucek" <gimli@dark-green.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 156/196] backlight: MacBookAir3,1(3,2) mbp-nvidia-bl support
Date: Mon, 12 Mar 2012 20:21:09 -0400
Message-Id: <1331598109-31424-111-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Edgar (gimli) Hucek" <gimli@dark-green.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit bd760e1e5b34351e0705705e5163cb89c1316d71 upstream.

Add support for the MacBookAir3,1 and MacBookAir3,2 to the mbp-nvidia-bl
driver.

Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/video/backlight/mbp_nvidia_bl.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 1b5d3fe..0f5268e 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -290,6 +290,24 @@ static const struct dmi_system_id __initdata mbp_device_table[] = {
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
 
-- 
1.7.9.3

