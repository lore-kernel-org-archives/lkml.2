Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab0CPXd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 19:33:27 -0400
Received: from relay1.sgi.com ([192.48.179.29]:35574 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab0CPXd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 19:33:26 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201003162333.o2GNXIvb022464@stout.americas.sgi.com>
Date: Tue, 16 Mar 2010 18:33:17 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.34-rc1
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hope you'll accept the following for 2.6.34-rc3, if not -rc2.

The first two are patches I neglected to include in my first batch
for 2.6.34.  The second is minor, but gets rid of some bogus warning
messages in the event of a forced shutdown.

					-Alex

The following changes since commit 57d54889cd00db2752994b389ba714138652e60c:
  Linus Torvalds (1):
        Linux 2.6.34-rc1

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (2):
      xfs: remove old vmap cache
      xfs: use scalable vmap API

Dave Chinner (1):
      xfs: don't warn about page discards on shutdown

 fs/xfs/linux-2.6/xfs_aops.c |   13 +++++--
 fs/xfs/linux-2.6/xfs_buf.c  |   81 ++----------------------------------------
 2 files changed, 14 insertions(+), 80 deletions(-)
