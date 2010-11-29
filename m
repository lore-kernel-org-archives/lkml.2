Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0K2Wa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:30:28 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:45208 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab0K2Wa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:30:26 -0500
Date: Mon, 29 Nov 2010 14:30:22 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mathieu.desnoyers@efficios.com
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix ppc asm typo
Message-ID: <20101129223022.GA9205@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ppc asm typo.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/urcu/uatomic_arch_ppc.h b/urcu/uatomic_arch_ppc.h
index 426b0f2..bb74934 100644
--- a/urcu/uatomic_arch_ppc.h
+++ b/urcu/uatomic_arch_ppc.h
@@ -133,7 +133,7 @@ unsigned long _uatomic_cmpxchg(void *addr, unsigned long old,
 			"bne- 1b\n"	 	/* retry if lost reservation */
 			"isync\n"
 		"2:\n"
-				: "=&r"(old_val),
+				: "=&r"(old_val)
 				: "r"(addr), "r"((unsigned long)_new),
 				  "r"((unsigned long)old)
 				: "memory", "cc");
