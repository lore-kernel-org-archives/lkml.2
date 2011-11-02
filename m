Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab1KBPZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:25:44 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11729 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab1KBPZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:25:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 02 Nov 2011 08:25:29 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "Stephen Warren" <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm/tegra: remove unused defines
Date: Wed, 2 Nov 2011 17:25:23 +0200
Message-ID: <1320247524-22425-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PPI_NR is never used in arch/arm/mach-tegra/irq.c. Remove it.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/irq.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index 4956c3c..8ad82af 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -28,10 +28,6 @@
 
 #include "board.h"
 
-#define INT_SYS_NR	(INT_GPIO_BASE - INT_PRI_BASE)
-#define INT_SYS_SZ	(INT_SEC_BASE - INT_PRI_BASE)
-#define PPI_NR		((INT_SYS_NR+INT_SYS_SZ-1)/INT_SYS_SZ)
-
 #define ICTLR_CPU_IEP_VFIQ	0x08
 #define ICTLR_CPU_IEP_FIR	0x14
 #define ICTLR_CPU_IEP_FIR_SET	0x18
-- 
1.7.7.rc0.72.g4b5ea.dirty

