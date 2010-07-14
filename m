Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab0GNSCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:02:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38934 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab0GNSCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:02:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vDiXXxglKZ9VrI+BbZiUOvVdwfO+kLbkqAK5M/jB+NNW8U7/YHYsslVVJc2dgdxnVb
         V8un050hbJzb1o7qss5iHL75zNdwcIBFmk9y8wIE6sSoQiLEeSFErDPdo36xRn0c0HfM
         8vBTHeMm40hYgeV8l2Yb+ThuKnWPb/8vr4GYI=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Chris Zankel <chris@zankel.net>, Pete Delaney <piet@tensilica.com>,
        Dan Nicolaescu <dann@xtensa-linux.org>,
        Marc Gauthier <marc@tensilica.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] xtavnet/setup.c: formatting of pointers in printk()
Date: Wed, 14 Jul 2010 22:02:21 +0400
Message-Id: <1279130541-10817-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use %p instead of %08x in printk().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/xtensa/platforms/xtavnet/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/platforms/xtavnet/setup.c b/arch/xtensa/platforms/xtavnet/setup.c
index 256fcb2..1597dbf 100644
--- a/arch/xtensa/platforms/xtavnet/setup.c
+++ b/arch/xtensa/platforms/xtavnet/setup.c
@@ -213,7 +213,7 @@ void platform_init(bp_tag_t *bootparams)
 {
 	printk("\n");
 	if( bootparams )
-		printk("XTAVnet: platform_init(bootparams:0x%x)\n", (unsigned)bootparams);
+		printk("XTAVnet: platform_init(bootparams:%p)\n", bootparams);
 }
 
 static int xtavnet_init(void)
-- 
1.7.0.4

