Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1ERVZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:25:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51637 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab1ERVZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iTmOK9tfdypwWvkfsGLO8R6KeRJJ+sOKANjtE4q1VR+hjgWlxWmlYzIq99PPVmrzH/
         /W2rMbr7hQxwBlCBrYRkU/AEzsCmWAekJ2Ml3aFh95eHTvlZaW/sL8MChmvjUPlMLsV9
         ZQxO5it4ShmP5ukDMUmvogeIdJ4A5SSbtMaSE=
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, bg-linux@lists.anl-external.org,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH 2/7] [RFC] add bluegene entry to cputable
Date: Wed, 18 May 2011 16:24:50 -0500
Message-Id: <1305753895-24845-2-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 arch/powerpc/kernel/cputable.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index b9602ee..0eb245e 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -1732,6 +1732,20 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.machine_check		= machine_check_440A,
 		.platform		= "ppc440",
 	},
+	{ /* Blue Gene/P */
+		.pvr_mask		= 0xfffffff0,
+		.pvr_value		= 0x52131880,
+		.cpu_name		= "450 Blue Gene/P",
+		.cpu_features		= CPU_FTRS_440x6,
+		.cpu_user_features	= COMMON_USER_BOOKE |
+						PPC_FEATURE_HAS_FPU,
+		.mmu_features		= MMU_FTR_TYPE_44x,
+		.icache_bsize		= 32,
+		.dcache_bsize		= 32,
+		.cpu_setup		= __setup_cpu_460gt,
+		.machine_check		= machine_check_440A,
+		.platform		= "ppc440",
+	},
 	{ /* 460EX */
 		.pvr_mask		= 0xffff0006,
 		.pvr_value		= 0x13020002,
-- 
1.7.4.1

