Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab1FWTlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 15:41:21 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:44469 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932934Ab1FWTlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 15:41:19 -0400
Subject: [PATCH 07/11] Removed unused includes from ft1000_cs.c
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
From: Ondrej Zary <linux@rainbow-software.org>
Date: Thu, 23 Jun 2011 21:41:11 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106232141.13165.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unused includes from ft1000_cs.c

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
index 9a54c84..13b6837 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -29,25 +29,10 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/ptrace.h>
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <linux/timer.h>
-#include <linux/ioport.h>
-#include <linux/delay.h>
-
 #include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-
 #include <pcmcia/cistpl.h>
-#include <pcmcia/cisreg.h>
 #include <pcmcia/ds.h>
 
-#include <asm/io.h>
-#include <asm/system.h>
-#include <asm/byteorder.h>
-#include <asm/uaccess.h>
-
 /*====================================================================*/
 
 MODULE_AUTHOR("Wai Chan");
-- 
Ondrej Zary

