Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab0KDAiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 20:38:07 -0400
Received: from gretel.risen.be ([78.46.99.137]:48066 "EHLO gretel.risen.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab0KDAiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 20:38:06 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Nov 2010 20:38:06 EDT
Message-ID: <4CD1FF3A.2070305@aquazul.com>
Date: Thu, 04 Nov 2010 01:32:58 +0100
From: Mourad De Clerck <mourad@aquazul.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100918 Icedove/3.1.4
MIME-Version: 1.0
To: Richard Purdie <rpurdie@linux.intel.com>
CC: Mario Schwalbe <schwalbe@inf.tu-dresden.de>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] backlight: mbp_nvidia_bl - add support for MacBookPro7,1
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the MacBook Pro 7,1 (13" mid 2010)

Signed-off-by: Mourad De Clerck <mourad@aquazul.com>
---
 drivers/video/backlight/mbp_nvidia_bl.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 9fb533f..9c44314 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -335,6 +335,15 @@ static const struct dmi_system_id __initdata mbp_device_table[] = {
 		},
 		.driver_data	= (void *)&nvidia_chipset_data,
 	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookPro 7,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro7,1"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
 	{ }
 };
 

