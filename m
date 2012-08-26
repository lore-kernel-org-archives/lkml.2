Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2HZL0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 07:26:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34410 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2HZL0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 07:26:42 -0400
MIME-Version: 1.0
In-Reply-To: <CALJbWerzuzaRwEenLRtMmkGdmze1Zdd5PM+uVv8SknUgxnpQQw@mail.gmail.com>
References: <CALJbWerzuzaRwEenLRtMmkGdmze1Zdd5PM+uVv8SknUgxnpQQw@mail.gmail.com>
Date: Sun, 26 Aug 2012 16:56:40 +0530
Message-ID: <CALJbWeoW-8UxgeZr3s_hW+FkNWGe5LjdySgYaSjQ8fk54NBcWA@mail.gmail.com>
Subject: Re: [GIT PULL] logfs: some important bug fixes
From: Prasad Joshi <prasadjoshi.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Could you please pull the following changes since commit
dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:
  git://github.com/prasad-joshi/logfs_upstream.git master

Prasad Joshi (5):
      logfs: destroy the reserved inodes while unmounting
      logfs: initialize the number of iovecs in bio
      logfs: create a pagecache page if it is not present
      logfs: maintain the ordering of meta-inode destruction
      logfs: query block device for number of pages to send with bio

 fs/logfs/dev_bdev.c  |   15 +++++++--------
 fs/logfs/inode.c     |   18 +++++++++++++++++-
 fs/logfs/journal.c   |    2 +-
 fs/logfs/readwrite.c |    1 -
 fs/logfs/segment.c   |    2 +-
 5 files changed, 26 insertions(+), 12 deletions(-)

Please note that the signed tag (for-linus) is applied and the same is
pushed. The repository is also added in the 'linux-next' and there no
conflicts in the 'linux-next: Tree for Aug 24'.

Thanks and Warm Regards,
Prasad
