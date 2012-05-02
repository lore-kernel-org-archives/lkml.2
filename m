Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab2EBAyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 20:54:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8272 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab2EBAyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 20:54:17 -0400
X-Authority-Analysis: v=2.0 cv=T/EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=sHHRogNuewcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=FyswP2SAAAAA:20 a=VwQbUJbxAAAA:8 a=L2hyhxPZbOcU9QLCoksA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120502004439.965120020@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 01 May 2012 20:44:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] ktest: A couple of fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

This includes two fixes, one of which seems to have fell under your
radar before:

 http://groups.google.com/group/linux.kernel/browse_thread/thread/b0a0880f3e0f415a/188f12ab40b7a6c9?show_docid=188f12ab40b7a6c9

But that's fine, as I pulled in Russ's patch after merging your tree,
and it did not do a fast forward of your tree. I didn't notices that
it did that, and it seemed a bit strange to do a commit for a fast
forward.

Is git set up to not fast forward by default? (I need to give it another try)

Anyway, changed my tree to be a fast forward (you haven't pulled it
yet, so no harm done with a rebase), and I added another fix.

New signed tag.

Please pull the latest ktest-for-v3.4-rc5 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-for-v3.4-rc5

Head SHA1: b66786c7ff4441f0b9ac3b05f8e62cad75df65ff


Russ Dill (1):
      ktest.pl: Fix combined usage of BISECT_REVERSE and BISECT_SKIP

Steven Rostedt (1):
      ktest: Fix reboot on success stopping all reboots

----
 tools/testing/ktest/ktest.pl |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)
