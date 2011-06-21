Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab1FUNCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:02:33 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:48731 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1FUNCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:02:02 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] hid-multitouch: correct VID for Stantum panels
Date: Tue, 21 Jun 2011 15:01:54 +0200
Message-Id: <1308661315-6240-3-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308661315-6240-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1308661315-6240-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while merging hid-stantum into hid-multitouch (commit
043b403aede4a528ed99ceaf050f567f1283a23e upstream), I did
not correctly copy/paste the VIDs for those devices.
This patch fixes it.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 3867656..467b518 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -706,10 +706,10 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM,
 			USB_DEVICE_ID_MTP)},
 	{ .driver_data = MT_CLS_CONFIDENCE,
-		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM,
+		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM,
 			USB_DEVICE_ID_MTP_STM)},
 	{ .driver_data = MT_CLS_CONFIDENCE,
-		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM,
+		HID_USB_DEVICE(USB_VENDOR_ID_STANTUM_SITRONIX,
 			USB_DEVICE_ID_MTP_SITRONIX)},
 
 	/* Touch International panels */
-- 
1.7.4.4

