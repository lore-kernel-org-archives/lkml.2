Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab2EOOmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:42:08 -0400
Received: from nm36-vm2.bullet.mail.bf1.yahoo.com ([72.30.238.138]:44105 "HELO
	nm36-vm2.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755787Ab2EOOmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:42:06 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2012 10:42:05 EDT
X-Yahoo-Newman-Id: 607692.18589.bm@smtp214.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LncRxDgVM1kK..WHh5dHkHkfDzfoT_jXjBqEEjRXk32UzHV
 JDIxhCJTHkbruDswRW3GEFgFWxwQGOvIfjCSeWZX6c4R31uHq.wVbEniM7nv
 fxTjPwmAtkoK4HfXFQn6_CTEJuYlV1f84UibNVHjnqLrN4DM_ZBgvDGdU2l8
 e6ObyWr5AKzP9d.4mGIcMT_ObGg4TLrR5jOgJYxr1132LUM0MB5hlabY1DKs
 CbDUKEDu9grPoe3E2ZYgCxy512v71EJ8EtH3Wor13cjN6E_cZ7z4BP4SsLxE
 FbiErEyaqP.VmMI4ILGrQra7HwY1LWibsdr7YQmd2sels4vNJS2yegt_1nwe
 _63m9IqF_Cibb6BsSly7AvG3O3hLTm_Y3i_9dhqjBgRTIgEybhGPl7RUQbgU
 A54PXphuSle5WEASTXTklkY4Gk60myxXNDxIgMKcgzLToiIgs9CShGzIthil
 ydw--
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
Date: Tue, 15 May 2012 20:09:50 +0530
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: mdharm-usb@one-eyed-alien.net
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        ahiliation@yahoo.co.in
Subject: styling fixes in drivers/usb/storage/usb.c
Message-ID: <20120515143950.GA4654@debian.Jeff>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hello ,

worked on styling fixes in drivers/usb/storage/usb.c


>From 67edcc16dffc6f05f8bad70590e4175b7aeaa945 Mon Sep 17 00:00:00 2001
From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Tue, 15 May 2012 19:42:31 +0530
Subject: [PATCH 2/2] drivers:Fixed several coding style issues in
 drivers/usb/storage/usb.c

- Fixed trailing white space issues.
- Fixed C99 comment issue.
- Fixed keyword related space issues.
in drivers/usb/storage/usb.c
Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 drivers/usb/storage/usb.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 2653e73..faa5073 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -121,7 +121,7 @@ MODULE_PARM_DESC(quirks, "supplemental list of device IDs and their quirks");
 }
 
 static struct us_unusual_dev us_unusual_dev_list[] = {
-#	include "unusual_devs.h" 
+#	include "unusual_devs.h"
 	{ }		/* Terminating entry */
 };
 
@@ -261,17 +261,17 @@ EXPORT_SYMBOL_GPL(usb_stor_post_reset);
 void fill_inquiry_response(struct us_data *us, unsigned char *data,
 		unsigned int data_len)
 {
-	if (data_len<36) // You lose.
+	if (data_len < 36) /* You lose. */
 		return;
 
 	memset(data+8, ' ', 28);
-	if(data[0]&0x20) { /* USB device currently not connected. Return
+	if (data[0]&0x20) { /* USB device currently not connected. Return
 			      peripheral qualifier 001b ("...however, the
 			      physical device is not currently connected
 			      to this logical unit") and leave vendor and
 			      product identification empty. ("If the target
 			      does store some of the INQUIRY data on the
-			      device, it may return zeros or ASCII spaces 
+			      device, it may return zeros or ASCII spaces
 			      (20h) in those fields until the data is
 			      available from the device."). */
 	} else {
@@ -298,7 +298,7 @@ static int usb_stor_control_thread(void * __us)
 	struct us_data *us = (struct us_data *)__us;
 	struct Scsi_Host *host = us_to_host(us);
 
-	for(;;) {
+	for (;;) {
 		US_DEBUGP("*** thread sleeping.\n");
 		if (wait_for_completion_interruptible(&us->cmnd_ready))
 			break;
@@ -327,7 +327,7 @@ static int usb_stor_control_thread(void * __us)
 
 		scsi_unlock(host);
 
-		/* reject the command if the direction indicator 
+		/* reject the command if the direction indicator
 		 * is UNKNOWN
 		 */
 		if (us->srb->sc_data_direction == DMA_BIDIRECTIONAL) {
@@ -338,7 +338,7 @@ static int usb_stor_control_thread(void * __us)
 		/* reject if target != 0 or if LUN is higher than
 		 * the maximum known LUN
 		 */
-		else if (us->srb->device->id && 
+		else if (us->srb->device->id &&
 				!(us->fflags & US_FL_SCM_MULT_TARG)) {
 			US_DEBUGP("Bad target number (%d:%d)\n",
 				  us->srb->device->id, us->srb->device->lun);
@@ -351,7 +351,7 @@ static int usb_stor_control_thread(void * __us)
 			us->srb->result = DID_BAD_TARGET << 16;
 		}
 
-		/* Handle those devices which need us to fake 
+		/* Handle those devices which need us to fake
 		 * their inquiry data */
 		else if ((us->srb->cmnd[0] == INQUIRY) &&
 			    (us->fflags & US_FL_FIX_INQUIRY)) {
@@ -376,7 +376,7 @@ static int usb_stor_control_thread(void * __us)
 
 		/* indicate that the command is done */
 		if (us->srb->result != DID_ABORT << 16) {
-			US_DEBUGP("scsi cmd done, result=0x%x\n", 
+			US_DEBUGP("scsi cmd done, result=0x%x\n",
 				   us->srb->result);
 			us->srb->scsi_done(us->srb);
 		} else {
@@ -414,7 +414,7 @@ SkipForAbort:
 	}
 	__set_current_state(TASK_RUNNING);
 	return 0;
-}	
+}
 
 /***********************************************************************
  * Device probing and disconnecting
-- 
1.7.10

patch is also added as attachment.

Thanks

/Jeffrin.
-- 
software engineer
Bohr Lab
department of computer science
Rajagiri school of engineering and technology.

--5mCyUwZo2JvN/JJP
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-drivers-Fixed-several-coding-style-issues-in-drivers.patch"

>From 67edcc16dffc6f05f8bad70590e4175b7aeaa945 Mon Sep 17 00:00:00 2001
From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Tue, 15 May 2012 19:42:31 +0530
Subject: [PATCH 2/2] drivers:Fixed several coding style issues in
 drivers/usb/storage/usb.c

- Fixed trailing white space issues.
- Fixed C99 comment issue.
- Fixed keyword related space issues.
in drivers/usb/storage/usb.c
Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 drivers/usb/storage/usb.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 2653e73..faa5073 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -121,7 +121,7 @@ MODULE_PARM_DESC(quirks, "supplemental list of device IDs and their quirks");
 }
 
 static struct us_unusual_dev us_unusual_dev_list[] = {
-#	include "unusual_devs.h" 
+#	include "unusual_devs.h"
 	{ }		/* Terminating entry */
 };
 
@@ -261,17 +261,17 @@ EXPORT_SYMBOL_GPL(usb_stor_post_reset);
 void fill_inquiry_response(struct us_data *us, unsigned char *data,
 		unsigned int data_len)
 {
-	if (data_len<36) // You lose.
+	if (data_len < 36) /* You lose. */
 		return;
 
 	memset(data+8, ' ', 28);
-	if(data[0]&0x20) { /* USB device currently not connected. Return
+	if (data[0]&0x20) { /* USB device currently not connected. Return
 			      peripheral qualifier 001b ("...however, the
 			      physical device is not currently connected
 			      to this logical unit") and leave vendor and
 			      product identification empty. ("If the target
 			      does store some of the INQUIRY data on the
-			      device, it may return zeros or ASCII spaces 
+			      device, it may return zeros or ASCII spaces
 			      (20h) in those fields until the data is
 			      available from the device."). */
 	} else {
@@ -298,7 +298,7 @@ static int usb_stor_control_thread(void * __us)
 	struct us_data *us = (struct us_data *)__us;
 	struct Scsi_Host *host = us_to_host(us);
 
-	for(;;) {
+	for (;;) {
 		US_DEBUGP("*** thread sleeping.\n");
 		if (wait_for_completion_interruptible(&us->cmnd_ready))
 			break;
@@ -327,7 +327,7 @@ static int usb_stor_control_thread(void * __us)
 
 		scsi_unlock(host);
 
-		/* reject the command if the direction indicator 
+		/* reject the command if the direction indicator
 		 * is UNKNOWN
 		 */
 		if (us->srb->sc_data_direction == DMA_BIDIRECTIONAL) {
@@ -338,7 +338,7 @@ static int usb_stor_control_thread(void * __us)
 		/* reject if target != 0 or if LUN is higher than
 		 * the maximum known LUN
 		 */
-		else if (us->srb->device->id && 
+		else if (us->srb->device->id &&
 				!(us->fflags & US_FL_SCM_MULT_TARG)) {
 			US_DEBUGP("Bad target number (%d:%d)\n",
 				  us->srb->device->id, us->srb->device->lun);
@@ -351,7 +351,7 @@ static int usb_stor_control_thread(void * __us)
 			us->srb->result = DID_BAD_TARGET << 16;
 		}
 
-		/* Handle those devices which need us to fake 
+		/* Handle those devices which need us to fake
 		 * their inquiry data */
 		else if ((us->srb->cmnd[0] == INQUIRY) &&
 			    (us->fflags & US_FL_FIX_INQUIRY)) {
@@ -376,7 +376,7 @@ static int usb_stor_control_thread(void * __us)
 
 		/* indicate that the command is done */
 		if (us->srb->result != DID_ABORT << 16) {
-			US_DEBUGP("scsi cmd done, result=0x%x\n", 
+			US_DEBUGP("scsi cmd done, result=0x%x\n",
 				   us->srb->result);
 			us->srb->scsi_done(us->srb);
 		} else {
@@ -414,7 +414,7 @@ SkipForAbort:
 	}
 	__set_current_state(TASK_RUNNING);
 	return 0;
-}	
+}
 
 /***********************************************************************
  * Device probing and disconnecting
-- 
1.7.10


--5mCyUwZo2JvN/JJP--
