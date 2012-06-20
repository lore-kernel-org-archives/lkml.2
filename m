Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab2FTUL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:11:56 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:34052 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074Ab2FTUKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:10:03 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5/6] mn10300: mm/dma-alloc.c needs <linux/export.h>
Date: Wed, 20 Jun 2012 22:09:49 +0200
Message-Id: <1340222990-20796-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340222990-20796-1-git-send-email-geert@linux-m68k.org>
References: <1340222990-20796-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/mn10300/mm/dma-alloc.c: At top level:
arch/mn10300/mm/dma-alloc.c:63:1: warning: data definition has no type or storage class [enabled by default]
arch/mn10300/mm/dma-alloc.c:63:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
arch/mn10300/mm/dma-alloc.c:63:1: warning: parameter names (without types) in function declaration [enabled by default]
arch/mn10300/mm/dma-alloc.c:75:1: warning: data definition has no type or storage class [enabled by default]
arch/mn10300/mm/dma-alloc.c:75:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
arch/mn10300/mm/dma-alloc.c:75:1: warning: parameter names (without types) in function declaration [enabled by default]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/mn10300/mm/dma-alloc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mn10300/mm/dma-alloc.c b/arch/mn10300/mm/dma-alloc.c
index 159acb0..e244ebe 100644
--- a/arch/mn10300/mm/dma-alloc.c
+++ b/arch/mn10300/mm/dma-alloc.c
@@ -15,6 +15,7 @@
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <linux/gfp.h>
+#include <linux/export.h>
 #include <asm/io.h>
 
 static unsigned long pci_sram_allocated = 0xbc000000;
-- 
1.7.0.4

