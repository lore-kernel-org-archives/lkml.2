Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0CWReQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:34:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36383 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab0CWReP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:34:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf archive: Explain how to use the generated tarball
Date: Tue, 23 Mar 2010 14:33:58 -0300
Message-Id: <1269365638-10223-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[root@doppio ~]# perf archive
Now please run:

$ tar xvf perf.data.tar.bz2 -C ~/.debug

wherever you need to run 'perf report' on.
[root@doppio ~]#

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf-archive.sh |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/perf-archive.sh b/tools/perf/perf-archive.sh
index 910468e..2e7a4f4 100644
--- a/tools/perf/perf-archive.sh
+++ b/tools/perf/perf-archive.sh
@@ -30,4 +30,7 @@ done
 
 tar cfj $PERF_DATA.tar.bz2 -C $DEBUGDIR -T $MANIFEST
 rm -f $MANIFEST $BUILDIDS
+echo -e "Now please run:\n"
+echo -e "$ tar xvf $PERF_DATA.tar.bz2 -C ~/.debug\n"
+echo "wherever you need to run 'perf report' on."
 exit 0
-- 
1.6.2.5

