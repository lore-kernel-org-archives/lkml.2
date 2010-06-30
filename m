Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab0F3QFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:05:42 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40267 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932081Ab0F3QFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:05:41 -0400
Date: Wed, 30 Jun 2010 18:05:38 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Kevin Hilman <davinci-linux-open-source@linux.davincidsp.com>,
       Russell King <linux@arm.linux.org.uk>,
       Sandeep Paulraj <s-paulraj@ti.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       Steve Chen <schen@mvista.com>, Cyril Chemparathy <cyril@ti.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH 02/33] Removing dead ARCH_DAVINCI_TNETV107X
Message-ID: <88ee583babc6f0aecb2238a57644f64159d5c395.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1277911345.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_DAVINCI_TNETV107X doesn't exist in Kconfig, therefore removing
all references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-davinci/include/mach/cputype.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-davinci/include/mach/cputype.h b/arch/arm/mach-davinci/include/mach/cputype.h
index cea6b89..6143022 100644
--- a/arch/arm/mach-davinci/include/mach/cputype.h
+++ b/arch/arm/mach-davinci/include/mach/cputype.h
@@ -85,10 +85,4 @@ IS_DAVINCI_CPU(tnetv107x, DAVINCI_CPU_ID_TNETV107X)
 #define cpu_is_davinci_da850() 0
 #endif
 
-#ifdef CONFIG_ARCH_DAVINCI_TNETV107X
-#define cpu_is_davinci_tnetv107x() is_davinci_tnetv107x()
-#else
-#define cpu_is_davinci_tnetv107x() 0
-#endif
-
 #endif
-- 
1.7.0.4

