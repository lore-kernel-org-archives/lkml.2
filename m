Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924Ab2JWUc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:32:27 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51455 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964785Ab2JWUFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:38 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Beulich <JBeulich@novell.com>, Mel Gorman <mel@csn.ul.ie>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: [PATCH 158/193] mm: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:03:51 -0700
Message-Id: <1351022666-6960-159-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Jan Beulich <JBeulich@novell.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 mm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index a3f8ddd..679945e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1,6 +1,5 @@
 config SELECT_MEMORY_MODEL
 	def_bool y
-	depends on EXPERIMENTAL || ARCH_SELECT_MEMORY_MODEL
 
 choice
 	prompt "Memory model"
-- 
1.7.9.5

