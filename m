Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0JPBBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 21:01:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab0JPBBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 21:01:42 -0400
Date: Fri, 15 Oct 2010 21:01:41 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-kernel@vger.kernel.org
Cc: Hirokazu Takata <takata@linux-m32r.org>, tglx@redhat.com,
        linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca
Subject: [PATCH 3/3] m32r: fix build warning about unused irq chip
Message-ID: <20101016010141.GP8332@bombadil.infradead.org>
References: <20101016005719.GM8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016005719.GM8332@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
 arch/m32r/platforms/m32700ut/setup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/m32r/platforms/m32700ut/setup.c b/arch/m32r/platforms/m32700ut/setup.c
index a43bdf4..bea1afb 100644
--- a/arch/m32r/platforms/m32700ut/setup.c
+++ b/arch/m32r/platforms/m32700ut/setup.c
@@ -167,6 +167,7 @@ static struct irq_chip m32700ut_lanpld_irq_type =
 	.mask = disable_m32700ut_lanpld_irq,
 };
 
+#if defined(CONFIG_USB)
 /*
  * Interrupt Control Unit of PLD on M32700UT-LCD (Level 2)
  */
@@ -216,6 +217,7 @@ static struct irq_chip m32700ut_lcdpld_irq_type =
 	.unmask = enable_m32700ut_lcdpld_irq,
 	.mask = disable_m32700ut_lcdpld_irq,
 };
+#endif
 
 void __init init_IRQ(void)
 {
-- 
1.7.3.1

