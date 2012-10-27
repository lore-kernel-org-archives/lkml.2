Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517Ab2J0Vqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:46:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39886 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab2J0Vqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:46:38 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/2] staging/comedi: Fix trailing statements should be on next line in drivers/quatech_daqp_cs.c
Date: Sun, 28 Oct 2012 06:46:33 +0900
Message-Id: <1351374393-7918-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch errors.
- ERROR: trailing statements should be on next line

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index d15bd8a..806523c 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -395,7 +395,8 @@ static int daqp_ai_insn_read(struct comedi_device *dev,
 	 */
 
 	while (--counter
-	       && (inb(dev->iobase + DAQP_STATUS) & DAQP_STATUS_EVENTS)) ;
+	       && (inb(dev->iobase + DAQP_STATUS) & DAQP_STATUS_EVENTS))
+		;
 	if (!counter) {
 		printk("daqp: couldn't clear interrupts in status register\n");
 		return -1;
@@ -732,7 +733,8 @@ static int daqp_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	 */
 	counter = 100;
 	while (--counter
-	       && (inb(dev->iobase + DAQP_STATUS) & DAQP_STATUS_EVENTS)) ;
+	       && (inb(dev->iobase + DAQP_STATUS) & DAQP_STATUS_EVENTS))
+		;
 	if (!counter) {
 		dev_err(dev->class_dev,
 			"couldn't clear interrupts in status register\n");
-- 
1.7.9.5

