Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2EZPWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 11:22:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41461 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2EZPWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 11:22:17 -0400
From: Michael Dabydeen <dabydeem@sheridanc.on.ca>
To: linux-kernel@vger.kernel.org
Cc: Michael Dabydeen <dabydeem@sheridanc.on.ca>,
        Michael Dabydeen <mdabydeen@gmail.com>
Subject: [PATCH] Staging: comedi: mpc82860: fixed a brace coding style issue
Date: Sat, 26 May 2012 11:21:43 -0400
Message-Id: <1338045703-17581-1-git-send-email-dabydeem@sheridanc.on.ca>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue

Signed-off-by: Michael Dabydeen<mdabydeen@gmail.com>
---
 drivers/staging/comedi/drivers/mpc8260cpm.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/mpc8260cpm.c b/drivers/staging/comedi/drivers/mpc8260cpm.c
index 364470e..6d291b7 100644
--- a/drivers/staging/comedi/drivers/mpc8260cpm.c
+++ b/drivers/staging/comedi/drivers/mpc8260cpm.c
@@ -36,7 +36,7 @@ It is apparently missing some code.
 
 #include "../comedidev.h"
 
-extern unsigned long mpc8260_dio_reserved[4];
+unsigned long mpc8260_dio_reserved[4];
 
 struct mpc8260cpm_private {
 
@@ -71,10 +71,8 @@ static int mpc8260cpm_dio_config(struct comedi_device *dev,
 
 	port = (int)s->private;
 	mask = 1 << CR_CHAN(insn->chanspec);
-	if (mask & cpm_reserved_bits[port]) {
+	if (mask & cpm_reserved_bits[port])
 		return -EINVAL;
-	}
-
 	switch (data[0]) {
 	case INSN_CONFIG_DIO_OUTPUT:
 		s->io_bits |= mask;
@@ -122,7 +120,7 @@ static int mpc8260cpm_attach(struct comedi_device *dev,
 	struct comedi_subdevice *s;
 	int i;
 
-	printk("comedi%d: mpc8260cpm: ", dev->minor);
+	printk(KERN_ERROR , "comedi%d: mpc8260cpm: ", dev->minor);
 
 	dev->board_ptr = mpc8260cpm_boards + dev->board;
 
-- 
1.7.9.5

