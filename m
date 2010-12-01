Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab0LABUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:20:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:58651 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab0LABUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:20:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf packaging: add memcpy to perf MANIFEST
Date: Tue, 30 Nov 2010 23:19:49 -0200
Message-Id: <1291166390-19467-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291166390-19467-1-git-send-email-acme@infradead.org>
References: <1291166390-19467-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

There seems to be a new dependency on arch/*/lib/memcpy*.S when compiling
the perf tool.  Make sure that file is included in the MANIFEST when
creating the tarball.

Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1291155133-3499-2-git-send-email-dzickus@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/MANIFEST |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 8c7fc0c..c12659d 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -7,6 +7,7 @@ include/linux/stringify.h
 lib/rbtree.c
 include/linux/swab.h
 arch/*/include/asm/unistd*.h
+arch/*/lib/memcpy*.S
 include/linux/poison.h
 include/linux/magic.h
 include/linux/hw_breakpoint.h
-- 
1.6.2.5

