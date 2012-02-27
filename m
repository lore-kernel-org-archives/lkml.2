Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab2B0EQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 23:16:50 -0500
Received: from mailgw01.mediatek.com ([218.249.47.110]:56973 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753447Ab2B0EQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 23:16:49 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Feb 2012 23:16:48 EST
From: =?utf-8?B?TWVuZyBaaGFuZyAo5byg6JCMKQ==?= <Meng.Zhang@mediatek.com>
To: "smurf@smurf.noris.de" <smurf@smurf.noris.de>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 27 Feb 2012 12:11:37 +0800
Subject: [PATCH] USB: option: Add MediaTek MT6276M modem&app interfaces
Thread-Topic: [PATCH] USB: option: Add MediaTek MT6276M modem&app interfaces
Thread-Index: Acz1BeZ28G1tqn2lR3mjK/u78LKFfA==
Message-ID: <0D3EFCAF29FAA54FB91286E54DF1085C2304850460@MTKMBS30.mediatek.inc>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1R4GuYw016095

1. To declare the product IDs in option.c
2. Please pull from
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
   to get these changes

Signed-off-by: Meng Zhang <meng.zhang@mediatek.com>
---------------------------------------------------------------------------------------

drivers/usb/serial/option.c |    7 +++++++
1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index b54afce..7069f9d 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -484,6 +484,9 @@ static void option_instat_callback(struct urb *urb);
 #define LG_VENDOR_ID                           0x1004
 #define LG_PRODUCT_L02C                                0x618f
 
+/* MediaTek products */
+#define MEDIATEK_VENDOR_ID                     0x0e8d
+
 /* some devices interfaces need special handling due to a number of reasons */
 enum option_blacklist_reason {
                OPTION_BLACKLIST_NONE = 0,
@@ -1198,6 +1201,10 @@ static const struct usb_device_id option_ids[] = {
        { USB_DEVICE_AND_INTERFACE_INFO(VIETTEL_VENDOR_ID, VIETTEL_PRODUCT_VT1000, 0xff, 0xff, 0xff) },
        { USB_DEVICE_AND_INTERFACE_INFO(ZD_VENDOR_ID, ZD_PRODUCT_7000, 0xff, 0xff, 0xff) },
        { USB_DEVICE(LG_VENDOR_ID, LG_PRODUCT_L02C) }, /* docomo L-02C modem */
+       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff, 0x00, 0x00) },
+       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 0xff, 0x02, 0x01) },
+       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 0x00, 0x00) },
+       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 0xff, 0x02, 0x01) },        /* MediaTek MT6276M modem & app port */
        { } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
