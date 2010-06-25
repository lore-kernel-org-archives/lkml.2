Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab0FYN7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:59:47 -0400
Received: from [18.85.46.34] ([18.85.46.34]:57134 "EHLO bombadil.infradead.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756062Ab0FYN7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:59:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: [GIT PULL 0/6] perf/core improvements and fixes for 2.6.36
Date: Fri, 25 Jun 2010 10:59:20 -0300
Message-Id: <1277474366-7958-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (4):
  perf ui: Introduce routine ui_browser__is_current_entry
  perf ui: Introduce ui_browser->seek to support multiple list structures
  perf ui: Separate showing the entries from running the browser
  perf ui: Move objdump_line specific stuff out of ui_browser

Gui Jianfeng (1):
  perf kvm: Get rid of unused guest_kallsyms

Tom Zanussi (1):
  perf scripts perl: Makefile fix

 tools/perf/Makefile         |    2 +-
 tools/perf/builtin-record.c |    9 --
 tools/perf/util/newt.c      |  185 +++++++++++++++++++++++++------------------
 3 files changed, 109 insertions(+), 87 deletions(-)

