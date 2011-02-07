Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab1BGPCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:02:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab1BGPAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:00:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Denis Kirjanov <dkirjanov@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/9] perf top: Use pid_t for target_{pid|tid}
Date: Mon,  7 Feb 2011 13:00:05 -0200
Message-Id: <1297090812-10782-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297090812-10782-1-git-send-email-acme@infradead.org>
References: <1297090812-10782-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Kirjanov <dkirjanov@kernel.org>

Use pid_t data type for target_{pid|tid} vars.

Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20110205203938.GA15328@hera.kernel.org>
Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
[ committer note: those variables are now in struct perf_top, fixed ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/top.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index fe44afb..62e3293 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -46,8 +46,8 @@ struct perf_top {
 	u64		   exact_samples;
 	u64		   guest_us_samples, guest_kernel_samples;
 	int		   print_entries, count_filter, delay_secs;
-	int		   display_weighted, freq, rb_entries;
-	int		   sym_counter, target_pid, target_tid;
+	int		   display_weighted, freq, rb_entries, sym_counter;
+	pid_t		   target_pid, target_tid;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
 	const char	   *cpu_list;
 	struct perf_evsel  *sym_evsel;
-- 
1.6.2.5

