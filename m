Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1E0RwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:52:19 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35667 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1E0RwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:52:16 -0400
Date: Fri, 27 May 2011 12:51:54 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes
Message-ID: <20110527175154.GA3623@boyd.l.tihix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are 2 bug fixes and an update to MAINTAINERS for the new
eCryptfs mailing list.

The following changes since commit 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf:

  Linux 2.6.39 (2011-05-18 21:06:34 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git for-linus

Tyler Hicks (3):
      eCryptfs: Clear i_nlink in rmdir
      eCryptfs: Allow 2 scatterlist entries for encrypted filenames
      MAINTAINERS: Update eCryptfs mailing list

 MAINTAINERS            |    2 +-
 fs/ecryptfs/inode.c    |    2 ++
 fs/ecryptfs/keystore.c |   46 +++++++++++++++++++++-------------------------
 3 files changed, 24 insertions(+), 26 deletions(-)
