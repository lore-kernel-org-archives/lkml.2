Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab1BWP77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:59:59 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42168 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754456Ab1BWP76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:59:58 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102231559.p1NFxrcj011362@stout.americas.sgi.com>
Date: Wed, 23 Feb 2011 09:59:53 -0600
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.38-rc7
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following two minor changes for XFS.  One
fixes a security problem (kernel stack leak to user space) and the
other ensures an unsupported operation can be distinguished from a 
supported but not operative one.  Thanks.

					-Alex

The following changes since commit 4a508dd259f5995b8d31c576b894263f5947d654:

  Merge branch 'for-2639-rc4/i2c-fixes' of git://git.fluff.org/bjdooks/linux (2011-02-22 17:13:16 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dan Rosenberg (1):
      xfs: prevent leaking uninitialized stack memory in FSGEOMETRY_V1

Lukas Czerner (1):
      xfs: check if device support discard in xfs_ioc_trim()

 fs/xfs/linux-2.6/xfs_discard.c |    2 ++
 fs/xfs/xfs_fsops.c             |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)
