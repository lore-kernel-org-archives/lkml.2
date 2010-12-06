Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab0LFNX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 08:23:27 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:54682 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab0LFNX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:23:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ocHw8oq2Rl2xzkp1pHT4YrZH/RE2K1yKdwwKxk4qtsi80WJzQpP2wzahGN2C0ssqZ0
         6p7TksMotSbrF5hTCwL0NZUnzt1l2e0SbaDvlmuBAMDRO/vrvN/rk6MWDFVgonP9Zud2
         lAs1oGIVUPeufCnCkmgdSPzINeXwVA65AyeZ8=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] omap1: mailbox: Fix compilation warning.
Date: Mon,  6 Dec 2010 14:25:52 +0100
Message-Id: <1291641952-20029-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following compilation warning:
arch/arm/mach-omap1/mailbox.c: In function 'omap1_mbox_probe':
arch/arm/mach-omap1/mailbox.c:148: warning: unused variable 'i'

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 arch/arm/mach-omap1/mailbox.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap1/mailbox.c b/arch/arm/mach-omap1/mailbox.c
index 1a85a42..1add133 100644
--- a/arch/arm/mach-omap1/mailbox.c
+++ b/arch/arm/mach-omap1/mailbox.c
@@ -145,7 +145,6 @@ static int __devinit omap1_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *mem;
 	int ret;
-	int i;
 	struct omap_mbox **list;
 
 	list = omap1_mboxes;
-- 
1.7.1

