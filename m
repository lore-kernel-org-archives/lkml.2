Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab1LLHQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:16:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60051 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab1LLHN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:13:58 -0500
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 07/11] kvm tools: move util.c to util/
Date: Mon, 12 Dec 2011 15:15:51 +0800
Message-Id: <1323674155-17570-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323674155-17570-1-git-send-email-laijs@cn.fujitsu.com>
References: <1323674155-17570-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-12 15:13:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-12 15:13:22,
	Serialize complete at 2011-12-12 15:13:22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

util.c is a lib for kvm.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 tools/kvm/Makefile          |    2 +-
 tools/kvm/{ => util}/util.c |    0
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename tools/kvm/{ => util}/util.c (100%)

diff --git a/tools/kvm/Makefile b/tools/kvm/Makefile
index bf0c9b4..56bdb96 100644
--- a/tools/kvm/Makefile
+++ b/tools/kvm/Makefile
@@ -51,7 +51,6 @@ OBJS	+= main.o
 OBJS	+= mmio.o
 OBJS	+= pci.o
 OBJS	+= term.o
-OBJS	+= util.o
 OBJS	+= virtio/blk.o
 OBJS	+= virtio/console.o
 OBJS	+= virtio/core.o
@@ -80,6 +79,7 @@ OBJS	+= util/parse-options.o
 OBJS	+= util/rbtree-interval.o
 OBJS	+= util/strbuf.o
 OBJS	+= util/read-write.o
+OBJS	+= util/util.o
 OBJS	+= virtio/9p.o
 OBJS	+= virtio/9p-pdu.o
 OBJS	+= hw/vesa.o
diff --git a/tools/kvm/util.c b/tools/kvm/util/util.c
similarity index 100%
rename from tools/kvm/util.c
rename to tools/kvm/util/util.c
-- 
1.7.4.4

