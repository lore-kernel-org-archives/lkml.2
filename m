Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab2HIQBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 12:01:31 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:42577 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758379Ab2HIQB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 12:01:28 -0400
X-ASG-Debug-ID: 1344528087-03d6a5408e234830001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Thu, 9 Aug 2012 12:01:26 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL 2/2] Btrfs merge fix
Message-ID: <20120809160126.GA32103@shiny>
X-ASG-Orig-Subj: [GIT PULL 2/2] Btrfs merge fix
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Linux Btrfs List <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1344528087
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.105152
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull my for-linus-3.6 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-3.6

It fixes a merging error in rc1.  The calls to mnt_want_write should
have been removed.

Alexander Block (1):
      Btrfs: remove mnt_want_write call in btrfs_mksubvol

 fs/btrfs/ioctl.c | 5 -----
 1 file changed, 5 deletions(-)
