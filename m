Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0JNJjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:39:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51161 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab0JNJjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:39:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kuS/YwVrDt7pqpsnRMGG8dJbVGRe5fb2qVFCZYL61j5/wIaUsNgJXoAtKaWpxAf8nv
         yCzZyv9BA7g4Ue8cWM4BULhdQXag91CKqbmz8ddhf+0YRJw/+ADCiI7qErnZAcSdRSIY
         OmRegQPQLN6ic0KDuWViR/XEg+jaLX43oUGr8=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 2/5] staging:ft1000: lines over 80 characters corrected.
Date: Thu, 14 Oct 2010 11:40:57 +0200
Message-Id: <1287049260-11988-3-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287049260-11988-1-git-send-email-marek.belisko@gmail.com>
References: <1287049260-11988-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |   63 ++++++++++++++++--------
 1 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 7c002ab..fc817cb 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -68,7 +68,8 @@ int ft1000_poll_thread(void *arg)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static int ft1000_probe(struct usb_interface *interface, const struct usb_device_id *id)
+static int ft1000_probe(struct usb_interface *interface,
+			const struct usb_device_id *id)
 {
     struct usb_host_interface *iface_desc;
     struct usb_endpoint_descriptor *endpoint;
@@ -92,7 +93,8 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
 
     dev = interface_to_usbdev(interface);
     DEBUG("ft1000_probe: usb device descriptor info:\n");
-    DEBUG("ft1000_probe: number of configuration is %d\n", dev->descriptor.bNumConfigurations);
+	DEBUG("ft1000_probe: number of configuration is %d\n",
+	      dev->descriptor.bNumConfigurations);
 
 	ft1000dev->dev = dev;
 	ft1000dev->status = 0;
@@ -106,32 +108,52 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
     numaltsetting = interface->num_altsetting;
     DEBUG("ft1000_probe: number of alt settings is :%d\n", numaltsetting);
     iface_desc = interface->cur_altsetting;
-    DEBUG("ft1000_probe: number of endpoints is %d\n", iface_desc->desc.bNumEndpoints);
-    DEBUG("ft1000_probe: descriptor type is %d\n", iface_desc->desc.bDescriptorType);
-    DEBUG("ft1000_probe: interface number is %d\n", iface_desc->desc.bInterfaceNumber);
-    DEBUG("ft1000_probe: alternatesetting is %d\n", iface_desc->desc.bAlternateSetting);
-    DEBUG("ft1000_probe: interface class is %d\n", iface_desc->desc.bInterfaceClass);
+	DEBUG("ft1000_probe: number of endpoints is %d\n",
+	      iface_desc->desc.bNumEndpoints);
+	DEBUG("ft1000_probe: descriptor type is %d\n",
+	      iface_desc->desc.bDescriptorType);
+	DEBUG("ft1000_probe: interface number is %d\n",
+	      iface_desc->desc.bInterfaceNumber);
+	DEBUG("ft1000_probe: alternatesetting is %d\n",
+	      iface_desc->desc.bAlternateSetting);
+	DEBUG("ft1000_probe: interface class is %d\n",
+	      iface_desc->desc.bInterfaceClass);
     DEBUG("ft1000_probe: control endpoint info:\n");
-    DEBUG("ft1000_probe: descriptor0 type -- %d\n", iface_desc->endpoint[0].desc.bmAttributes);
-    DEBUG("ft1000_probe: descriptor1 type -- %d\n", iface_desc->endpoint[1].desc.bmAttributes);
-    DEBUG("ft1000_probe: descriptor2 type -- %d\n", iface_desc->endpoint[2].desc.bmAttributes);
+	DEBUG("ft1000_probe: descriptor0 type -- %d\n",
+	      iface_desc->endpoint[0].desc.bmAttributes);
+	DEBUG("ft1000_probe: descriptor1 type -- %d\n",
+	      iface_desc->endpoint[1].desc.bmAttributes);
+	DEBUG("ft1000_probe: descriptor2 type -- %d\n",
+	      iface_desc->endpoint[2].desc.bmAttributes);
 
     for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
-		endpoint = (struct usb_endpoint_descriptor *)&iface_desc->endpoint[i].desc;
+		endpoint =
+		    (struct usb_endpoint_descriptor *)&iface_desc->endpoint[i].
+		    desc;
                 DEBUG("endpoint %d\n", i);
-                DEBUG("bEndpointAddress=%x, bmAttributes=%x\n", endpoint->bEndpointAddress, endpoint->bmAttributes);
-		if ((endpoint->bEndpointAddress & USB_DIR_IN) && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_BULK)) {
-			ft1000dev->bulk_in_endpointAddr = endpoint->bEndpointAddress;
-			DEBUG("ft1000_probe: in: %d\n", endpoint->bEndpointAddress);
+		DEBUG("bEndpointAddress=%x, bmAttributes=%x\n",
+		      endpoint->bEndpointAddress, endpoint->bmAttributes);
+		if ((endpoint->bEndpointAddress & USB_DIR_IN)
+		    && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
+			USB_ENDPOINT_XFER_BULK)) {
+			ft1000dev->bulk_in_endpointAddr =
+				endpoint->bEndpointAddress;
+			DEBUG("ft1000_probe: in: %d\n",
+			      endpoint->bEndpointAddress);
 		}
 
-		if (!(endpoint->bEndpointAddress & USB_DIR_IN) && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_BULK)) {
-			ft1000dev->bulk_out_endpointAddr = endpoint->bEndpointAddress;
-			DEBUG("ft1000_probe: out: %d\n", endpoint->bEndpointAddress);
+		if (!(endpoint->bEndpointAddress & USB_DIR_IN)
+		    && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
+			USB_ENDPOINT_XFER_BULK)) {
+			ft1000dev->bulk_out_endpointAddr =
+				endpoint->bEndpointAddress;
+			DEBUG("ft1000_probe: out: %d\n",
+			      endpoint->bEndpointAddress);
 		}
     }
 
-    DEBUG("bulk_in=%d, bulk_out=%d\n", ft1000dev->bulk_in_endpointAddr, ft1000dev->bulk_out_endpointAddr);
+	DEBUG("bulk_in=%d, bulk_out=%d\n", ft1000dev->bulk_in_endpointAddr,
+	      ft1000dev->bulk_out_endpointAddr);
 
 	ret = request_firmware(&dsp_fw, "ft3000.img", &dev->dev);
 	if (ret < 0) {
@@ -164,7 +186,8 @@ static int ft1000_probe(struct usb_interface *interface, const struct usb_device
 	}
 
 	gPollingfailed = FALSE;
-    pft1000info->pPollThread = kthread_run(ft1000_poll_thread, ft1000dev, "ft1000_poll");
+	pft1000info->pPollThread =
+	    kthread_run(ft1000_poll_thread, ft1000dev, "ft1000_poll");
 	msleep(500);
 
 	while (!pft1000info->CardReady) {
-- 
1.7.1

