Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab1CCPfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 10:35:11 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54349 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758349Ab1CCPfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 10:35:09 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103031535.p23FZ1hI023122@stout.americas.sgi.com>
Date: Thu, 03 Mar 2011 09:35:00 -0600
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.38-rc8
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Regressions fixed, hopefully none introduced..

Sorry to report that one was introduced in XFS.  A caller was
providing the address of something smaller than what was expected
by a function that zeroed it, with a predictable result.

Please take the following change, which corrects the problem.
Thanks.

					-Alex

The following changes since commit cbdbb4c1d22e26f9d5314fefe6f2c7e5ed7f6a0f:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-03-02 20:02:32 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      xfs: zero proper structure size for geometry calls

 fs/xfs/linux-2.6/xfs_ioctl.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)
