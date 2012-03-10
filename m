Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab2CJCB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 21:01:58 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37075 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2CJCB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 21:01:56 -0500
Date: Fri, 9 Mar 2012 21:01:50 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Message-ID: <20120310020150.GW29510@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F5AB612.0066,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have two additional and btrfs fixes in my for-linus branch

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

One is a casting error that leads to memory corruption on i386 during
scrub, and the other fixes a corner case in the backref walking code
(also triggered by scrub).

These are reviewed and tested.  I was holding off on this while trying
to track enospc bug reports, but it isn't yet clear if those are
regressions.  These are valid fixes either way.

Chris Mason (1) commits (+1/-1):
    Btrfs: fix casting error in scrub reada code

Li Zefan (1) commits (+6/-2):
    btrfs: fix locking issues in find_parent_nodes()

Total: (2) commits (+7/-3)
 fs/btrfs/backref.c |    8 ++++++--
 fs/btrfs/reada.c   |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)
