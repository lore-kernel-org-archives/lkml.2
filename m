Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab0C3USQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:18:16 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:63014 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab0C3USO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:18:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=yAKwY6rTwGBKhnLnhGHGDHkFZkIE+hH/c1LDLNhnpR2SDJ54bc/bpicYB8tO+inlYy
         Evg1hKYgilgZAvYWxwQhEi+zEGj98fVhzQzE26jgUagd/B6l8zLY3vrKf6zD7lDZuPVf
         3PzW2Ox0OCkrdqM7hykAsZfHZMA4ftiQcp1H0=
From: Soeren Moeller <soerenmoeller2001@gmail.com>
To: gregkh@suse.de, richard@audacityteam.org, andre.goddard@gmail.com,
       soerenmoeller2001@gmail.com, nm127@freemail.hu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: quatech_usb2: fix coding style issues
Date: Tue, 30 Mar 2010 20:11:12 +0000
Message-Id: <1269979872-14677-1-git-send-email-soerenmoeller2001@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the file quatech_usb2.c that fixes two space before tabular and one line of more than 80 characters warnings found by checkpatch.pl

Signed-off-by: Soeren Moeller <soerenmoeller2001@gmail.com>
---
 drivers/staging/quatech_usb2/quatech_usb2.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index 1561f74..ecd7313 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -57,7 +57,7 @@ static int debug;
 #define QT2_HW_FLOW_CONTROL_MASK		0xc5
 #define QT2_SW_FLOW_CONTROL_MASK		0xc6
 #define QT2_SW_FLOW_CONTROL_DISABLE		0xc7
-#define QT2_BREAK_CONTROL 			0xc8
+#define QT2_BREAK_CONTROL			0xc8
 #define QT2_STOP_RECEIVE			0xe0
 #define QT2_FLUSH_DEVICE			0xc4
 #define QT2_GET_SET_QMCR			0xe1
@@ -207,7 +207,7 @@ struct quatech2_dev {
 	bool	ReadBulkStopped;
 	char	open_ports;
 	struct usb_serial_port *current_port;
-	int 	buffer_size;
+	int	buffer_size;
 };
 
 /* structure which holds line and modem status flags */
@@ -1648,10 +1648,10 @@ __func__);
 			} /*endif*/
 			if (tty_st && urb->actual_length) {
 				tty_buffer_request_room(tty_st, 1);
-				tty_insert_flip_string(tty_st,
-					&((unsigned char *)(urb->transfer_buffer)
-						)[i],
-					1);
+				tty_insert_flip_string(tty_st, &(
+						(unsigned char *)
+						(urb->transfer_buffer)
+					)[i], 1);
 			}
 		} /*endfor*/
 		tty_flip_buffer_push(tty_st);
-- 
1.6.3.3

