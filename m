Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425Ab0FQUlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:41:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:49942 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351Ab0FQUkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:40:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@landau.phys.spbu.ru>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/7] perf tools: .gitignore += config.make config.make.autogen
Date: Thu, 17 Jun 2010 17:40:01 -0300
Message-Id: <1276807204-22512-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1276807204-22512-1-git-send-email-acme@infradead.org>
References: <1276807204-22512-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Smelkov <kirr@landau.phys.spbu.ru>

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
-- 
1.6.2.5

