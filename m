Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679Ab1FATrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:47:43 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59157 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759660Ab1FATrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:47:41 -0400
Message-Id: <20110601180610.608083130@duck.linux-mips.net>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 19:05:04 +0100
From: ralf@linux-mips.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
Subject: [patch 08/14] i8253: Alpha: Cleanup remaining users of i8253pit.h
References: <20110601180456.801265664@duck.linux-mips.net>
Content-Disposition: inline; filename=i8253-cleanup-remaining-alpha-users-of-8253pit.h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Alpha <asm/i8253pit.h> header is empty so this inclusion can just be
removed.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org

 arch/alpha/kernel/sys_ruffian.c |    1 -
 arch/alpha/kernel/time.c        |    1 -
 2 files changed, 2 deletions(-)

Index: linux-mips/arch/alpha/kernel/sys_ruffian.c
===================================================================
--- linux-mips.orig/arch/alpha/kernel/sys_ruffian.c
+++ linux-mips/arch/alpha/kernel/sys_ruffian.c
@@ -26,7 +26,6 @@
 #include <asm/pgtable.h>
 #include <asm/core_cia.h>
 #include <asm/tlbflush.h>
-#include <asm/8253pit.h>
 
 #include "proto.h"
 #include "irq_impl.h"
Index: linux-mips/arch/alpha/kernel/time.c
===================================================================
--- linux-mips.orig/arch/alpha/kernel/time.c
+++ linux-mips/arch/alpha/kernel/time.c
@@ -46,7 +46,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/hwrpb.h>
-#include <asm/8253pit.h>
 #include <asm/rtc.h>
 
 #include <linux/mc146818rtc.h>


