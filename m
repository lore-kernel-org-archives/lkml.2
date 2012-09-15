Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab2IOLh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 07:37:26 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:34786 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab2IOLhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 07:37:24 -0400
X-ASG-Debug-ID: 1347709043-0421b5402cc12c0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Sat, 15 Sep 2012 07:37:21 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] a btrfs fix
Message-ID: <20120915113721.GI4143@shiny>
X-ASG-Orig-Subj: [GIT PULL] a btrfs fix
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1347709043
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.108606
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

My for-linus branch has one revert in the new quota code:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

We're building up more fixes at etc for the next merge window, but I'm
keeping them out unless they are bigger regressions or have a huge
impact.

Chris Mason (1):
      Revert "Btrfs: fix some error codes in btrfs_qgroup_inherit()"

 fs/btrfs/qgroup.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)
