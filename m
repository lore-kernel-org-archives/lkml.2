Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab0KBRXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 13:23:48 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:61644 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab0KBRXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 13:23:42 -0400
X-Greylist: delayed 1196 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Nov 2010 13:23:42 EDT
Subject: Re: [PATCH 5/6] MacBookAir3,1(3,2) mbp-nvidia-bl support
From: Richard Purdie <rpurdie@linux.intel.com>
To: gimli <gimli@dark-green.com>, akpm <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f11db0f4867ff147eee56d54710390ea@mognix.dark-green.com>
References: <f11db0f4867ff147eee56d54710390ea@mognix.dark-green.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 17:02:36 +0000
Message-ID: <1288717356.28481.1834.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 08:21 +0100, gimli wrote:
> This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the
> mbp-nvidia-bl driver.
> 
> Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>

Acked-by: Richard Purdie <rpurdie@linux.intel.com>

--- a/drivers/video/backlight/mbp_nvidia_bl.c.orig      2010-10-26 14:41:15.656640822 +0200
+++ b/drivers/video/backlight/mbp_nvidia_bl.c   2010-10-26 14:42:07.976640822 +0200
@@ -335,6 +335,24 @@
                },
                .driver_data    = (void *)&nvidia_chipset_data,
        },
+       {
+               .callback       = mbp_dmi_match,
+               .ident          = "MacBookAir 3,1",
+               .matches        = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,1"),
+               },
+               .driver_data    = (void *)&nvidia_chipset_data,
+       },
+       {
+               .callback       = mbp_dmi_match,
+               .ident          = "MacBookAir 3,2",
+               .matches        = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,2"),
+               },
+               .driver_data    = (void *)&nvidia_chipset_data,
+       },
        { }
 };
 

