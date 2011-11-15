Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab1KOHza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 02:55:30 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:48854 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753611Ab1KOHyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 02:54:03 -0500
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        usb-storage@lists.one-eyed-alien.net,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 08/13] usb: storage: karma: fix sparse warning
Date: Tue, 15 Nov 2011 09:53:35 +0200
Message-Id: <1321343620-10794-9-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1321343620-10794-1-git-send-email-balbi@ti.com>
References: <1321343620-10794-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warning:

| drivers/usb/storage/karma.c:62:22: warning: symbol
|	'karma_usb_ids' was not declared. Should it
|	be static?

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/storage/karma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/karma.c b/drivers/usb/storage/karma.c
index ba1b789..fb5bfb0 100644
--- a/drivers/usb/storage/karma.c
+++ b/drivers/usb/storage/karma.c
@@ -59,7 +59,7 @@ static int rio_karma_init(struct us_data *us);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
-struct usb_device_id karma_usb_ids[] = {
+static struct usb_device_id karma_usb_ids[] = {
 #	include "unusual_karma.h"
 	{ }		/* Terminating entry */
 };
-- 
1.7.8.rc0

