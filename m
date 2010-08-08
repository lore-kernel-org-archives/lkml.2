Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab0HHTbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 15:31:55 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:2351 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab0HHTbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 15:31:51 -0400
Date: Sun, 8 Aug 2010 15:22:13 -0400
From: Bob Copeland <me@bobcopeland.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-karma-devel@lists.sourceforge.net
Subject: [GIT PULL] OMFS tree for 2.6.36
Message-ID: <20100808192213.GB11193@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling these fixes for the OMFS file system.  This is my
first pull request for this tree, so do let me know if anything is amiss.

The patches include some I wrote quite a while ago when fuzz testing, along
with recent fixes for a memory leak and a compiler warning.  My small test
suite passes with all applied.

The following changes since commit 815c4163b6c8ebf8152f42b0a5fd015cfdcedc78:

  Linux 2.6.35-rc4 (2010-07-04 20:22:50 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bcopeland/omfs.git for-linus

Bill Pemberton (1):
      omfs: fix uninitialized variable warning

Bob Copeland (3):
      omfs: check bounds on block numbers before passing to sb_bread
      omfs: refuse to mount if bitmap pointer is obviously wrong
      omfs: sanity check cluster size

Davidlohr Bueso (1):
      omfs: fix memory leak

 fs/omfs/dir.c     |   22 ++++++++--------------
 fs/omfs/file.c    |   10 +++++-----
 fs/omfs/inode.c   |   44 +++++++++++++++++++++++++++++++++-----------
 fs/omfs/omfs.h    |    1 +
 fs/omfs/omfs_fs.h |    1 +
 5 files changed, 48 insertions(+), 30 deletions(-)
-- 
Bob Copeland %% www.bobcopeland.com

