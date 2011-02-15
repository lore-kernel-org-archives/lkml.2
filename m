Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1BOOd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:33:57 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:56435 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab1BOOdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:33:54 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: add IRTOUCH infrared USB to hid_have_special_driver
Date: Tue, 15 Feb 2011 15:33:48 +0100
Message-Id: <1297780428-3805-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, the device is handled by hidinput and does
not have the right behavior.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
Hi guys,

In the previous patch including the support to IRTOUCH devices, I forgot to add it to hid_have_special_driver. Sorry.

Cheers,
Benjamin

 drivers/hid/hid-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d678cf3..a5f6439 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1345,6 +1345,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_3) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HANVON, USB_DEVICE_ID_HANVON_MULTITOUCH) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS, USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
-- 
1.7.4

