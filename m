Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0IJVk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 17:40:58 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38813 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753223Ab0IJVk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 17:40:57 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201009102140.o8ALeu1o011316@stout.americas.sgi.com>
Date: Fri, 10 Sep 2010 16:40:56 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update #2 for 2.6.36-rc4
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two more XFS changes for 2.6.36--one fixes a security problem
and the other addresses a regression due to the recent
workqueue updates.

					-Alex

The following changes since commit df423dc7f2a801b9a45d7c501a8eb5c529455ea1:

  Merge branch 'upstream-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev (2010-09-09 20:28:19 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dan Rosenberg (1):
      xfs: prevent reading uninitialized stack memory

Dave Chinner (1):
      xfs: log IO completion workqueue is a high priority queue

 fs/xfs/linux-2.6/xfs_buf.c   |    3 ++-
 fs/xfs/linux-2.6/xfs_ioctl.c |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)
