Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab1DUJXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 05:23:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:41920 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab1DUJXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 05:23:50 -0400
Date: Thu, 21 Apr 2011 09:23:42 GMT
From: tip-bot for Michael Witten <mfwitten@gmail.com>
Message-ID: <tip-a6zhefjayuounko1tk5sjji2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, mfwitten@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, mfwitten@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: git mv tools/perf/{features-tests.mak,config/}
Git-Commit-ID: f18568aae5612ab37f20e5f383d6154ea69c9dfc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Apr 2011 09:23:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f18568aae5612ab37f20e5f383d6154ea69c9dfc
Gitweb:     http://git.kernel.org/tip/f18568aae5612ab37f20e5f383d6154ea69c9dfc
Author:     Michael Witten <mfwitten@gmail.com>
AuthorDate: Tue, 12 Apr 2011 20:30:13 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Apr 2011 08:18:36 -0300

perf tools: git mv tools/perf/{features-tests.mak,config/}

Signed-off-by: Michael Witten <mfwitten@gmail.com>
Link: http://lkml.kernel.org/n/tip-a6zhefjayuounko1tk5sjji2@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                       |    2 +-
 tools/perf/{ => config}/feature-tests.mak |    0
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b5276c7..91ad5cc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -138,7 +138,7 @@ INSTALL = install
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
--include feature-tests.mak
+-include config/feature-tests.mak
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
 	CFLAGS := $(CFLAGS) -fstack-protector-all
diff --git a/tools/perf/feature-tests.mak b/tools/perf/config/feature-tests.mak
similarity index 100%
rename from tools/perf/feature-tests.mak
rename to tools/perf/config/feature-tests.mak
