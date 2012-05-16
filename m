Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2EPTA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:00:56 -0400
Received: from nm10-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.147]:41004 "HELO
	nm10-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932404Ab2EPTAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:00:19 -0400
X-Yahoo-Newman-Id: 279717.20043.bm@smtp114.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7XTjSIYVM1kqKlojjRzNZwzpY.SXQgD9uCnfAYQ87RybVOq
 AcWOD0gQUThYKLHr4pEkbLZCfOzdda8C2ubfw9pHAPjPxTe1P3Vrk05RQgbF
 Ijb7nmuYeA_tUHKl102nRCrQyX9vIglzfHWPE7rj8EosD.sG7Zg1V1pckDOj
 VgzKF6rqADjaBgilYXcfw_90GN5zhE5goTfVDYnB95.3bz1RX6.m9AUppdsb
 kKVXGMHJJ6RrSzEcwMwQBztbEiYA7Xdz0q3fHwwMrRrR4cgTIabOUkH76Bsw
 iuaSFac2ofjy_Jxq8yZmgSWaO.dKm4IgGx6H_1gUXPScjP4nCXes1in8_nEv
 f34seZGTNPZ7uPf4PFjoOb7SNeg4ZuE0zk.UaY_JxVp3JMjES1krEDyHRpoj
 gz9l.c8l2_cBgD5u3HvDjieGRquoo_Pi2PCtIftrQLDYD9V16n4I6.KA1zEL
 whRhmsKj5mrXzboCOzwgsHsQb_1Ala4iw8HbkJI_5gv4E87EzUMl_95aIQUq
 u8QeXl.A-
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: mdharm-usb@one-eyed-alien.net, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: [PATCH 2/3]USB: storage :fixed several trailing white spaces issues.
Date: Thu, 17 May 2012 00:33:36 +0530
Message-Id: <1337195016-3766-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed several trailing white spaces issues found
by checkpatch.pl tool in drivers/usb/storage/usb.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 drivers/usb/storage/usb.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 7ad1a8b..16d49da 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -121,7 +121,7 @@ MODULE_PARM_DESC(quirks, "supplemental list of device IDs and their quirks");
 }
 
 static struct us_unusual_dev us_unusual_dev_list[] = {
-#	include "unusual_devs.h" 
+#	include "unusual_devs.h"
 	{ }		/* Terminating entry */
 };
 
@@ -261,7 +261,7 @@ EXPORT_SYMBOL_GPL(usb_stor_post_reset);
 void fill_inquiry_response(struct us_data *us, unsigned char *data,
 		unsigned int data_len)
 {
-	if (data_len<36) /* You lose. */
+	if (data_len < 36) /* You lose. */
 		return;
 
 	memset(data+8, ' ', 28);
@@ -271,7 +271,7 @@ void fill_inquiry_response(struct us_data *us, unsigned char *data,
 			      to this logical unit") and leave vendor and
 			      product identification empty. ("If the target
 			      does store some of the INQUIRY data on the
-			      device, it may return zeros or ASCII spaces 
+			      device, it may return zeros or ASCII spaces
 			      (20h) in those fields until the data is
 			      available from the device."). */
 	} else {
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
@@ -732,7 +732,7 @@ static int get_pipes(struct us_data *us)
 	us->recv_ctrl_pipe = usb_rcvctrlpipe(us->pusb_dev, 0);
 	us->send_bulk_pipe = usb_sndbulkpipe(us->pusb_dev,
 		usb_endpoint_num(ep_out));
-	us->recv_bulk_pipe = usb_rcvbulkpipe(us->pusb_dev, 
+	us->recv_bulk_pipe = usb_rcvbulkpipe(us->pusb_dev,
 		usb_endpoint_num(ep_in));
 	if (ep_int) {
 		us->recv_intr_pipe = usb_rcvintpipe(us->pusb_dev,
-- 
1.7.10

