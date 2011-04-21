Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1DUQJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 12:09:19 -0400
Received: from relay1.sgi.com ([192.48.179.29]:54039 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab1DUQJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:09:18 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201104211609.p3LG9D9n013300@stout.americas.sgi.com>
Date: Thu, 21 Apr 2011 11:09:13 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.39-rc5
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following commit for XFS.  It fixes a
regression that went in to 2.6.39-rc1.  It's a simple problem,
but its consequence (reusing a va_format pointer without
re-initializing it) is not good.  Thank you.

					-Alex


The following changes since commit 584f79046780e10cb24367a691f8c28398a00e84:

  Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging (2011-04-20 18:18:19 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (1):
      xfs: fix duplicate message output

 fs/xfs/linux-2.6/xfs_message.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)
