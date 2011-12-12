Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab1LLHOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:14:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63255 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab1LLHOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:14:05 -0500
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 04/11] kvm tools: move rbtree.o to util/
Date: Mon, 12 Dec 2011 15:15:48 +0800
Message-Id: <1323674155-17570-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323674155-17570-1-git-send-email-laijs@cn.fujitsu.com>
References: <1323674155-17570-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-12 15:13:20,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-12 15:13:21,
	Serialize complete at 2011-12-12 15:13:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rbtree.o is just a lib for kvm.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 tools/kvm/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/kvm/Makefile b/tools/kvm/Makefile
index b0bb266..9ddc3b3 100644
--- a/tools/kvm/Makefile
+++ b/tools/kvm/Makefile
@@ -75,7 +75,7 @@ OBJS	+= net/uip/buf.o
 OBJS	+= net/uip/csum.o
 OBJS	+= net/uip/dhcp.o
 OBJS	+= kvm-cmd.o
-OBJS	+= rbtree.o
+OBJS	+= util/rbtree.o
 OBJS	+= util/threadpool.o
 OBJS	+= util/parse-options.o
 OBJS	+= util/rbtree-interval.o
@@ -240,7 +240,7 @@ builtin-help.d: $(KVM_INCLUDE)/common-cmds.h
 
 $(OBJS):
 
-rbtree.o: ../../lib/rbtree.c
+util/rbtree.o: ../../lib/rbtree.c
 	$(Q) $(CC) -c $(CFLAGS) $< -o $@
 
 %.o: %.c
-- 
1.7.4.4

