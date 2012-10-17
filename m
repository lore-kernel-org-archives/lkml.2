Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab2JQFG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:06:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36392 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2JQFG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:06:58 -0400
Date: Wed, 17 Oct 2012 01:06:56 -0400 (EDT)
Message-Id: <20121017.010656.383828471689899431.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
CC: paulus@samba.org, mingo@redhat.com, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix 'perf' build on sparc.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


More UAPI stuff.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 2762877..c50985e 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -57,7 +57,7 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __sparc__
-#include "../../arch/sparc/include/asm/unistd.h"
+#include "../../arch/sparc/include/uapi/asm/unistd.h"
 #define rmb()		asm volatile("":::"memory")
 #define cpu_relax()	asm volatile("":::"memory")
 #define CPUINFO_PROC	"cpu"
