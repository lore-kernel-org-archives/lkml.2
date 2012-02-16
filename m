Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2BPOqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:46:07 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43495 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511Ab2BPOqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:46:04 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Jiandong Zheng <jdzheng@broadcom.com>
Cc: Danny Kukawka <dkukawka@suse.de>, Scott Branden <sbranden@broadcom.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/arm/mach-bcmring/dma.c: included linux/sched.h twice
Date: Thu, 16 Feb 2012 15:45:58 +0100
Message-Id: <1329403558-32661-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329403564;6c8986b5;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-bcmring/dma.c included 'linux/sched.h' twice,
remove the duplicates.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 arch/arm/mach-bcmring/dma.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-bcmring/dma.c b/arch/arm/mach-bcmring/dma.c
index 1024396..e5fd241 100644
--- a/arch/arm/mach-bcmring/dma.c
+++ b/arch/arm/mach-bcmring/dma.c
@@ -35,7 +35,6 @@
 
 #include <linux/pfn.h>
 #include <linux/atomic.h>
-#include <linux/sched.h>
 #include <mach/dma.h>
 
 /* ---- Public Variables ------------------------------------------------- */
-- 
1.7.8.3

