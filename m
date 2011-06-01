Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733Ab1FATrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:47:52 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59174 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759660Ab1FATrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:47:48 -0400
Message-Id: <20110601180610.684557757@duck.linux-mips.net>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 19:05:05 +0100
From: ralf@linux-mips.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [patch 09/14] i8253: Alpha, PowerPC: Remove unused <asm/8253pit.h> header.
References: <20110601180456.801265664@duck.linux-mips.net>
Content-Disposition: inline; filename=i8253-remove-unused-8253pit.h-files.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org

 arch/alpha/include/asm/8253pit.h   |    3 ---
 arch/powerpc/include/asm/8253pit.h |    3 ---
 2 files changed, 6 deletions(-)

Index: linux-mips/arch/alpha/include/asm/8253pit.h
===================================================================
--- linux-mips.orig/arch/alpha/include/asm/8253pit.h
+++ /dev/null
@@ -1,3 +0,0 @@
-/*
- * 8253/8254 Programmable Interval Timer
- */
Index: linux-mips/arch/powerpc/include/asm/8253pit.h
===================================================================
--- linux-mips.orig/arch/powerpc/include/asm/8253pit.h
+++ /dev/null
@@ -1,3 +0,0 @@
-/*
- * 8253/8254 Programmable Interval Timer
- */


