Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760Ab0J2TpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:45:07 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:35769 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab0J2TpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:45:05 -0400
Date: Fri, 29 Oct 2010 14:44:50 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs-devel@lists.launchpad.net
Subject: [GIT PULL] eCryptfs updates
Message-ID: <20101029194449.GA13441@boyd.l.tihix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit f6f94e2ab1b33f0082ac22d71f66385a60d8157f:

  Linux 2.6.36 (2010-10-20 13:30:22 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

Roberto Sassu (4):
      ecryptfs: call vfs_setxattr() in ecryptfs_setxattr()
      ecryptfs: release keys loaded in ecryptfs_keyring_auth_tok_for_sig()
      ecryptfs: checking return code of ecryptfs_find_auth_tok_for_sig()
      ecryptfs: added ecryptfs_mount_auth_tok_only mount parameter

Tyler Hicks (2):
      eCryptfs: Clear LOOKUP_OPEN flag when creating lower file
      eCryptfs: Print mount_auth_tok_only param in ecryptfs_show_options

 fs/ecryptfs/ecryptfs_kernel.h |    1 +
 fs/ecryptfs/inode.c           |   11 ++++++---
 fs/ecryptfs/keystore.c        |   45 ++++++++++++++++++++++++++++++++++------
 fs/ecryptfs/main.c            |    8 ++++++-
 fs/ecryptfs/super.c           |    2 +
 5 files changed, 55 insertions(+), 12 deletions(-)
