Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031024Ab2HIPUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:20:31 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37053 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030792Ab2HIPU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:20:29 -0400
From: =?UTF-8?q?G=C3=BCng=C3=B6r=20Erseymen?= <gelurine@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?G=C3=BCng=C3=B6r=20Erseymen?= <gelurine@gmail.com>
Subject: [PATCH] Staging: comedi: ssv_snp: fix checkpatch.pl warnings
Date: Thu,  9 Aug 2012 18:20:14 +0300
Message-Id: <1344525614-13910-1-git-send-email-gelurine@gmail.com>
X-Mailer: git-send-email 1.7.11.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two checkpatch.pl warnings about printk issues by using
pr_info(...) instead of printk(KERN_INFO, ...).

Signed-off-by: Güngör Erseymen <gelurine@gmail.com>
---
 drivers/staging/comedi/drivers/ssv_dnp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index 84b9f2a..4cd0f1b 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -177,7 +177,7 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	int ret;
 
-	printk(KERN_INFO "comedi%d: dnp: ", dev->minor);
+	pr_info("comedi%d: dnp: ", dev->minor);
 
 	dev->board_name = board->name;
 
@@ -195,7 +195,7 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->insn_bits = dnp_dio_insn_bits;
 	s->insn_config = dnp_dio_insn_config;
 
-	printk("attached\n");
+	pr_info("attached\n");
 
 	/* We use the I/O ports 0x22,0x23 and 0xa3-0xa9, which are always
 	 * allocated for the primary 8259, so we don't need to allocate them
-- 
1.7.11.4

