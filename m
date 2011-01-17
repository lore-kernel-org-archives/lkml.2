Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab1AQTf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 14:35:59 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:49157 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1AQTf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 14:35:57 -0500
Date: Mon, 17 Jan 2011 13:35:50 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs-devel@lists.launchpad.net
Subject: [GIT PULL] eCryptfs fixes for 2.6.38-rc1
Message-ID: <20110117193549.GB31581@boyd.l.tihix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit e78bf5e6cbe837daa6ab628a5f679548742994d3:

  drivers/nfc/pn544.c: fix min_t warnings (2011-01-16 17:28:21 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

Edward Shishkin (1):
      ecryptfs: fix truncation error in ecryptfs_read_update_atime

Frank Swiderski (1):
      ecryptfs: remove unnecessary decrypt when extending a file

Joe Perches (1):
      fs/ecryptfs: Add printf format/argument verification and fix fallout

Roberto Sassu (4):
      ecryptfs: moved ECRYPTFS_SUPER_MAGIC definition to linux/magic.h
      ecryptfs: missing initialization of the superblock 'magic' field
      ecryptfs: test lower_file pointer when lower_file_mutex is locked
      ecryptfs: fixed testing of file descriptor flags

Tyler Hicks (1):
      ecryptfs: Fix ecryptfs_printk() size_t warnings

 fs/ecryptfs/crypto.c          |   30 ++++++++++++++----------------
 fs/ecryptfs/ecryptfs_kernel.h |    2 +-
 fs/ecryptfs/file.c            |   28 +++++++++++++---------------
 fs/ecryptfs/inode.c           |   32 ++++++++++++++------------------
 fs/ecryptfs/keystore.c        |   26 +++++++++++++-------------
 fs/ecryptfs/main.c            |    9 ++++++---
 fs/ecryptfs/mmap.c            |   35 +++++++++++++++++++++--------------
 include/linux/magic.h         |    1 +
 8 files changed, 83 insertions(+), 80 deletions(-)
