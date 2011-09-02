Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab1IBHes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 03:34:48 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45113 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab1IBHer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 03:34:47 -0400
From: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
Subject: [PATCH 1/1] Staging: comedi: fix line over 80 character issue in unioxx5.c
Date: Fri,  2 Sep 2011 13:04:34 +0530
Message-Id: <1314948874-3616-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 1/1]Staging: comedi: fix line over 80 character issue in unioxx5.c>
References: <[PATCH 1/1]Staging: comedi: fix line over 80 character issue in unioxx5.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the unioxx5.c file that fixes up a line over 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/unioxx5.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 89e62aa..fca7c2f 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -101,7 +101,10 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
 				   unsigned int *data, int channel, int minor);
 static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
 				  unsigned int *data, int channel, int minor);
-/* static void __unioxx5_digital_config(struct unioxx5_subd_priv* usp, int mode); */
+/*
+ * static void __unioxx5_digital_config(struct unioxx5_subd_priv* usp,
+ * int mode);
+ */
 static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
 				  unsigned int *data, int channel, int minor);
 static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
@@ -141,7 +144,10 @@ static int unioxx5_attach(struct comedi_device *dev,
 	dev->iobase = iobase;
 	iobase += UNIOXX5_SUBDEV_BASE;
 
-	/* defining number of subdevices and getting they types (it must be 'g01')  */
+	/*
+	 * defining number of subdevices and getting they types
+	 * (it must be 'g01')
+	 */
 	for (i = n_subd = 0, ba = iobase; i < 4; i++, ba += UNIOXX5_SUBDEV_ODDS) {
 		id = inb(ba + 0xE);
 		num = inb(ba + 0xF);
@@ -409,7 +415,11 @@ static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
 	*data &= mask;
 
 	if (channel_offset > 1)
-		channel -= 2 << channel_offset;	/* this operation is created for correct readed value to 0 or 1 */
+		/*
+		 * this operation is created for correct readed
+		 * value to 0 or 1
+		 */
+		channel -= 2 << channel_offset;
 	*data >>= channel;
 	return 1;
 }
-- 
1.6.5.2

