Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2IIJBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 05:01:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46551 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2IIJBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 05:01:21 -0400
Date: Sun, 9 Sep 2012 02:01:09 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-6c7f631261064762a8ba1ee34fc2b76d117ef3fa@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, penberg@kernel.org, dsahern@gmail.com,
        irina.tirdea@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, penberg@kernel.org, irina.tirdea@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1347116812-93646-4-git-send-email-dsahern@gmail.com>
References: <1347116812-93646-4-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Remove BIONIC wrapper around libgen.
 h
Git-Commit-ID: 6c7f631261064762a8ba1ee34fc2b76d117ef3fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 09 Sep 2012 02:01:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c7f631261064762a8ba1ee34fc2b76d117ef3fa
Gitweb:     http://git.kernel.org/tip/6c7f631261064762a8ba1ee34fc2b76d117ef3fa
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sat, 8 Sep 2012 09:06:52 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 8 Sep 2012 17:15:16 -0300

perf symbols: Remove BIONIC wrapper around libgen.h

Now that the 2 offenders are fixed, the BIONIC conditional around
libgen.h can be removed.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1347116812-93646-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index d3b330c..41a15da 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -10,9 +10,7 @@
 #include <linux/rbtree.h>
 #include <stdio.h>
 #include <byteswap.h>
-#if defined(__BIONIC__)
 #include <libgen.h>
-#endif
 
 #ifndef NO_LIBELF_SUPPORT
 #include <libelf.h>
