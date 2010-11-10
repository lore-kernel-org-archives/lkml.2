Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0KJHpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 02:45:47 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42291 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab0KJHpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 02:45:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=fmpn//RBbQONzUW52JBGEGb17r7XPEdwf4x0u/WJ40jMpYguCGG1pXh1BRhmT9/Idf
         mWu6+Sg/vBBHBGFZFkF7FDj2JAEWcc+Su1ULjEYpM3u3BkRdYGog0f2YKIXh2apLSBut
         wmDMK43XzsrbB05iP6iLTsmn43nxeariOXRIk=
Subject: [PATCH 2/2] mfd: Include <linux/gpio.h> instead of <asm/gpio.h>
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>
Content-Type: text/plain
Date: Wed, 10 Nov 2010 15:49:41 +0800
Message-Id: <1289375381.28822.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As warned by checkpatch.pl, use #include <linux/gpio.h> instead of <asm/gpio.h>.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tps65010.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65010.c b/drivers/mfd/tps65010.c
index d0016b6..83b75c5 100644
--- a/drivers/mfd/tps65010.c
+++ b/drivers/mfd/tps65010.c
@@ -34,7 +34,7 @@
 
 #include <linux/i2c/tps65010.h>
 
-#include <asm/gpio.h>
+#include <linux/gpio.h>
 
 
 /*-------------------------------------------------------------------------*/
-- 
1.7.2



