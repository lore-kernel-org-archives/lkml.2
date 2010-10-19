Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab0JSD4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:56:10 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28439 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012Ab0JSD4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSoUA
Message-Id: <20101019034655.543736148@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:17 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 01/35] bit_spinlock: add required includes
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=bit_spinlock-includes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 include/linux/bit_spinlock.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/include/linux/bit_spinlock.h
===================================================================
--- linux-2.6.orig/include/linux/bit_spinlock.h	2010-10-19 14:17:28.000000000 +1100
+++ linux-2.6/include/linux/bit_spinlock.h	2010-10-19 14:18:58.000000000 +1100
@@ -1,6 +1,10 @@
 #ifndef __LINUX_BIT_SPINLOCK_H
 #define __LINUX_BIT_SPINLOCK_H
 
+#include <linux/kernel.h>
+#include <linux/preempt.h>
+#include <asm/atomic.h>
+
 /*
  *  bit-based spin_lock()
  *


