Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab0F3Pzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:55:47 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:39568 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756498Ab0F3Pzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:55:44 -0400
Date: Wed, 30 Jun 2010 17:55:42 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Russell King <linux@arm.linux.org.uk>, Eric Miao <eric.y.miao@gmail.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 06/33] Removing dead SHARPSL_LOCOMO
Message-ID: <b43850b1a1909496718e39687d1ca00543aa30ec.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SHARPSL_LOCOMO doesn't exist in Kconfig, therefore removing all
references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-sa1100/include/mach/irqs.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-sa1100/include/mach/irqs.h b/arch/arm/mach-sa1100/include/mach/irqs.h
index 8c8845b..123c6c9 100644
--- a/arch/arm/mach-sa1100/include/mach/irqs.h
+++ b/arch/arm/mach-sa1100/include/mach/irqs.h
@@ -77,8 +77,6 @@
  */
 #ifdef CONFIG_SA1111
 #define NR_IRQS			(IRQ_BOARD_END + 55)
-#elif defined(CONFIG_SHARPSL_LOCOMO)
-#define NR_IRQS			(IRQ_BOARD_START + 4)
 #else
 #define NR_IRQS			(IRQ_BOARD_START)
 #endif
-- 
1.7.0.4

