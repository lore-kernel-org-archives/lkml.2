Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab2EKKmC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:42:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35076 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab2EKKl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:41:58 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 17/25] Staging: comedi: fix line over 80 character issue in unioxx5.c
Date: Fri, 11 May 2012 16:08:05 +0530
Message-Id: <1336732693-7408-18-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1336732693-7408-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the unioxx5.c file that fixes up a line
over 80 character warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/unioxx5.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 1823642..bb278bf 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -101,7 +101,10 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
 				   unsigned int *data, int channel, int minor);
 static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
 				  unsigned int *data, int channel, int minor);
-/* static void __unioxx5_digital_config(struct unioxx5_subd_priv* usp, int mode); */
+/*
+ * static void __unioxx5_digital_config(struct unioxx5_subd_priv* usp,
+ *					int mode);
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
-- 
1.7.0.4

