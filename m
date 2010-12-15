Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab0LOQcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:32:45 -0500
Received: from THUNK.ORG ([69.25.196.29]:60967 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab0LOQco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:32:44 -0500
Date: Wed, 15 Dec 2010 11:32:42 -0500
Message-Id: <E1PSuHS-00071A-1U@tytso-glaptop>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 update for 2.6.37-rc6
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

To get some regression fixes for ext4.  They're both hard to hit, and
unfortunately I'm going to have to back out the multi-page submission
feature for 2.6.37 (disabled by default; can be re-enable with a mount
option) until I can figure what's going on with an edge case which Jon
Nelson reported.

						- Ted

Aaro Koskinen (1):
      ext4: fix typo which broke '..' detection in ext4_find_entry()

Theodore Ts'o (1):
      ext4: Turn off multiple page-io submission by default

 fs/ext4/ext4.h  |    1 +
 fs/ext4/inode.c |    5 ++++-
 fs/ext4/namei.c |    2 +-
 fs/ext4/super.c |   14 ++++++++++++--
 4 files changed, 18 insertions(+), 4 deletions(-)
