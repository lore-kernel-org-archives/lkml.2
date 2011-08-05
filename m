Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1HEEty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 00:49:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33313 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1HEEts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 00:49:48 -0400
Date: Fri, 5 Aug 2011 05:49:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: Josef Bacik <josef@redhat.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Subject: [PATCH] Restore 'fsync' functionality on block devices.
Message-ID: <20110805044945.GR2203@ZenIV.linux.org.uk>
References: <20110805133456.5aa0c568@notabene.brown>
 <20110805034859.GQ2203@ZenIV.linux.org.uk>
 <20110805143509.33769ce3@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805143509.33769ce3@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 02:35:09PM +1000, NeilBrown wrote:

> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=da5aa861bea09197e6ae4d7c46618616064891e4
> 
> gives me 
>   
> 404 - Unknown commit object 
> 
> (as does a 'git show').
> 
> But I'll take your word for it that it is on it's way.

Charming... the diff between what's on hera and what's on git.kernel.org
is not small -
 arch/arm/kernel/process.c |    2 +-
 arch/ia64/kernel/efi.c    |    2 +-
 arch/sh/kernel/idle.c     |    2 +-
 drivers/dma/dmaengine.c   |    4 +-
 drivers/dma/ioat/dma_v3.c |    8 ++--
 drivers/dma/ioat/pci.c    |   11 +++++
 fs/block_dev.c            |    4 ++
 fs/namei.c                |   17 +++-----
 include/linux/pci_ids.h   |   10 +++++
 include/linux/posix_acl.h |   74 +++++++++++++-----------------------
 kernel/futex.c            |   54 ++++++++++++++++++++------
 kernel/lockdep.c          |   37 +++++++++---------
 mm/slab.c                 |   92 ++++++++++++++++++++++++++++++++++----------
 13 files changed, 196 insertions(+), 121 deletions(-)

and the latest is actually commit 24f0eed2668b059e847ff145848ddacb75419acc
Merge: 8b6b462 3567866
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Aug 4 16:44:40 2011 -1000

(with several more merges between git.kernel.org tip and this one)
