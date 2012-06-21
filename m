Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab2FUPrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 11:47:33 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:51755 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab2FUPrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 11:47:31 -0400
X-ASG-Debug-ID: 1340293650-0421b53abf112b0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Thu, 21 Jun 2012 11:47:28 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: <torvalds@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Message-ID: <20120621154728.GF19507@shiny>
X-ASG-Orig-Subj: [GIT PULL] Btrfs updates
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	torvalds@linux-foundation.org,
	Kernel development list <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1340293650
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.100508
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please grab my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This is a small pull with btrfs fixes.  The biggest of the bunch is
another fix for the new backref walking code.

We're still hammering out one btrfs dio vs buffered reads problem, but
that one will have to wait for the next rc.

Josef Bacik (2) commits (+3/-2):
    Btrfs: delay iput with async extents (+2/-2)
    Btrfs: add a missing spin_lock (+1/-0)

Alexander Block (2) commits (+59/-44):
    Btrfs: don't assume to be on the correct extent in add_all_parents (+52/-42)
    Btrfs: introduce btrfs_next_old_item (+7/-2)

Total: (4) commits (+62/-46)

 fs/btrfs/backref.c |   94 +++++++++++++++++++++++++++++-----------------------
 fs/btrfs/ctree.h   |    9 +++--
 fs/btrfs/disk-io.c |    1 +
 fs/btrfs/inode.c   |    4 +--
 4 files changed, 62 insertions(+), 46 deletions(-)
