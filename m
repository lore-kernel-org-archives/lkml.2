Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab2IHPHa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 11:07:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57083 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab2IHPHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 11:07:10 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: irina.tirdea@gmail.com, David Ahern <dsahern@gmail.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 3/3] perf tool: remove BIONIC wrapper around libgen.h
Date: Sat,  8 Sep 2012 09:06:52 -0600
Message-Id: <1347116812-93646-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1347116812-93646-1-git-send-email-dsahern@gmail.com>
References: <1347116812-93646-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the 2 offenders are fixed, the BIONIC conditional around
libgen.h can be removed.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
---
 tools/perf/util/symbol.h |    2 --
 1 file changed, 2 deletions(-)

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
-- 
1.7.10.1

