Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488Ab1LPS1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:27:42 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:21801 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab1LPS1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:27:34 -0500
Date: Fri, 16 Dec 2011 13:27:28 -0500
From: Chris Mason <chris.mason@oracle.com>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Btrfs fixes (part two, against 3.2-rc)
Message-ID: <20111216182728.GB25457@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4EEB8D94.00A7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I try to keep most of the btrfs commits against the last release.  This
way, people can update their old and crusty kernels from 3 months ago,
and still have the latest btrfs code.

We do have one commit that is 3.2 specific though, so I put it into a
for-linus-3.2 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-3.2

Wu Fengguang noticed that btrfs' file write needs to consider the balance
dirty thresholds when it allows big multi-page writes.

Wu Fengguang (1) commits (+2/-0):
    btrfs: lower the dirty balance poll interval

Total: (1) commits (+2/-0)

 fs/btrfs/file.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

