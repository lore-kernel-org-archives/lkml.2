Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1KCGub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 02:50:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38784 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1KCGua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 02:50:30 -0400
Message-ID: <1320303023.17983.2.camel@phoenix>
Subject: [PATCH] ARM: OMAP: omap_device: Include linux/export.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 03 Nov 2011 14:50:23 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/export.h to fix below build warning:

  CC      arch/arm/plat-omap/omap_device.o
arch/arm/plat-omap/omap_device.c:1055: warning: data definition has no type or storage class
arch/arm/plat-omap/omap_device.c:1055: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL'
arch/arm/plat-omap/omap_device.c:1055: warning: parameter names (without types) in function declaration

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/plat-omap/omap_device.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/omap_device.c b/arch/arm/plat-omap/omap_device.c
index cd90bed..f839f94 100644
--- a/arch/arm/plat-omap/omap_device.c
+++ b/arch/arm/plat-omap/omap_device.c
@@ -78,6 +78,7 @@
 #undef DEBUG
 
 #include <linux/kernel.h>
+#include <linux/export.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/err.h>
-- 
1.7.5.4



