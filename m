Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2DPXM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:12:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23479 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2DPXMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:12:55 -0400
Date: Tue, 17 Apr 2012 01:12:54 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Randy Dunlap <rdunlap@xenotime.net>
cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] [Trivial] ktest: change singular "paranthesis" to plural
 "parantheses"
In-Reply-To: <4F8CCFFF.2060808@xenotime.net>
Message-ID: <alpine.LNX.2.00.1204170110460.21898@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204170027250.21898@swampdragon.chaosbits.net> <4F8CCFFF.2060808@xenotime.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012, Randy Dunlap wrote:

> On 04/16/2012 03:28 PM, Jesper Juhl wrote:
> 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  tools/testing/ktest/sample.conf |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> It's misspelled before and after the patch.  :(
> 
Ahh, crap, you are right. Sorry about that :-(

I could try to blame that on english not being my first language, but I 
won't since it's just me screwing up.
I did read the patch several times before sending it and thought I'd made 
sure there were no trivial errors like that, but I was wrong - damn it.


This should be better :

From: Jesper Juhl <jj@chaosbits.net>
Date: Mon, 16 Apr 2012 19:40:24 +0200
Subject: [PATCH] [Trivial] ktest: change singular "paranthesis" to plural "parentheses"


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 tools/testing/ktest/sample.conf |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index b682456..2d5109f 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -158,7 +158,7 @@
 #
 # TEST_START IF (DEFINED ALL_TESTS || ${MYTEST} == boottest) && ${MACHINE} == gandalf
 #
-# Notice the use of paranthesis. Without any paranthesis the above would be
+# Notice the use of parentheses. Without any parentheses the above would be
 # processed the same as:
 #
 # TEST_START IF DEFINED ALL_TESTS || (${MYTEST} == boottest && ${MACHINE} == gandalf)
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

