Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab2BWWom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:44:42 -0500
Received: from relay2.sgi.com ([192.48.179.30]:41130 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756000Ab2BWWol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:44:41 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.3
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Message-Id: <20120223224444.5F139426DA7@whiskey.americas.sgi.com>
Date: Thu, 23 Feb 2012 16:44:44 -0600 (CST)
From: bpm@sgi.com (Ben Myers)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

   Please pull the following three bugfixes for xfs in 3.3:

   A fix from Jesper Juhl removes an assignment in an ASSERT when a compare is
   intended.  Two fixes from Mitsuo Hayasaka address off-by-ones in XFS quota
   enforcement.

Thanks,
   Ben

The following changes since commit 45196cee28a5bcfb6ddbe2bffa4270cbed66ae4b:
  Linus Torvalds (1):
        Merge tag 'usb-3.3-rc4' of git://git.kernel.org/.../gregkh/usb

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Jesper Juhl (1):
      XFS: xfs_trans_add_item() - don't assign in ASSERT() when compare is intended

Mitsuo Hayasaka (2):
      xfs: change available ranges of softlimit and hardlimit in quota check
      xfs: make inode quota check more general

 fs/xfs/xfs_dquot.c       |   24 ++++++++++++------------
 fs/xfs/xfs_log_recover.c |    6 +++---
 fs/xfs/xfs_qm_syscalls.c |    4 ++--
 fs/xfs/xfs_trans.c       |    4 ++--
 fs/xfs/xfs_trans_dquot.c |   10 ++++++----
 5 files changed, 25 insertions(+), 23 deletions(-)
