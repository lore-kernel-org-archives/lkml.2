Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab0LJRzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 12:55:40 -0500
Received: from relay2.sgi.com ([192.48.179.30]:37488 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756383Ab0LJRzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 12:55:38 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201012101755.oBAHtYP6017575@stout.americas.sgi.com>
Date: Fri, 10 Dec 2010 11:55:34 -0600
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.37-rc6
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following change in for XFS.  It fixes
a regression that went into 2.6.37-rc1.  Thanks.

					-Alex

The following changes since commit 6313e3c21743cc88bb5bd8aa72948ee1e83937b6:

  Merge branches 'x86-fixes-for-linus', 'perf-fixes-for-linus' and...

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (1):
      xfs: log timestamp changes to the source inode in rename

 fs/xfs/xfs_rename.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
