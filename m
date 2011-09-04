Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1IDPhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 11:37:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63100 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab1IDPhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 11:37:45 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH] Staging: comedi: Removed unnecessary "extern" from do_become_nonbusy()
Date: Sun,  4 Sep 2011 17:36:29 +0200
Message-Id: <1315150589-3434-1-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary "extern" label from do_become_nonbusy() function to make
checkpatch.pl happy

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/comedi/comedi_fops.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index e90e3cc..c46db8f 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -101,8 +101,7 @@ static int do_insn_ioctl(struct comedi_device *dev,
 static int do_poll_ioctl(struct comedi_device *dev, unsigned int subd,
 			 void *file);
 
-extern void do_become_nonbusy(struct comedi_device *dev,
-			      struct comedi_subdevice *s);
+void do_become_nonbusy(struct comedi_device *dev, struct comedi_subdevice *s);
 static int do_cancel(struct comedi_device *dev, struct comedi_subdevice *s);
 
 static int comedi_fasync(int fd, struct file *file, int on);
-- 
1.7.4.1

