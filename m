Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0IWTPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:15:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49215 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab0IWTPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:15:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=rNBdWtt095yB4l/X4LZCCTLNgr3uCvWORvYYWzkmyBdvOdSqmh3d2sKqnwDd5OK7iQ
         s6hJwcLc6BfR7AUYR/2xIgvYbaKcShFgG9H0S2CM9Yjyquulcw2+X56hxI/ZZWmIn681
         0Lcy9C03VE6Frx+Vy2DxCO/PcY2pACD3MuMnQ=
Subject: [RESEND PATCH] serial: samsung: fix device name
To: linux-arm-kernel@lists.infradead.org
From: Darius Augulis <augulis.darius@gmail.com>
Cc: kgene.kim@samsung.com, paulius.zaleckas@gmail.com,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org,
        linux-serial@vger.kernel.org
Date: Thu, 23 Sep 2010 22:15:31 +0300
Message-ID: <20100923190212.18863.25678.stgit@darius-desktop>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swap device and driver names in serial/samsung.c

Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
---

This patch was submitted about 3 months ago, but still not merged.
There was another similar patch from Joonyoung Shim
<jy0922.shim@samsung.com> and was discussed here:
http://marc.info/?l=linux-serial&m=127416101222281&w=2.
Joonyoung Shim acked my patch and other people on ARM mailing list
acked it. The maintainer, Ben Dooks, still not responding for
a long time. Another maintainer, Kukjin Kim, refused to merge
it without Ben's review.
I would like to ask somebody pick up this bugfix.

 drivers/serial/samsung.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/samsung.c b/drivers/serial/samsung.c
index b1156ba..25c0d0f 100644
--- a/drivers/serial/samsung.c
+++ b/drivers/serial/samsung.c
@@ -883,10 +883,10 @@ static struct uart_ops s3c24xx_serial_ops = {
 
 static struct uart_driver s3c24xx_uart_drv = {
 	.owner		= THIS_MODULE,
-	.dev_name	= "s3c2410_serial",
+	.driver_name    = "s3c2410_serial",
 	.nr		= CONFIG_SERIAL_SAMSUNG_UARTS,
 	.cons		= S3C24XX_SERIAL_CONSOLE,
-	.driver_name	= S3C24XX_SERIAL_NAME,
+	.dev_name       = S3C24XX_SERIAL_NAME,
 	.major		= S3C24XX_SERIAL_MAJOR,
 	.minor		= S3C24XX_SERIAL_MINOR,
 };

