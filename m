Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0LAJOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:14:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:54290 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab0LAJOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:14:14 -0500
Date: Wed, 1 Dec 2010 09:13:55 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1291155133-3499-2-git-send-email-dzickus@redhat.com>
References: <1291155133-3499-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf packaging: add memcpy to perf MANIFEST
Message-ID: <tip-3e8e24f2fc66d32eb0e570e4117dfd05227047e6@git.kernel.org>
Git-Commit-ID: 3e8e24f2fc66d32eb0e570e4117dfd05227047e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Dec 2010 09:13:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e8e24f2fc66d32eb0e570e4117dfd05227047e6
Gitweb:     http://git.kernel.org/tip/3e8e24f2fc66d32eb0e570e4117dfd05227047e6
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Tue, 30 Nov 2010 17:12:13 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 30 Nov 2010 23:00:10 -0200

perf packaging: add memcpy to perf MANIFEST

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
