Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab0DSUU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 16:20:56 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60521 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab0DSUUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 16:20:54 -0400
Date: Mon, 19 Apr 2010 15:20:43 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.launchpad.net
Subject: [GIT PULL] eCryptfs fixes for 2.6.34
Message-ID: <20100419202043.GB2648@fedora-virt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 220bf991b0366cc50a94feede3d7341fa5710ee4:
  Linus Torvalds (1):
        Linux 2.6.34-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

Christian Pulvermacher (1):
      ecryptfs: fix error code for missing xattrs in lower fs

Jeff Mahoney (1):
      ecryptfs: fix use with tmpfs by removing d_drop from ecryptfs_destroy_inode

Tyler Hicks (7):
      eCryptfs: Fix metadata in xattr feature regression
      eCryptfs: Rename ecryptfs_crypt_stat.num_header_bytes_at_front
      eCryptfs: Clear buffer before reading in metadata xattr
      eCryptfs: Strip metadata in xattr flag in encrypted view
      eCryptfs: Decrypt symlink target for stat size
      eCryptfs: Copy lower directory inode times and size on link
      eCryptfs: Turn lower lookup error messages into debug messages

 fs/ecryptfs/crypto.c          |   37 ++++++------
 fs/ecryptfs/ecryptfs_kernel.h |   13 ++++-
 fs/ecryptfs/inode.c           |  129 +++++++++++++++++++++--------------------
 fs/ecryptfs/mmap.c            |   38 +++++++------
 fs/ecryptfs/super.c           |    1 -
 5 files changed, 118 insertions(+), 100 deletions(-)
