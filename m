Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab1JQNy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 09:54:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41320 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab1JQNy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 09:54:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf hists browser: Add missing stdarg.h include
Date: Mon, 17 Oct 2011 11:54:19 -0200
Message-Id: <1318859659-1171-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318859659-1171-1-git-send-email-acme@infradead.org>
References: <1318859659-1171-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

    CC util/ui/browsers/annotate.o
In file included from util/ui/browsers/annotate.c:2:0:
util/ui/browsers/../helpline.h:9:42: error: expected declaration
specifiers or ‘...’ before ‘va_list’
    CC util/ui/browsers/hists.o
make: *** [util/ui/browsers/annotate.o] Error 1
make: *** Waiting for unfinished jobs....

Signed-off-by: Mike Galbraith <efault@gmx.de>
Link: http://lkml.kernel.org/n/tip-9vefl2807smi7t4luhs00tg6@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/helpline.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/ui/helpline.h b/tools/perf/util/ui/helpline.h
index 8099757..fdcbc02 100644
--- a/tools/perf/util/ui/helpline.h
+++ b/tools/perf/util/ui/helpline.h
@@ -2,6 +2,7 @@
 #define _PERF_UI_HELPLINE_H_ 1
 
 #include <stdio.h>
+#include <stdarg.h>
 
 void ui_helpline__init(void);
 void ui_helpline__pop(void);
-- 
1.6.2.5

