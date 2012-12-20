Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab2LTUWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 15:22:06 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:57163 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab2LTUWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 15:22:00 -0500
X-ASG-Debug-ID: 1356034919-0421b549ebac9c0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Thu, 20 Dec 2012 15:21:58 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Two btrfs reverts
Message-ID: <20121220202158.GE15740@shiny>
X-ASG-Orig-Subj: [GIT PULL] Two btrfs reverts
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1356034919
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.117583
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I had missed that for two of the patches in my last pull, we had
included different fixes during 3.7.  My for-linus has them reverted:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Chris Mason (2) commits (+6/-8):
    Revert "Btrfs: MOD_LOG_KEY_REMOVE_WHILE_MOVING never change node's nritems" (+2/-2)
    Revert "Btrfs: reorder tree mod log operations in deleting a pointer" (+4/-6)

Total: (2) commits (+6/-8)

 fs/btrfs/ctree.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)
