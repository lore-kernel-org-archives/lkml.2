Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab2DAUjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:39:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:54137 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2DAUjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:39:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: dhowells@redhat.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 08/11] frv: fix warnings in mb93090-mb00/pci-dma.c about implicit EXPORT_SYMBOL
Date: Sun,  1 Apr 2012 16:38:44 -0400
Message-Id: <1333312727-11428-9-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fix:

arch/frv/mb93090-mb00/pci-dma.c:31:1: warning: data definition has no type or storage class [enabled by default]
arch/frv/mb93090-mb00/pci-dma.c:31:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
arch/frv/mb93090-mb00/pci-dma.c:31:1: warning: parameter names (without types) in function declaration [enabled by default]
arch/frv/mb93090-mb00/pci-dma.c:38:1: warning: data definition has no type or storage class [enabled by default]

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/frv/mb93090-mb00/pci-dma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/frv/mb93090-mb00/pci-dma.c b/arch/frv/mb93090-mb00/pci-dma.c
index 41098a3..4f8d8bc 100644
--- a/arch/frv/mb93090-mb00/pci-dma.c
+++ b/arch/frv/mb93090-mb00/pci-dma.c
@@ -13,6 +13,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/list.h>
 #include <linux/pci.h>
+#include <linux/export.h>
 #include <linux/highmem.h>
 #include <linux/scatterlist.h>
 #include <asm/io.h>
-- 
1.7.9.1

