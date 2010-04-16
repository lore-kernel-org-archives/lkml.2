Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab0DPVbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 17:31:48 -0400
Received: from relay2.sgi.com ([192.48.179.30]:42550 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932417Ab0DPVbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 17:31:47 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201004162131.o3GLVgZQ026576@stout.americas.sgi.com>
Date: Fri, 16 Apr 2010 16:31:42 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.34-rc5
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull these two changes for 2.6.34-rc5.	-Alex

The following changes since commit dc57da3875f527b1cc195ea4ce5bd32e1e68433d:
  Linus Torvalds (1):
        Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (2):
      xfs: ensure that sync updates the log tail correctly
      xfs: don't warn on EAGAIN in inode reclaim

 fs/xfs/linux-2.6/xfs_sync.c |    4 ++--
 fs/xfs/xfs_log.c            |   38 ++++++++++++++++++++++++++------------
 2 files changed, 28 insertions(+), 14 deletions(-)
