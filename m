Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab2LQW1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:27:55 -0500
Received: from mail209.messagelabs.com ([216.82.255.3]:44887 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2LQW1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:27:54 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1355783249!6567260!32
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.8; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] HID: hid.h: remove unused hid_generic_{init,exit} prototypes
Date: Mon, 17 Dec 2012 15:27:33 -0700
User-Agent: KMail/1.9.9
CC: <jkosina@suse.cz>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201212171527.33761.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are not defined. Remove the extern declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Jiri Kosina <jkosina@suse.cz>
---
 include/linux/hid.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index d6c71a6..828726c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -884,9 +884,6 @@ static inline int hid_hw_power(struct hid_device *hdev, int level)
 int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 		int interrupt);
 
-extern int hid_generic_init(void);
-extern void hid_generic_exit(void);
-
 /* HID quirks API */
 u32 usbhid_lookup_quirk(const u16 idVendor, const u16 idProduct);
 int usbhid_quirks_init(char **quirks_param);
-- 
1.8.0.2

