Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab1F2Xep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 19:34:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58062 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab1F2XeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 19:34:21 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Sam Liao <phyomh@gmail.com>
Subject: [PATCH 3/6] perf tools: Remove sort print helpers declarations
Date: Thu, 30 Jun 2011 01:34:05 +0200
Message-Id: <1309390448-9160-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309390448-9160-1-git-send-email-fweisbec@gmail.com>
References: <1309390448-9160-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are probably some old leftovers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Sam Liao <phyomh@gmail.com>
---
 tools/perf/util/sort.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 4a6d309..77d0388 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -103,12 +103,6 @@ extern struct sort_entry sort_thread;
 extern struct list_head hist_entry__sort_list;
 
 void setup_sorting(const char * const usagestr[], const struct option *opts);
-
-extern size_t sort__thread_print(FILE *, struct hist_entry *, unsigned int);
-extern size_t sort__comm_print(FILE *, struct hist_entry *, unsigned int);
-extern size_t sort__dso_print(FILE *, struct hist_entry *, unsigned int);
-extern size_t sort__sym_print(FILE *, struct hist_entry *, unsigned int __used);
-extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
 extern int sort_dimension__add(const char *);
 void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
 			     const char *list_name, FILE *fp);
-- 
1.7.5.4

