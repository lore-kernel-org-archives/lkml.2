Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab1INUCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:02:16 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42284 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932611Ab1INUCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:02:15 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201109142002.p8EK29TA027782@stout.americas.sgi.com>
Date: Wed, 14 Sep 2011 15:02:09 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 3.1-rc7
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following XFS fix in for 3.1-rc7.  It
addresses a use-after-free problem that is due to code that
went in to 3.1-rc1 (commit 72c5052d).

The repository is the same as has always been used for XFS at
oss.sgi.com.

Thanks.

					-Alex

The following changes since commit 003f6c9df54970d8b19578d195b3e2b398cdbde2:

  lib/sha1.c: quiet sparse noise about symbol not declared (2011-09-13 16:09:41 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (1):
      xfs: fix a use after free in xfs_end_io_direct_write

 fs/xfs/xfs_aops.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
