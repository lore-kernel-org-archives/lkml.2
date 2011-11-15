Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab1KOHyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 02:54:01 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:59528 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566Ab1KOHx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 02:53:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        usb-storage@lists.one-eyed-alien.net,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 07/13] usb: storage: jumpshot: fix sparse warning
Date: Tue, 15 Nov 2011 09:53:34 +0200
Message-Id: <1321343620-10794-8-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1321343620-10794-1-git-send-email-balbi@ti.com>
References: <1321343620-10794-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warning:

| drivers/usb/storage/jumpshot.c:74:22: warning: symbol
|	'jumpshot_usb_ids' was not declared. Should it
|	be static?

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/storage/jumpshot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumpshot.c
index 6168596..5ef55c7 100644
--- a/drivers/usb/storage/jumpshot.c
+++ b/drivers/usb/storage/jumpshot.c
@@ -71,7 +71,7 @@ MODULE_LICENSE("GPL");
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id jumpshot_usb_ids[] = {
+static struct usb_device_id jumpshot_usb_ids[] = {
 #	include "unusual_jumpshot.h"
 	{ }		/* Terminating entry */
 };
-- 
1.7.8.rc0

