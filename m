Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1F3WGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:06:22 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:53478 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753054Ab1F3WES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:18 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/28] staging: ft1000-pcmcia: remove unused includes from ft1000_cs.c
Date: Fri,  1 Jul 2011 00:03:53 +0200
Message-Id: <1309471437-12633-25-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused includes from ft1000_cs.c

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

