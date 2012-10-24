Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781Ab2JXA3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 20:29:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933570Ab2JXA3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 20:29:20 -0400
Date: Tue, 23 Oct 2012 20:29:15 -0400
From: Dave Jones <davej@redhat.com>
To: gregkh@linuxfoundation.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Add missing license tag to ezusb driver.
Message-ID: <20121024002915.GA10086@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, gregkh@linuxfoundation.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ezusb: module license 'unspecified' taints kernel

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/usb/misc/ezusb.c b/drivers/usb/misc/ezusb.c
index 4223d76..6589268 100644
--- a/drivers/usb/misc/ezusb.c
+++ b/drivers/usb/misc/ezusb.c
@@ -158,3 +158,4 @@ int ezusb_fx2_ihex_firmware_download(struct usb_device *dev,
 }
 EXPORT_SYMBOL_GPL(ezusb_fx2_ihex_firmware_download);
 
+MODULE_LICENSE("GPL");
