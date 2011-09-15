Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934875Ab1IOUQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:16:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:46846 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934648Ab1IOUKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873425"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, geert@linux-m68k.org
Subject: [PATCH 05/27] Initconst section fixes for M68K
Date: Thu, 15 Sep 2011 13:09:32 -0700
Message-Id: <1316117394-21666-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: geert@linux-m68k.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/m68k/emu/nfeth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/emu/nfeth.c b/arch/m68k/emu/nfeth.c
index c5748bb..a985a7e 100644
--- a/arch/m68k/emu/nfeth.c
+++ b/arch/m68k/emu/nfeth.c
@@ -39,7 +39,7 @@ enum {
 #define MAX_UNIT	8
 
 /* These identify the driver base version and may not be removed. */
-static const char version[] __devinitdata =
+static const char version[] __devinitconst =
 	KERN_INFO KBUILD_MODNAME ".c:v" DRV_VERSION " " DRV_RELDATE
 	" S.Opichal, M.Jurik, P.Stehlik\n"
 	KERN_INFO " http://aranym.org/\n";
-- 
1.7.4.4

