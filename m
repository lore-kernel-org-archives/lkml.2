Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab1CQTz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:55:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab1CQTz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:55:56 -0400
Date: Thu, 17 Mar 2011 20:55:54 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: [PULL REQUEST] Ext3, jbd, and quota fixes for 2.6.39-rc1
Message-ID: <20110317195554.GA13136@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

The branch contains several ext3, jbd, and quota fixes.

The full shortlog is:

Amir Goldstein (1):
      ext3: skip orphan cleanup on rocompat fs

Davidlohr Bueso (1):
      quota: return -ENOMEM when memory allocation fails

Eric Sandeen (1):
      ext3: Always set dx_node's fake_dirent explicitly.

Justin P. Mattock (1):
      jbd: Remove one to many n's in a word.

Tao Ma (3):
      ext3: Adjust trim start with first_data_block.
      ext3: speed up group trim with the right free block count.
      ext3: Fix an overflow in ext3_trim_fs.

The diffstat is

 fs/ext3/balloc.c    |   21 ++++++++++++---------
 fs/ext3/namei.c     |    2 +-
 fs/ext3/super.c     |    7 +++++++
 fs/jbd/journal.c    |    2 +-
 fs/jbd2/journal.c   |    2 +-
 fs/quota/quota_v2.c |    2 +-
 6 files changed, 23 insertions(+), 13 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
