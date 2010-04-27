Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0D0Awp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 20:52:45 -0400
Received: from relay1.sgi.com ([192.48.179.29]:45266 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab0D0Awo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 20:52:44 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201004270052.o3R0qZB7014331@stout.americas.sgi.com>
Date: Mon, 26 Apr 2010 19:52:34 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.34-rc6
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to send this so late in the cycle.  It corrects a data
corruption error though and I hate to see it wait until 2.6.35.
If it doesn't make it for -rc6 perhaps you'll take it for -rc7.

					-Alex

The following changes since commit b91ce4d14a21fc04d165be30319541e0f9204f15:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      xfs: more swap extent fixes for dynamic fork offsets

 fs/xfs/xfs_dfrag.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)
