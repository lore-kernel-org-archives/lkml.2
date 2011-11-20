Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab2DRAVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:21:17 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56159 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2DRAVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:21:13 -0400
Message-Id: <8675ae$5bugrn@wolverine02.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6684"; a="180306807"
From: Jesper Juhl <jj@chaosbits.net>
Date: Sun, 20 Nov 2011 21:59:55 +0100
Subject: [PATCH 03/10] Remove unneeded include of version.h from arch/hexagon/include/asm/spinlock_types.h
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"make versioncheck" points out that arch/hexagon/include/asm/spinlock_types.h
does not need to include version.h .
A quick look at the file seems to confirm its findings, so here's a patch that
removes the include.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/include/asm/spinlock_types.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/hexagon/include/asm/spinlock_types.h b/arch/hexagon/include/asm/spinlock_types.h
index 5e937af..99b5a75 100644
--- a/arch/hexagon/include/asm/spinlock_types.h
+++ b/arch/hexagon/include/asm/spinlock_types.h
@@ -21,8 +21,6 @@
 #ifndef _ASM_SPINLOCK_TYPES_H
 #define _ASM_SPINLOCK_TYPES_H
 
-#include <linux/version.h>
-
 #ifndef __LINUX_SPINLOCK_TYPES_H
 # error "please don't include this file directly"
 #endif
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
