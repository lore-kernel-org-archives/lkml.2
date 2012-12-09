Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab2LIX7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 18:59:20 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:55015 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab2LIX7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 18:59:18 -0500
X-AuditID: cbfee61b-b7f616d00000319b-4a-50c525d5d466
From: Boojin Kim <boojin.kim@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Boojin Kim'" <boojin.kim@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH 2/3] ARM: MM: Add the workaround of Errata 773022
Date: Mon, 10 Dec 2012 08:59:17 +0900
Message-id: <001801cdd669$331c3850$9954a8f0$%kim@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3WZaq4ai+zcSB3TK2VBDX2Gj8fbAAABBCwAAAY9EAAAL+/8A==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t8zQ92rqkcDDGYdVLC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZV1tWsha0CVacmOPRwHiRt4uRk0NCwETi8KVXjBC2mMSFe+vZ
	uhi5OIQEljFK3HkwgwWmaOaM34wQiemMEt1bvkE585gk7u34xApSxSagKTHj+3R2EFtEwE3i
	RmMHE0gRs8AFRomd+74BJTiAOrglVjcHgdRwCvBIrPvTyQwSFhZwlPj1ORQkzCKgKvF/1iFG
	kDCvgK3E1FdgFRIC6hKP/upCDHeSaO05AnYzs4CIxL4X7xghOgUkvk0+xAJRLiux6QAzyH4J
	gc9sEien3If6UVLi4IobLBMYRWchaV/AyLiKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIySI
	pXcwrmqwOMQowMGoxMMboHg0QIg1say4MvcQowQHs5IIL9exIwFCvCmJlVWpRfnxRaU5qcWH
	GH2ArprILCWanA+MsLySeENjYxMzE1MTc0tTc1McwkrivM0eKQFCAumJJanZqakFqUUw45g4
	OKUaGP2c3vas76nY/dyXY4Lk3DpZQY15x2fdfppp6S4xLVfgQuSWhcKW678f3fdp51KHLR51
	5jmu8wSO+LzkNivvLUyOaYi9mPhR8v5TsQeVqzcJBGtJL7zoFXeyMWqyjAIL69SH4R+/+dxi
	WacbHae3sMpBrmSlO29L0fzsdfG+p3gWP3Bwi9DxU2Ipzkg01GIuKk4EAEI8lVGPAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t9jQd2rqkcDDBa8kbK4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGVdbVrIWtAlWnJjj0cB4
	kbeLkZNDQsBEYuaM34wQtpjEhXvr2boYuTiEBKYzSnRv+cYI4cxjkri34xMrSBWbgKbEjO/T
	2UFsEQE3iRuNHUwgRcwCFxgldu77BpTgAOrglljdHARSwynAI7HuTyczSFhYwFHi1+dQkDCL
	gKrE/1mHGEHCvAK2ElNfgVVICKhLPPqrCzHcSaK15wjYacwCIhL7XrxjnMDIPwuJu4CRcRWj
	aGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcIw8k97BuKrB4hCjAAejEg9vgOLRACHWxLLiytxD
	jBIczEoivFzHjgQI8aYkVlalFuXHF5XmpBYfYvQBum8is5Rocj4wfvNK4g2NTcyMLI3MLIxM
	zM1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRqYAy1ZNh7g+9evHfSqSlLE6xnLm85UC/b
	1txYXL/1++EtxU3Xnt3kuXr6Arv7WrNbsuyB2sv+i3GdfbR5l/AV6SNaX1o2zagyWugfZbDL
	S/K1Fs+/3r1a6VyPTnV95i/rmRrzrfqn38qfeyrNNkjUHZ23ft9WmVyN3JfrnqYqsTBq9j3I
	X1CUe1eJpTgj0VCLuag4EQCPgdUWvgIAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the workaround of Errata 773022 that disables loop buffer.

Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
---
 arch/arm/Kconfig             |   10 ++++++++++
 arch/arm/mach-exynos/Kconfig |    1 +
 arch/arm/mm/proc-v7.S        |    6 ++++++
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 11a57e2..93397da 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1417,6 +1417,16 @@ config ARM_ERRATA_775420
 	 to deadlock. This workaround puts DSB before executing ISB if
 	 an abort may occur on cache maintenance.

+config ARM_ERRATA_773022
+	bool "ARM errata: incorrect instructions may be executed from loop buffer"
+	depends on CPU_V7
+	help
+	  This option enables the workaround for the erratum 773022 affecting
+	  Cortex-A15 (r0p4).
+	  In certain rare sequences of code, the loop buffer may deliver
+	  incorrect instructions.
+	  This workaround is to disable loop buffer.
+
 config ARM_ERRATA_774769
 	bool "ARM errata: data corruption may occur with store streaming in a system"
 	depends on CPU_V7
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index e1168fb..bb92f4c 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -22,6 +22,7 @@ config ARCH_EXYNOS4
 config ARCH_EXYNOS5
 	bool "SAMSUNG EXYNOS5"
 	select HAVE_SMP
+	select ARM_ERRATA_773022
 	select ARM_ERRATA_774769
 	help
 	  Samsung EXYNOS5 (Cortex-A15) SoC based systems
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 06cbdfa..0b4c518 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -249,6 +249,12 @@ __v7_setup:
 3:	ldr	r10, =0x00000c0f		@ Cortex-A15 primary part number
 	teq	r0, r10
 	bne	4f
+#ifdef CONFIG_ARM_ERRATA_773022
+	teq	r6, #0x4			@ present in r0p4
+	mrceq	p15, 0, r10, c1, c0, 1		@ read aux control register
+	orreq	r10, r10, #1 << 1		@ set bit #1
+	mcreq	p15, 0, r10, c1, c0, 1		@ write aux control register
+#endif
 #ifdef CONFIG_ARM_ERRATA_774769
 	teq	r6, #0x4			@ present in r0p4
 	mrceq	p15, 0, r10, c1, c0, 1		@ read aux control register
--
1.7.5.4



