Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627Ab2DJW3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 18:29:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54615 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759572Ab2DJW3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 18:29:31 -0400
From: Josenivaldo Benito Junior <jrbenito@benito.qsl.br>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Cc: Franco Catrin <fcatrin@gmail.com>,
        Josenivaldo Benito Junior <jrbenito@benito.qsl.br>
Subject: [PATCH 2/3] HID: hid-core: Adding hid-aureal special driver
Date: Tue, 10 Apr 2012 19:29:05 -0300
Message-Id: <1334096946-18788-3-git-send-email-jrbenito@benito.qsl.br>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334096946-18788-1-git-send-email-jrbenito@benito.qsl.br>
References: <1334096946-18788-1-git-send-email-jrbenito@benito.qsl.br>
In-Reply-To: <alpine.LNX.2.00.1204090207090.24006@pobox.suse.cz>
References: <alpine.LNX.2.00.1204090207090.24006@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the hid-aureal special driver to hid-core. This avoid the necessity
of load module hid-aureal before module usbhid.

Signed-off-by: Josenivaldo Benito Junior <jrbenito@benito.qsl.br>
---
 drivers/hid/hid-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 94f0343..107a731 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1387,6 +1387,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUS_T91MT) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUS, USB_DEVICE_ID_ASUSTEK_MULTITOUCH_YFO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_AUREAL, USB_DEVICE_ID_AUREAL_W01RN) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE_2) },
-- 
1.7.5.4

