Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2DRDup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 23:50:45 -0400
Received: from tundra.namei.org ([65.99.196.166]:37612 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab2DRDuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 23:50:44 -0400
Date: Wed, 18 Apr 2012 13:50:43 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem fixes for 3.4
Message-ID: <alpine.LRH.2.02.1204181349550.24162@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull.

The following changes since commit 592fe8980688e7cba46897685d014c7fb3018a67:
  Linus Torvalds (1):
        Merge tag 'ext4_for_linus' of git://git.kernel.org/.../tytso/ext4

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Casey Schaufler (1):
      Smack: move label list initialization

Eric Paris (1):
      fcaps: clear the same personality flags as suid when fcaps are used

Jesper Juhl (1):
      mpi: Avoid using freed pointer in mpi_lshift_limbs()

 lib/mpi/mpi-bit.c          |    5 +++--
 security/commoncap.c       |    5 +++++
 security/smack/smack_lsm.c |   44 +++++++++++++++++++++++++++++++++-----------
 security/smack/smackfs.c   |   14 --------------
 4 files changed, 41 insertions(+), 27 deletions(-)
