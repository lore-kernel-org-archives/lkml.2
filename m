Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965074Ab2JAXXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:23:37 -0400
Received: from 1wt.eu ([62.212.114.60]:35349 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932902Ab2JAXBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:22 -0400
Message-Id: <20121001225204.265045183@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 157/180] x86, cpu: Add CPU flags for F16C and RDRND
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: H. Peter Anvin <hpa@zytor.com>

commit 24da9c26f3050aee9314ec09930a24c80fe76352 upstream.

Add support for the newly documented F16C (16-bit floating point
conversions) and RDRND (RDRAND instruction) CPU feature flags.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/include/asm/cpufeature.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 1efb1fa..84d5337 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -124,6 +124,8 @@
 #define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
 #define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
 #define X86_FEATURE_AVX		(4*32+28) /* Advanced Vector Extensions */
+#define X86_FEATURE_F16C	(4*32+29) /* 16-bit fp conversions */
+#define X86_FEATURE_RDRND	(4*32+30) /* The RDRAND instruction */
 #define X86_FEATURE_HYPERVISOR	(4*32+31) /* Running on a hypervisor */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
-- 
1.7.2.1.45.g54fbc



