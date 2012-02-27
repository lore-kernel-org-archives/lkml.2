Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2B0E5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 23:57:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40832 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab2B0E5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 23:57:42 -0500
Message-ID: <4F4B0D36.7080203@mediatek.com>
Date: Mon, 27 Feb 2012 12:57:26 +0800
From: Meng Zhang <meng.zhang@mediatek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: smurf@smurf.noris.de
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: option: Add MediaTek MT6276M modem&app interfaces
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from: Meng Zhang <meng.zhang@mediatek.com>

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
  /* some devices interfaces need special handling due to a number of 
reasons */
  enum option_blacklist_reason {
                 OPTION_BLACKLIST_NONE = 0,
@@ -1198,6 +1201,10 @@ static const struct usb_device_id option_ids[] = {
         { USB_DEVICE_AND_INTERFACE_INFO(VIETTEL_VENDOR_ID, 
VIETTEL_PRODUCT_VT1000, 0xff, 0xff, 0xff) },
         { USB_DEVICE_AND_INTERFACE_INFO(ZD_VENDOR_ID, ZD_PRODUCT_7000, 
0xff, 0xff, 0xff) },
         { USB_DEVICE(LG_VENDOR_ID, LG_PRODUCT_L02C) }, /* docomo L-02C 
modem */
+       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 
0xff, 0x00, 0x00) },
+       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a1, 
0xff, 0x02, 0x01) },
+       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 
0xff, 0x00, 0x00) },
+       { USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, 0x00a2, 
0xff, 0x02, 0x01) },        /* MediaTek MT6276M modem & app port */
         { } /* Terminating entry */
  };
  MODULE_DEVICE_TABLE(usb, option_ids);

