Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab1LLHOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:14:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61318 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab1LLHN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:13:56 -0500
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 03/11] kvm tools: move threadpool.c to util/
Date: Mon, 12 Dec 2011 15:15:47 +0800
Message-Id: <1323674155-17570-4-git-send-email-laijs@cn.fujitsu.com>
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

threadpool.c contains no kvm related code, it is just a lib.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 tools/kvm/Makefile                |    2 +-
 tools/kvm/{ => util}/threadpool.c |    0
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename tools/kvm/{ => util}/threadpool.c (100%)

diff --git a/tools/kvm/Makefile b/tools/kvm/Makefile
index cef3c44..b0bb266 100644
--- a/tools/kvm/Makefile
+++ b/tools/kvm/Makefile
@@ -76,7 +76,7 @@ OBJS	+= net/uip/csum.o
 OBJS	+= net/uip/dhcp.o
 OBJS	+= kvm-cmd.o
 OBJS	+= rbtree.o
-OBJS	+= threadpool.o
+OBJS	+= util/threadpool.o
 OBJS	+= util/parse-options.o
 OBJS	+= util/rbtree-interval.o
 OBJS	+= util/strbuf.o
diff --git a/tools/kvm/threadpool.c b/tools/kvm/util/threadpool.c
similarity index 100%
rename from tools/kvm/threadpool.c
rename to tools/kvm/util/threadpool.c
-- 
1.7.4.4

