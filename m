Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab2BGTcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:32:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab2BGTcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:32:22 -0500
Date: Tue, 7 Feb 2012 11:32:13 -0800
From: tip-bot for John Kacur <jkacur@redhat.com>
Message-ID: <tip-946d863cc0d2262080c8101c8e6299974e449fe3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, jkacur@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jkacur@redhat.com, tglx@linutronix.de
In-Reply-To: <1328134591-19851-1-git-send-email-jkacur@redhat.com>
References: <1328134591-19851-1-git-send-email-jkacur@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove distclean from Makefile help output
Git-Commit-ID: 946d863cc0d2262080c8101c8e6299974e449fe3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 07 Feb 2012 11:32:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  946d863cc0d2262080c8101c8e6299974e449fe3
Gitweb:     http://git.kernel.org/tip/946d863cc0d2262080c8101c8e6299974e449fe3
Author:     John Kacur <jkacur@redhat.com>
AuthorDate: Wed, 1 Feb 2012 23:16:31 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 2 Feb 2012 17:37:51 -0200

perf tools: Remove distclean from Makefile help output

distclean as an alias for clean was removed from the perf Makefile by
commit a3d1ee10d1bf4520af3d44c1aa6cd46956ec4fd7

However, that commit neglected to remove it from the help output of
the perf Makefile, which could result in a user trying the following.

$ cd tools/perf/
$ make help | grep distclean
  distclean		- alias to clean
$ make distclean
make: *** No rule to make target `distclean'.  Stop.

This patch removes it from the Makefile help output.

Link: http://lkml.kernel.org/r/1328134591-19851-1-git-send-email-jkacur@redhat.com
Signed-off-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d64f581..64df5de 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -794,7 +794,6 @@ help:
 	@echo '  quick-install-html	- install the html documentation quickly'
 	@echo ''
 	@echo 'Perf maintainer targets:'
-	@echo '  distclean		- alias to clean'
 	@echo '  clean			- clean all binary objects and build output'
 
 doc:
