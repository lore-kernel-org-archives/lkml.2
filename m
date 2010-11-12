Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab0KLVuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:50:21 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48800 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993Ab0KLVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:50:16 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61777454"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-msm@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 3/3] msm: Warning cleanup
Date: Fri, 12 Nov 2010 13:49:53 -0800
Message-Id: <1289598593-8974-3-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1289598593-8974-1-git-send-email-davidb@codeaurora.org>
References: <1289598593-8974-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define VMALLOC_END as an unsigned long to match expected type.
Eliminates a warning:

arch/arm/mm/init.c: In function 'mem_init':
arch/arm/mm/init.c:606: warning: format '%08lx' expects type
   'long unsigned int', but argument 12 has type 'unsigned int'

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/vmalloc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/vmalloc.h b/arch/arm/mach-msm/include/mach/vmalloc.h
index 31a32ad..d138448 100644
--- a/arch/arm/mach-msm/include/mach/vmalloc.h
+++ b/arch/arm/mach-msm/include/mach/vmalloc.h
@@ -16,7 +16,7 @@
 #ifndef __ASM_ARCH_MSM_VMALLOC_H
 #define __ASM_ARCH_MSM_VMALLOC_H
 
-#define VMALLOC_END	  0xd0000000
+#define VMALLOC_END	  0xd0000000UL
 
 #endif
 
-- 
1.7.3.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
