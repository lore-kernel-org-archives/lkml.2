Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2DPW2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:28:35 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22587 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab2DPW2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:28:33 -0400
Date: Tue, 17 Apr 2012 00:28:32 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] [Trivial] ktest: change singular "paranthesis" to plural
 "parantheses"
Message-ID: <alpine.LNX.2.00.1204170027250.21898@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 tools/testing/ktest/sample.conf |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index b682456..1a6e0d9 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -158,7 +158,7 @@
 #
 # TEST_START IF (DEFINED ALL_TESTS || ${MYTEST} == boottest) && ${MACHINE} == gandalf
 #
-# Notice the use of paranthesis. Without any paranthesis the above would be
+# Notice the use of parantheses. Without any parantheses the above would be
 # processed the same as:
 #
 # TEST_START IF DEFINED ALL_TESTS || (${MYTEST} == boottest && ${MACHINE} == gandalf)
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

