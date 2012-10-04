Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260Ab2JDAcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 20:32:14 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:47533 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013Ab2JDAcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 20:32:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-usb@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/2] usb: gadget: Make webcam gadget select USB_LIBCOMPOSITE
Date: Thu,  4 Oct 2012 02:32:41 +0200
Message-Id: <1349310762-14209-2-git-send-email-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1349310762-14209-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <506B554A.70102@xenotime.net>
 <1349310762-14209-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Composite gadget support is now available as a library instead of being
built with each gadget. Composite drivers need to select
USB_LIBCOMPOSITE.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/usb/gadget/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index dfb51a4..e0ff51b 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -952,6 +952,7 @@ endif
 config USB_G_WEBCAM
 	tristate "USB Webcam Gadget"
 	depends on VIDEO_DEV
+	select USB_LIBCOMPOSITE
 	help
 	  The Webcam Gadget acts as a composite USB Audio and Video Class
 	  device. It provides a userspace API to process UVC control requests
-- 
1.7.8.6

