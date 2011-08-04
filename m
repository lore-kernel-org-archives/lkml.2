Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab1HDA5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 20:57:47 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:55513 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab1HDA5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 20:57:42 -0400
Date: Wed, 03 Aug 2011 20:57:40 -0400
Message-Id: <E1QomFo-0004xQ-1C@tytso-glaptop>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 bugfix before 3.1-rc1
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This was an oopsie that I'd like to fix up before rc1 if possible.  Mea
culpa.

   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Please pull, thanks!!

					- Ted

Mathias Krause (1):
      ext4: use kzalloc in ext4_kzalloc()

 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
