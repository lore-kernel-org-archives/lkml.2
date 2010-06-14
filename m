Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab0FNMAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:00:04 -0400
Received: from landau.phys.spbu.ru ([195.19.235.38]:37610 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0FNMAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:00:03 -0400
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Kirill Smelkov <kirr@landau.phys.spbu.ru>
Subject: [PATCH] perf tools: .gitignore += config.make config.make.autogen
Date: Mon, 14 Jun 2010 16:00:47 +0400
Message-Id: <1276516847-25817-1-git-send-email-kirr@landau.phys.spbu.ru>
X-Mailer: git-send-email 1.7.1.334.gebb7bc.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This are local-configuration files and should be ignore.

Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
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
1.7.1.334.gebb7bc.dirty
