Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab2EKKmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:42:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35076 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab2EKKmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:42:15 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 19/25] Staging: comedi: Checkpatch cleanups.
Date: Fri, 11 May 2012 16:08:07 +0530
Message-Id: <1336732693-7408-20-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/comedi/drivers/usbdux.c:2425: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:2450: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:2466: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:2489: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:2499: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:2515: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:2542: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:2551: WARNING: quoted string split across lines
drivers/staging/comedi/drivers/usbdux.c:2583: WARNING: quoted string split across lines

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/usbdux.c |   34 ++++++++++++++----------------
 1 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index bd71671..3297491 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2421,8 +2421,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	i = usb_set_interface(usbduxsub[index].usbdev,
 			      usbduxsub[index].ifnum, 3);
 	if (i < 0) {
-		dev_err(dev, "comedi_: usbdux%d: "
-			"could not set alternate setting 3 in high speed.\n",
+		dev_err(dev, "comedi_: usbdux%d: could not set alternate setting 3 in high speed.\n",
 			index);
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
@@ -2446,8 +2445,8 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		/* one frame: 1ms */
 		usbduxsub[index].urbIn[i] = usb_alloc_urb(1, GFP_KERNEL);
 		if (usbduxsub[index].urbIn[i] == NULL) {
-			dev_err(dev, "comedi_: usbdux%d: "
-				"Could not alloc. urb(%d)\n", index, i);
+			dev_err(dev, "comedi_: usbdux%d: Could not alloc. urb(%d)\n",
+				index, i);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2462,8 +2461,8 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbIn[i]->transfer_buffer =
 		    kzalloc(SIZEINBUF, GFP_KERNEL);
 		if (!(usbduxsub[index].urbIn[i]->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbdux%d: "
-				"could not alloc. transb.\n", index);
+			dev_err(dev, "comedi_: usbdux%d: could not alloc. transb.\n",
+				index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2485,8 +2484,7 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 	    kzalloc(sizeof(struct urb *) * usbduxsub[index].numOfOutBuffers,
 		    GFP_KERNEL);
 	if (!(usbduxsub[index].urbOut)) {
-		dev_err(dev, "comedi_: usbdux: "
-			"Could not alloc. urbOut array\n");
+		dev_err(dev, "comedi_: Could not alloc. urbOut array\n");
 		tidy_up(&(usbduxsub[index]));
 		up(&start_stop_sem);
 		return -ENOMEM;
@@ -2495,8 +2493,8 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		/* one frame: 1ms */
 		usbduxsub[index].urbOut[i] = usb_alloc_urb(1, GFP_KERNEL);
 		if (usbduxsub[index].urbOut[i] == NULL) {
-			dev_err(dev, "comedi_: usbdux%d: "
-				"Could not alloc. urb(%d)\n", index, i);
+			dev_err(dev, "comedi_: usbdux%d: Could not alloc. urb(%d)\n",
+				index, i);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2511,8 +2509,8 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbOut[i]->transfer_buffer =
 		    kzalloc(SIZEOUTBUF, GFP_KERNEL);
 		if (!(usbduxsub[index].urbOut[i]->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbdux%d: "
-				"could not alloc. transb.\n", index);
+			dev_err(dev, "comedi_: usbdux%d: could not alloc. transb.\n",
+				index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2538,8 +2536,8 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		usbduxsub[index].sizePwmBuf = 512;
 		usbduxsub[index].urbPwm = usb_alloc_urb(0, GFP_KERNEL);
 		if (usbduxsub[index].urbPwm == NULL) {
-			dev_err(dev, "comedi_: usbdux%d: "
-				"Could not alloc. pwm urb\n", index);
+			dev_err(dev, "comedi_: usbdux%d: Could not alloc. pwm urb\n",
+				index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2547,8 +2545,8 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		usbduxsub[index].urbPwm->transfer_buffer =
 		    kzalloc(usbduxsub[index].sizePwmBuf, GFP_KERNEL);
 		if (!(usbduxsub[index].urbPwm->transfer_buffer)) {
-			dev_err(dev, "comedi_: usbdux%d: "
-				"could not alloc. transb. for pwm\n", index);
+			dev_err(dev, "comedi_: usbdux%d: could not alloc. transb. for pwm\n",
+				index);
 			tidy_up(&(usbduxsub[index]));
 			up(&start_stop_sem);
 			return -ENOMEM;
@@ -2579,8 +2577,8 @@ static int usbduxsub_probe(struct usb_interface *uinterf,
 		return ret;
 	}
 
-	dev_info(dev, "comedi_: usbdux%d "
-		 "has been successfully initialised.\n", index);
+	dev_info(dev, "comedi_: usbdux%d has been successfully initialised.\n",
+		 index);
 	/* success */
 	return 0;
 }
-- 
1.7.0.4

