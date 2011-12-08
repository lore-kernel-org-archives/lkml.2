Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1LHTYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 14:24:47 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:64391 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1LHTYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 14:24:45 -0500
Date: Thu, 8 Dec 2011 14:24:35 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20111208192435.GR8971@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4EE10EFC.003E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

The for-linus branch of the btrfs repository:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Has a few more fixes.  The most notable here are two more patches from
Alexandre's batch of allocator fixes.  The other two fix corner cases in
the state code and in the code to add devices.

Alexandre Oliva (2) commits (+49/-51):
    Btrfs: try to allocate from cluster even at LOOP_NO_EMPTY_SIZE (+18/-8)
    Btrfs: try cluster but don't advance in search list (+31/-43)

Liu Bo (1) commits (+16/-8):
    Btrfs: drop spin lock when memory alloc fails

Li Zefan (1) commits (+1/-1):
    Btrfs: check if the to-be-added device is writable

Total: (4) commits (+66/-60)

 fs/btrfs/extent-tree.c |  100 +++++++++++++++++++++++------------------------
 fs/btrfs/extent_io.c   |   24 ++++++++----
 fs/btrfs/volumes.c     |    2 +-
 3 files changed, 66 insertions(+), 60 deletions(-)
