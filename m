Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0H0Trr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:47:47 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60679 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab0H0Trp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:47:45 -0400
Date: Fri, 27 Aug 2010 14:31:24 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs-devel@lists.launchpad.net
Subject: [GIT PULL] eCryptfs fixes for 2.6.36-rc3
Message-ID: <20100827193117.GA1149@ecryptfs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 76be97c1fc945db08aae1f1b746012662d643e97:

  Linux 2.6.36-rc2 (2010-08-22 17:43:29 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

Jerome Marchand (1):
      ecryptfs: properly mark init functions

Julia Lawall (1):
      fs/ecryptfs: Return -ENOMEM on memory allocation failure

Tyler Hicks (1):
      eCryptfs: Fix encrypted file name lookup regression

 fs/ecryptfs/crypto.c    |    3 +--
 fs/ecryptfs/inode.c     |   31 ++++++++++++++++++++++++-------
 fs/ecryptfs/keystore.c  |    2 ++
 fs/ecryptfs/kthread.c   |    2 +-
 fs/ecryptfs/messaging.c |    2 +-
 fs/ecryptfs/miscdev.c   |    2 +-
 6 files changed, 30 insertions(+), 12 deletions(-)
