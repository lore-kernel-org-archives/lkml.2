Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab2DUJKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:10:21 -0400
Received: from smtp4.mail.ru ([94.100.176.44]:47090 "EHLO smtp4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab2DUJKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:10:16 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 05/17] ARM clps711x: Added missing definitions for PORT C
Date: Sat, 21 Apr 2012 13:11:18 +0400
Message-Id: <1334999490-27177-6-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 arch/arm/include/asm/hardware/clps7111.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/hardware/clps7111.h b/arch/arm/include/asm/hardware/clps7111.h
index 4447722..84358d8 100644
--- a/arch/arm/include/asm/hardware/clps7111.h
+++ b/arch/arm/include/asm/hardware/clps7111.h
@@ -36,9 +36,11 @@
 
 #define PADR		(0x0000)
 #define PBDR		(0x0001)
+#define PCDR		(0x0002)
 #define PDDR		(0x0003)
 #define PADDR		(0x0040)
 #define PBDDR		(0x0041)
+#define PCDDR		(0x0042)
 #define PDDDR		(0x0043)
 #define PEDR		(0x0080)
 #define PEDDR		(0x00c0)
-- 
1.7.3.4

