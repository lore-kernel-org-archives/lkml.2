Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0EKWGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 18:06:18 -0400
Received: from smtp-out110.alice.it ([85.37.17.110]:1352 "EHLO
	smtp-out110.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab0EKWGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 18:06:16 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2010 18:06:16 EDT
From: Morgan Gatti <morgan.gatti@gmail.com>
To: gregkh@suse.de, jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, Morgan Gatti <morgan.gatti@gmail.com>
Subject: [PATCH] Staging:comedi:Fix bug and coding style issue in usbdux.c This is a patch to the usbdux.c file that resolve 2 errors in coding and fix the warning about lengt of code lines Signed-off-by: Morgan Gatti <morgan.gatti@gmail.com>
Date: Tue, 11 May 2010 23:55:53 +0200
Message-Id: <1273614953-3263-1-git-send-email-morgan.gatti@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <patch usbdux>
References: <patch usbdux>
X-OriginalArrivalTime: 11 May 2010 21:55:58.0493 (UTC) FILETIME=[BD0F64D0:01CAF154]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers/usbdux.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 8942ae4..c39c36a 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -793,7 +793,7 @@ static int usbduxsub_stop(struct usbduxsub *usbduxsub)
 }
 
 static int usbduxsub_upload(struct usbduxsub *usbduxsub,
-			    uint8_t * local_transfer_buffer,
+			    uint8_t *local_transfer_buffer,
 			    unsigned int startAddr, unsigned int len)
 {
 	int errcode;
@@ -825,7 +825,7 @@ static int usbduxsub_upload(struct usbduxsub *usbduxsub,
 #define FIRMWARE_MAX_LEN 0x2000
 
 static int firmwareUpload(struct usbduxsub *usbduxsub,
-			  const u8 * firmwareBinary, int sizeFirmware)
+			  const u8 *firmwareBinary, int sizeFirmware)
 {
 	int ret;
 	uint8_t *fwBuf;
@@ -835,7 +835,7 @@ static int firmwareUpload(struct usbduxsub *usbduxsub,
 
 	if (sizeFirmware > FIRMWARE_MAX_LEN) {
 		dev_err(&usbduxsub->interface->dev,
-			"comedi_: usbdux firmware binary it too large for FX2.\n");
+		"comedi_: usbdux firmware binary it too large for FX2.\n");
 		return -ENOMEM;
 	}
 
@@ -1264,8 +1264,8 @@ static int usbdux_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 			    (this_usbduxsub->ai_interval) * 2;
 		}
 		this_usbduxsub->ai_timer = cmd->scan_begin_arg / (125000 *
-								  (this_usbduxsub->
-								   ai_interval));
+					  (this_usbduxsub->
+					   ai_interval));
 	} else {
 		/* interval always 1ms */
 		this_usbduxsub->ai_interval = 1;
-- 
1.7.0.4

