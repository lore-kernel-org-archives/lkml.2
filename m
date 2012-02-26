Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab2BZWLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 17:11:46 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21671 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab2BZWLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 17:11:45 -0500
Date: Sun, 26 Feb 2012 23:09:40 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-arm-kernel@lists.infradead.org
cc: trivial@kernel.org, linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH][trivial] ARM: Remove redundant ';' from
 avic_irq_set_priority()
Message-ID: <alpine.LNX.2.00.1202262307210.6089@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One semi-colon at the end of the return statement is sufficient.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/arm/plat-mxc/avic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-mxc/avic.c b/arch/arm/plat-mxc/avic.c
index 55f1569..689f81f 100644
--- a/arch/arm/plat-mxc/avic.c
+++ b/arch/arm/plat-mxc/avic.c
@@ -60,7 +60,7 @@ static int avic_irq_set_priority(unsigned char irq, unsigned char prio)
 	unsigned int mask = 0x0F << irq % 8 * 4;
 
 	if (irq >= AVIC_NUM_IRQS)
-		return -EINVAL;;
+		return -EINVAL;
 
 	temp = __raw_readl(avic_base + AVIC_NIPRIORITY(irq / 8));
 	temp &= ~mask;
-- 
1.7.9.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

