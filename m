Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab0KJHoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 02:44:13 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38488 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab0KJHoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 02:44:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=gz7XxhyoPncXqRPBcwCmpLwe36jvvA1rRaIw/ptTrivfNH2ghG6jEO1rEusQsWiTGu
         7nntFXV2GIFgt5Spc/OVsraZn2E6AlQ1BybyGISCUFAghHYDPLmBbltUOSFdCxJp1GKf
         I/4Tw+BD5vfxgiY0fE+soqIWDIGUN6SMikM/Q=
Subject: [PATCH 1/2] mfd: Include <linux/io.h> instead of <asm/io.h>
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>
Content-Type: text/plain
Date: Wed, 10 Nov 2010 15:47:51 +0800
Message-Id: <1289375271.28822.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As warned by checkpatch.pl, use #include <linux/io.h> instead of <asm/io.h>

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/sm501.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index bc9275c..c24bed7 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -26,7 +26,7 @@
 #include <linux/sm501-regs.h>
 #include <linux/serial_8250.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 
 struct sm501_device {
 	struct list_head		list;
-- 
1.7.2



