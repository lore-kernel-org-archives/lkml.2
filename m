Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab1KHK3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 05:29:36 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42581 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1KHK3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 05:29:34 -0500
From: tom.leiming@gmail.com
To: tony@atomide.com, joerg.roedel@amd.com
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] iommu: omap: fix compile failure
Date: Tue,  8 Nov 2011 18:29:15 +0800
Message-Id: <1320748155-18818-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Fix the failure below:

  CC      drivers/iommu/omap-iommu-debug.o
drivers/iommu/omap-iommu-debug.c:416:20: error: expected declaration
specifiers or '...' before string constant
drivers/iommu/omap-iommu-debug.c:416:1: warning: data definition has no
type or storage class
drivers/iommu/omap-iommu-debug.c:416:1: warning: type defaults to 'int'
in declaration of 'MODULE_DESCRIPTION'
drivers/iommu/omap-iommu-debug.c:416:20: warning: function declaration
isn't a prototype
drivers/iommu/omap-iommu-debug.c:417:15: error: expected declaration
specifiers or '...' before string constant
drivers/iommu/omap-iommu-debug.c:417:1: warning: data definition has no
type or storage class
drivers/iommu/omap-iommu-debug.c:417:1: warning: type defaults to 'int'
in declaration of 'MODULE_AUTHOR'
drivers/iommu/omap-iommu-debug.c:417:15: warning: function declaration
isn't a prototype
drivers/iommu/omap-iommu-debug.c:418:16: error: expected declaration
specifiers or '...' before string constant
drivers/iommu/omap-iommu-debug.c:418:1: warning: data definition has no
type or storage class
drivers/iommu/omap-iommu-debug.c:418:1: warning: type defaults to 'int'
in declaration of 'MODULE_LICENSE'
drivers/iommu/omap-iommu-debug.c:418:16: warning: function declaration
isn't a prototype
make[2]: *** [drivers/iommu/omap-iommu-debug.o] Error 1
make[2]: *** Waiting for unfinished jobs....

drivers/iommu/omap-iovmm.c:247:1: warning: data definition has no type
or storage class
drivers/iommu/omap-iovmm.c:247:1: warning: type defaults to 'int' in
declaration of 'EXPORT_SYMBOL_GPL'
drivers/iommu/omap-iovmm.c:247:1: warning: parameter names (without
types) in function declaration
drivers/iommu/omap-iovmm.c:369:1: warning: data definition has no type
or storage class
drivers/iommu/omap-iovmm.c:369:1: warning: type defaults to 'int' in
declaration of 'EXPORT_SYMBOL_GPL'
drivers/iommu/omap-iovmm.c:369:1: warning: parameter names (without
types) in function declaration
drivers/iommu/omap-iovmm.c:620:1: warning: data definition has no type
or storage class
drivers/iommu/omap-iovmm.c:620:1: warning: type defaults to 'int' in
declaration of 'EXPORT_SYMBOL_GPL'
drivers/iommu/omap-iovmm.c:620:1: warning: parameter names (without
types) in function declaration
drivers/iommu/omap-iovmm.c:645:1: warning: data definition has no type
or storage class
drivers/iommu/omap-iovmm.c:645:1: warning: type defaults to 'int' in
declaration of 'EXPORT_SYMBOL_GPL'
drivers/iommu/omap-iovmm.c:645:1: warning: parameter names (without
types) in function declaration
drivers/iommu/omap-iovmm.c:696:1: warning: data definition has no type
or storage class
drivers/iommu/omap-iovmm.c:696:1: warning: type defaults to 'int' in
declaration of 'EXPORT_SYMBOL_GPL'
drivers/iommu/omap-iovmm.c:696:1: warning: parameter names (without
types) in function declaration
drivers/iommu/omap-iovmm.c:717:1: warning: data definition has no type
or storage class
drivers/iommu/omap-iovmm.c:717:1: warning: type defaults to 'int' in
declaration of 'EXPORT_SYMBOL_GPL'
drivers/iommu/omap-iovmm.c:717:1: warning: parameter names (without
types) in function declaration
drivers/iommu/omap-iovmm.c:740:20: error: expected declaration
specifiers or '...' before string constant
drivers/iommu/omap-iovmm.c:740:1: warning: data definition has no type
or storage class
drivers/iommu/omap-iovmm.c:740:1: warning: type defaults to 'int' in
declaration of 'MODULE_DESCRIPTION'
drivers/iommu/omap-iovmm.c:740:20: warning: function declaration isn't a
prototype
drivers/iommu/omap-iovmm.c:741:15: error: expected declaration
specifiers or '...' before string constant
drivers/iommu/omap-iovmm.c:741:1: warning: data definition has no type
or storage class
drivers/iommu/omap-iovmm.c:741:1: warning: type defaults to 'int' in
declaration of 'MODULE_AUTHOR'
drivers/iommu/omap-iovmm.c:741:15: warning: function declaration isn't a
prototype
drivers/iommu/omap-iovmm.c:742:16: error: expected declaration
specifiers or '...' before string constant
drivers/iommu/omap-iovmm.c:742:1: warning: data definition has no type
or storage class
drivers/iommu/omap-iovmm.c:742:1: warning: type defaults to 'int' in
declaration of 'MODULE_LICENSE'
drivers/iommu/omap-iovmm.c:742:16: warning: function declaration isn't a
prototype
make[2]: *** [drivers/iommu/omap-iovmm.o] Error 1
make[1]: *** [drivers/iommu] Error 2
make[1]: *** Waiting for unfinished jobs....

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/iommu/omap-iommu-debug.c |    1 +
 drivers/iommu/omap-iovmm.c       |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index 9c192e7..288da5c 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index e8fdb88..46be456 100644
--- a/drivers/iommu/omap-iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-- 
1.7.5.4

