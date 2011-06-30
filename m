Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab1F3WJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:09:24 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:43269 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752775Ab1F3WER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:04:17 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/28] staging: ft1000-pcmcia: remove useless defines from ft1000_cs.c
Date: Fri,  1 Jul 2011 00:03:48 +0200
Message-Id: <1309471437-12633-20-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
References: <1309471437-12633-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused defines from ft1000_cs.c

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
index f1d6e4a..a9b0cff 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -50,10 +50,6 @@
 
 /*====================================================================*/
 
-/* Module parameters */
-
-#define INT_MODULE_PARM(n, v) static int n = v; MODULE_PARM(n, "i")
-
 MODULE_AUTHOR("Wai Chan");
 MODULE_DESCRIPTION("FT1000 PCMCIA driver");
 MODULE_LICENSE("GPL");
@@ -93,9 +89,6 @@ static void ft1000_release(struct pcmcia_device *link);
 static void ft1000_detach(struct pcmcia_device *link);
 static int  ft1000_attach(struct pcmcia_device *link);
 
-#define MAX_ASIC_RESET_CNT     10
-#define COR_DEFAULT            0x55
-
 /*====================================================================*/
 
 static void ft1000_reset(struct pcmcia_device * link)
-- 
Ondrej Zary

