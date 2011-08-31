Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab1HaRqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 13:46:48 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59848 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab1HaRqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 13:46:47 -0400
Date: Wed, 31 Aug 2011 13:46:43 -0400
Message-Id: <E1Qyos7-0001in-99@tytso-glaptop.cam.corp.google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 fixes for 3.1-rc5
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://github.com/tytso/ext4.git for_linus-20110831 # 8c0bec2151a

to get the following bug fix.  It address a lockdep warning which a lot
of people have been complaining about.

Thanks,

						- Ted


Jiaying Zhang (1):
      ext4: remove i_mutex lock in ext4_evict_inode to fix lockdep complaining

 fs/ext4/ext4.h    |    1 +
 fs/ext4/inode.c   |    3 ---
 fs/ext4/page-io.c |   18 +++++++++++++++++-
 3 files changed, 18 insertions(+), 4 deletions(-)
