Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761841Ab2FEK4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:56:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55468 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2FEK4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:56:05 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <xtfeng@gmail.com>,
        Xiaotian Feng <dannyfeng@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -tip 1/2] x86/pci: remove include of kmemleak.h
Date: Tue,  5 Jun 2012 14:59:51 -0400
Message-Id: <1338922791-2809-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As dma32_reserve_bootmem was removed by commit 5491ff5, the only
user has been gone, so remove the include of kmemleak.h

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de> 
Cc: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/pci-dma.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 62c9457..3b42e53 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -5,7 +5,6 @@
 #include <linux/bootmem.h>
 #include <linux/gfp.h>
 #include <linux/pci.h>
-#include <linux/kmemleak.h>
 
 #include <asm/proto.h>
 #include <asm/dma.h>
-- 
1.7.9.5

