Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab1ATONS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 09:13:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:34938 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561Ab1ATONP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 09:13:15 -0500
Date: Thu, 20 Jan 2011 15:13:13 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] Quota fix for 2.6.38-rc2
Message-ID: <20110120141313.GA20517@quack.suse.cz>
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

The full shortlog is:

Jan Kara (1):
      quota: Fix deadlock during path resolution

The diffstat is

 fs/ext3/super.c          |   25 +++++++------------------
 fs/ext4/super.c          |   25 +++++++------------------
 fs/ocfs2/super.c         |    5 ++---
 fs/quota/dquot.c         |   18 ++----------------
 fs/quota/quota.c         |   41 +++++++++++++++++++++++++++--------------
 fs/reiserfs/super.c      |   17 ++++++-----------
 include/linux/quota.h    |    5 ++++-
 include/linux/quotaops.h |    4 +---
 8 files changed, 56 insertions(+), 84 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
