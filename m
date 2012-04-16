Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab2DPKka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 06:40:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52764 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab2DPKk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 06:40:29 -0400
Message-ID: <1334572822.3101.5.camel@ubuntu.ubuntu-domain>
Subject: Fixed a style issue in Drivers/staging/comedi/comedi_fops
From: Benedikt Bergenthal <benedikt@kdrennert.de>
To: greg@kroah.com
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net, fschmaus@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 16 Apr 2012 12:40:22 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:DIzqAYGLQKTh2+TqpOUP1/dRoch3gnerBtmPOLShuBg
 N/vWtNDYih0mMSXueGdWlvAGixiEAem61NjaI5kyxrMTw7ital
 ctAMeJ0Lb3pIRCPXaD8YKAJ1VGEe8Qx1n9JCMExRQMKoNcmqzF
 LCDoyBh9xEW1d8WIYEl7e02vyS4WSPsXeC4UCYTL2L3bbKdMrm
 JfO0hCtcFq3rfL2HxM9LV7g2Jl4VxCHHVIj2nTVjHGXsTT1RiS
 Eln0xMETJ57Vq4DfGEWWDfqIG01QYZpnWxqW48IqX0vDJi/Tso
 Owiww2C04Bn6v/4hOl5T9235e+n49ak7cg3M5U74YSFF6b7t+S
 zSulJFXU12vB+I6gPfoTQG9Kwji8zrJfWei5LhD/Q3WKfGBPDP
 j0wZjBEMaKS/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7f8dfad47674d8e7ad0b9a6e994da21c130bfd51 Mon Sep 17 00:00:00 2001
From: Benedikt <bberget@cern.ch>
Date: Mon, 16 Apr 2012 12:34:24 +0200
Subject: [PATCH] Drivers: Staging: Comedi: comedi_fops: Fixed a code style
 issue

Fixed a code style issue.

Signed-off-by: Benedikt Bergenthal <benedikt@kdrennert.de>
---
 drivers/staging/comedi/comedi_fops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 9bcf87a..5badea5 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1545,7 +1545,7 @@ done:
 	return retval;
 }
 
-static unsigned int comedi_poll(struct file *file, poll_table * wait)
+static unsigned int comedi_poll(struct file *file, poll_table *wait)
 {
 	unsigned int mask = 0;
 	const unsigned minor = iminor(file->f_dentry->d_inode);
-- 
1.7.9.5



