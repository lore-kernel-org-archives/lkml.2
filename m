Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914Ab0FRKSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:18:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:46888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758222Ab0FRKSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:18:11 -0400
Date: Fri, 18 Jun 2010 10:17:00 GMT
From: tip-bot for Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, kirr@landau.phys.spbu.ru, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       acme@redhat.com, kirr@landau.phys.spbu.ru, tglx@linutronix.de
In-Reply-To: <1276516847-25817-1-git-send-email-kirr@landau.phys.spbu.ru>
References: <1276516847-25817-1-git-send-email-kirr@landau.phys.spbu.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: .gitignore += config.make config.make.autogen
Message-ID: <tip-cfc21cc641dae17a4ebda29ed093134358449577@git.kernel.org>
Git-Commit-ID: cfc21cc641dae17a4ebda29ed093134358449577
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 10:17:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfc21cc641dae17a4ebda29ed093134358449577
Gitweb:     http://git.kernel.org/tip/cfc21cc641dae17a4ebda29ed093134358449577
Author:     Kirill Smelkov <kirr@landau.phys.spbu.ru>
AuthorDate: Mon, 14 Jun 2010 16:00:47 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Jun 2010 10:24:31 -0300

perf tools: .gitignore += config.make config.make.autogen

These are local-configuration files and should be ignored.

LKML-Reference: <1276516847-25817-1-git-send-email-kirr@landau.phys.spbu.ru>
Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/.gitignore |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index e1d60d7..cb43289 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -18,3 +18,5 @@ perf-archive
 tags
 TAGS
 cscope*
+config.mak
+config.mak.autogen
