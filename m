Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab0HDMmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:42:40 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:57231 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932728Ab0HDMmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:42:37 -0400
Date: Wed, 4 Aug 2010 14:42:34 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 8/9] arch/m68knommu: Removing dead RAM_{16,32}_MB config
 option
Message-ID: <3ba7c2ddfd4d89be04e03f3f58b8b8a7da4b06ad.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_RAM_{16,32}_MB doesn't exist in Kconfig, therefore removing
all references to it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/m68knommu/platform/68328/head-de2.S |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/m68knommu/platform/68328/head-de2.S b/arch/m68knommu/platform/68328/head-de2.S
index 92d9645..f632fdc 100644
--- a/arch/m68knommu/platform/68328/head-de2.S
+++ b/arch/m68knommu/platform/68328/head-de2.S
@@ -1,11 +1,5 @@
 
-#if defined(CONFIG_RAM32MB)
-#define	MEM_END	0x02000000	/* Memory size 32Mb */
-#elif defined(CONFIG_RAM16MB)
-#define	MEM_END	0x01000000	/* Memory size 16Mb */
-#else
 #define	MEM_END	0x00800000	/* Memory size 8Mb */
-#endif
 
 #undef CRT_DEBUG
 
-- 
1.7.0.4

