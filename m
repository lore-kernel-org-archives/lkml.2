Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab2J3NDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 09:03:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:55799 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452Ab2J3NCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 09:02:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Jones <drjones@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        arnaldo.melo@gmail.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 0/2] perf/urgent fixes
Date: Tue, 30 Oct 2012 11:02:37 -0200
Message-Id: <1351602159-10340-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 0d855354ea351bec6b222e9fea86a876cfafdcb6:

  perf, powerpc: Fix hw breakpoints returning -ENOSPC (2012-10-30 10:07:58 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to f787d9519fb10411f2948f5b9957a1669879ba84:

  perf tools: Fix strbuf_addf() when the buffer needs to grow (2012-10-30 10:32:56 -0200)

----------------------------------------------------------------
perf/urgent fixes

.  Fix numa topology printing, from Namhyung Kim.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Namhyung Kim (2):
      perf header: Fix numa topology printing
      perf tools: Fix strbuf_addf() when the buffer needs to grow

 tools/perf/util/header.c |    2 ++
 tools/perf/util/strbuf.c |    8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)
