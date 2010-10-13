Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0JMMfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:35:38 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:41565
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754100Ab0JMMfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:35:36 -0400
X-SpamScore: 5
X-BigFish: VS5(z5edIzc8kzz1202hzz8275bh92fbjz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0LA8AYZ-02-SBQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] x86/amd-iommu: Update copyright headers
Date: Wed, 13 Oct 2010 14:36:04 +0200
Message-ID: <1286973364-17077-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286973364-17077-1-git-send-email-joerg.roedel@amd.com>
References: <1286973364-17077-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the copyright headers in all source files
of the AMD IOMMU driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu.h       |    2 +-
 arch/x86/include/asm/amd_iommu_proto.h |    2 +-
 arch/x86/include/asm/amd_iommu_types.h |    2 +-
 arch/x86/kernel/amd_iommu.c            |    2 +-
 arch/x86/kernel/amd_iommu_init.c       |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index 5af2982..f16a2ca 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2010 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
index cb03037..916bc81 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2009 Advanced Micro Devices, Inc.
+ * Copyright (C) 2009-2010 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index bdd20c8..e3509fc 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2010 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 679b645..d2fdb08 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2010 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 44710d8..3cb482e 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2007-2009 Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2010 Advanced Micro Devices, Inc.
  * Author: Joerg Roedel <joerg.roedel@amd.com>
  *         Leo Duran <leo.duran@amd.com>
  *
-- 
1.7.0.4


