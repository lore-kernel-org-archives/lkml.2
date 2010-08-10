Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab0HJGSC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 02:18:02 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45964 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab0HJGR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 02:17:57 -0400
Date: Tue, 10 Aug 2010 01:01:54 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs-devel@lists.launchpad.net
Subject: [GIT PULL] eCryptfs updates for 2.6.36
Message-ID: <20100810060153.GA7517@ecryptfs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

The following changes since commit f6cec0ae58c17522a7bc4e2f39dae19f199ab534:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2010-08-09 21:05:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

Julia Lawall (1):
      fs/ecryptfs/file.c: introduce missing free

Lino Sanfilippo (2):
      ecryptfs: release reference to lower mount if interpose fails
      ecryptfs: dont call lookup_one_len to avoid NULL nameidata

Prarit Bhargava (1):
      ecryptfs: Fix warning in ecryptfs_process_response()

Tyler Hicks (1):
      eCryptfs: Handle ioctl calls with unlocked and compat functions

 fs/ecryptfs/file.c      |   60 ++++++++++++++++++-----------
 fs/ecryptfs/inode.c     |   94 ++++++++++++++++++++++++++++++++++++++++-------
 fs/ecryptfs/messaging.c |    2 +-
 3 files changed, 118 insertions(+), 38 deletions(-)
