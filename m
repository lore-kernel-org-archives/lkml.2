Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab1G2THl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 15:07:41 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:56918 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751496Ab1G2THj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 15:07:39 -0400
Date: Fri, 29 Jul 2011 12:07:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] x86: files need export.h
Message-Id: <20110729120734.cec5168f.rdunlap@xenotime.net>
In-Reply-To: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix multiple build errors due to missing export.h header file.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 arch/x86/kernel/e820.c    |    1 +
 arch/x86/kernel/pci-dma.c |    1 +
 arch/x86/kernel/rtc.c     |    1 +
 3 files changed, 3 insertions(+)

--- linux-next-20110729.orig/arch/x86/kernel/e820.c
+++ linux-next-20110729/arch/x86/kernel/e820.c
@@ -16,6 +16,7 @@
 #include <linux/pfn.h>
 #include <linux/suspend.h>
 #include <linux/acpi.h>
+#include <linux/export.h>
 #include <linux/firmware-map.h>
 #include <linux/memblock.h>
 #include <linux/sort.h>
--- linux-next-20110729.orig/arch/x86/kernel/pci-dma.c
+++ linux-next-20110729/arch/x86/kernel/pci-dma.c
@@ -1,6 +1,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/dma-debug.h>
 #include <linux/dmar.h>
+#include <linux/export.h>
 #include <linux/bootmem.h>
 #include <linux/gfp.h>
 #include <linux/pci.h>
--- linux-next-20110729.orig/arch/x86/kernel/rtc.c
+++ linux-next-20110729/arch/x86/kernel/rtc.c
@@ -5,6 +5,7 @@
 #include <linux/mc146818rtc.h>
 #include <linux/acpi.h>
 #include <linux/bcd.h>
+#include <linux/export.h>
 #include <linux/pnp.h>
 #include <linux/of.h>
 
