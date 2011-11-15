Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1KOHyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 02:54:04 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:47778 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753446Ab1KOHx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 02:53:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        usb-storage@lists.one-eyed-alien.net,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 06/13] usb: storage: isd200: fix sparse warning
Date: Tue, 15 Nov 2011 09:53:33 +0200
Message-Id: <1321343620-10794-7-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1321343620-10794-1-git-send-email-balbi@ti.com>
References: <1321343620-10794-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warning:

| drivers/usb/storage/freecom.c:122:22: warning: symbol
|	'freecom_usb_ids' was not declared. Should it
|	be static?

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/storage/isd200.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index ffc4193..7b81303 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -76,7 +76,7 @@ static int isd200_Initialization(struct us_data *us);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id isd200_usb_ids[] = {
+static struct usb_device_id isd200_usb_ids[] = {
 #	include "unusual_isd200.h"
 	{ }		/* Terminating entry */
 };
-- 
1.7.8.rc0

