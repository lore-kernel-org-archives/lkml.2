Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487Ab2EWOXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:23:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2439 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab2EWOXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:23:32 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=0qJ8DHEiPTkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=0azM3ZO7AAAA:8 a=68eEZQRoAAAA:8 a=ASB4Q_33QhIFIoUxRUEA:9 a=PUjeQqilurYA:10 a=BGWj8ct6lkoA:10 a=7YLhZ6jOsBkA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337783010.13348.157.camel@gandalf.stny.rr.com>
Subject: [GIT PULL] ktest: trivial spelling fixes
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>
Date: Wed, 23 May 2012 10:23:30 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

I promised Jesper that I would push this for 3.5, but forgot to add it
to my queue. It's just a spelling fix, but it should go in regardless to
hide my inability to get words in the English language correct.

Please pull the latest ktest-v3.5-spelling tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.5-spelling

Head SHA1: 96d240a2d276bcf6d46163deb7d40c89ac3124a6


Jesper Juhl (1):
      ktest: Change singular "paranthesis" to plural "parentheses"

----
 tools/testing/ktest/sample.conf |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---------------------------
commit 11c38b7575c2f4624d8e199c50cec2ba0d58a753
Author: Jesper Juhl <jj@chaosbits.net>
Date:   Mon Apr 16 19:40:24 2012 +0200

    ktest: Change singular "paranthesis" to plural "parentheses"
    
    Acked-by: Randy Dunlap <rdunlap@xenotime.net>
    Signed-off-by: Jesper Juhl <jj@chaosbits.net>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 0e8191b..cf362b3 100644
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


