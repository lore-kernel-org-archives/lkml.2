Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab0HMVJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:09:48 -0400
Received: from thunk.org ([69.25.196.29]:54749 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab0HMVJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:09:47 -0400
Date: Fri, 13 Aug 2010 17:09:42 -0400
Message-Id: <E1Ok1VW-0003Hx-QA@tytso-glaptop>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 update for 2.6.36
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

No other late-breaking bug reports/regressions have turned up, and since
I want to get this fixed before -rc1 gets released, please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

I fixed the compile warning basically as you suggested, but with a
better name and with the comments moved to the inline function where
they would make more sense.

Thanks,

						- Ted

Theodore Ts'o (1):
      ext4: clean up compiler warning in start_this_handle()

 fs/jbd2/transaction.c |   46 +++++++++++++++++++++++++++-------------------
 1 files changed, 27 insertions(+), 19 deletions(-)
