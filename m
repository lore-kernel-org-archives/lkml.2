Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab0HDMmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:42:10 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:57185 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932654Ab0HDMmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:42:01 -0400
Date: Wed, 4 Aug 2010 14:41:59 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Greg Ungerer <gerg@uclinux.org>,
        Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 5/9] arch/m68knommu: Removing dead M68000 config option
Message-ID: <5e9a5d13b9b952ecf4434aee92ad4404ac46ddcc.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_M68000 doesn't exist in Kconfig, therefore removing
all references to it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/m68knommu/kernel/setup.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/m68knommu/kernel/setup.c b/arch/m68knommu/kernel/setup.c
index ba92b90..c684adf 100644
--- a/arch/m68knommu/kernel/setup.c
+++ b/arch/m68knommu/kernel/setup.c
@@ -54,9 +54,6 @@ void (*mach_reset)(void);
 void (*mach_halt)(void);
 void (*mach_power_off)(void);
 
-#ifdef CONFIG_M68000
-	#define CPU "MC68000"
-#endif
 #ifdef CONFIG_M68328
 	#define CPU "MC68328"
 #endif
-- 
1.7.0.4

