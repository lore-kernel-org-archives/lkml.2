Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab2BALI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 06:08:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55869 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2BALI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 06:08:26 -0500
From: Franck Bui-Huu <fbuihuu@gmail.com>
To: linux@dominikbrodowski.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] cpupower tool: remove use of undefined variables from the clean target of the top makefile
Date: Wed,  1 Feb 2012 12:08:18 +0100
Message-Id: <1328094500-19393-2-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1328094500-19393-1-git-send-email-fbuihuu@gmail.com>
References: <1328094500-19393-1-git-send-email-fbuihuu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UTIL_BINS and IDLE_OBJS variables are not defined at all, so
there's no need to remove their content from the 'clean' target.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/power/cpupower/Makefile |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/tools/power/cpupower/Makefile b/tools/power/cpupower/Makefile
index e8a03ac..b7d87af 100644
--- a/tools/power/cpupower/Makefile
+++ b/tools/power/cpupower/Makefile
@@ -228,8 +228,6 @@ compile-bench: libcpupower.so.$(LIB_MAJ)
 clean:
 	-find . \( -not -type d \) -and \( -name '*~' -o -name '*.[oas]' \) -type f -print \
 	 | xargs rm -f
-	-rm -f $(UTIL_BINS)
-	-rm -f $(IDLE_OBJS)
 	-rm -f cpupower
 	-rm -f libcpupower.so*
 	-rm -rf po/*.gmo po/*.pot
-- 
1.7.7.4

