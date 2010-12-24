Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab0LXIzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 03:55:04 -0500
Received: from gretel.risen.be ([78.46.99.137]:50829 "EHLO gretel.risen.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab0LXIzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 03:55:02 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Dec 2010 03:55:02 EST
Message-ID: <4D145EB5.7090205@aquazul.com>
Date: Fri, 24 Dec 2010 09:49:57 +0100
From: Mourad De Clerck <mourad@aquazul.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Icedove/3.1.7
MIME-Version: 1.0
To: Richard Purdie <rpurdie@linux.intel.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH,RESEND] backlight: mbp_nvidia_bl - add support for MacBookPro7,1
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the MacBookPro7,1 (13" mid 2010) to the mbp_nvidia_bl
driver.

Signed-off-by: Mourad De Clerck <mourad@aquazul.com>
---
 drivers/video/backlight/mbp_nvidia_bl.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c
b/drivers/video/backlight/mbp_nvidia_bl.c
index 9fb533f..9c44314 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -335,6 +335,15 @@ static const struct dmi_system_id __initdata
mbp_device_table[] = {
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

