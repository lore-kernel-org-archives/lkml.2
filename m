Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab2DLEES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:04:18 -0400
Received: from fifo99.com ([67.223.236.141]:53413 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812Ab2DLEEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:04:15 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: David Brown <davidb@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH 2/2] arm: msm: halibut: remove unneeded fixup
Date: Wed, 11 Apr 2012 21:04:02 -0700
Message-Id: <1334203443-30011-2-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.7.10.130.g36e6c
In-Reply-To: <1334203443-30011-1-git-send-email-dwalker@fifo99.com>
References: <1334203443-30011-1-git-send-email-dwalker@fifo99.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This old fixup causes a build failure, so I remove it just like in
trout.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 arch/arm/mach-msm/board-halibut.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-msm/board-halibut.c b/arch/arm/mach-msm/board-halibut.c
index 3698a37..26aac36 100644
--- a/arch/arm/mach-msm/board-halibut.c
+++ b/arch/arm/mach-msm/board-halibut.c
@@ -86,9 +86,6 @@ static void __init halibut_init(void)
 static void __init halibut_fixup(struct tag *tags, char **cmdline,
 				 struct meminfo *mi)
 {
-	mi->nr_banks=1;
-	mi->bank[0].start = PHYS_OFFSET;
-	mi->bank[0].size = (101*1024*1024);
 }
 
 static void __init halibut_map_io(void)
-- 
1.7.10.130.g36e6c

