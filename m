Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab1BVAAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 19:00:33 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37043 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab1BVAAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 19:00:32 -0500
Date: Mon, 21 Feb 2011 18:00:10 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs-devel@lists.launchpad.net
Subject: [GIT PULL] eCryptfs fixes for 2.6.38-rc6
Message-ID: <20110222000009.GD2846@boyd.l.tihix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 85e2efbb1db9a18d218006706d6e4fbeb0216213:

  Linux 2.6.38-rc5 (2011-02-15 19:23:45 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

Andy Whitcroft (1):
      ecryptfs: read on a directory should return EISDIR if not supported

Tyler Hicks (3):
      eCryptfs: Revert "dont call lookup_one_len to avoid NULL nameidata"
      eCryptfs: Handle NULL nameidata pointers
      eCryptfs: Copy up lower inode attrs in getattr

 fs/ecryptfs/dentry.c          |   22 ++++---
 fs/ecryptfs/ecryptfs_kernel.h |    3 +-
 fs/ecryptfs/file.c            |    1 +
 fs/ecryptfs/inode.c           |  138 +++++++++--------------------------------
 4 files changed, 44 insertions(+), 120 deletions(-)
