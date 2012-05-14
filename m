Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab2ENTrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 15:47:15 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:49303 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab2ENTrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 15:47:13 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Eric Dumazet <edumazet@google.com>, Dave Taht <dave.taht@bufferbloat.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] net/codel: Add missing #include <linux/prefetch.h>
Date: Mon, 14 May 2012 21:47:05 +0200
Message-Id: <1337024825-20130-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k allmodconfig:

net/sched/sch_codel.c: In function ‘dequeue’:
net/sched/sch_codel.c:70: error: implicit declaration of function ‘prefetch’
make[1]: *** [net/sched/sch_codel.o] Error 1

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/6320394/

 net/sched/sch_codel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index b4a1a81..213ef60 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -46,6 +46,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/skbuff.h>
+#include <linux/prefetch.h>
 #include <net/pkt_sched.h>
 #include <net/codel.h>
 
-- 
1.7.0.4

