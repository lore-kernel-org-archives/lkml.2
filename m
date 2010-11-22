Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab0KVUPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 15:15:12 -0500
Received: from claw.goop.org ([74.207.240.146]:44258 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab0KVUPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 15:15:07 -0500
Message-ID: <4CEACF49.8040701@goop.org>
Date: Mon, 22 Nov 2010 12:15:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: manual merge of the xen tree with Linus' tree
References: <20101115112352.6cbf5604.sfr@canb.auug.org.au> <4CE1A07B.5010202@goop.org> <4CE1A124.3010108@kernel.dk>
In-Reply-To: <4CE1A124.3010108@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 01:07 PM, Jens Axboe wrote:
> On 2010-11-15 22:04, Jeremy Fitzhardinge wrote:
>> On 11/14/2010 04:23 PM, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Today's linux-next merge of the xen tree got a conflict in
>>> drivers/block/xen-blkfront.c between commit
>>> 02e031cbc843b010e72fcc05c76113c688b2860f ("block: remove
>>> REQ_HARDBARRIER") from Linus' tree and commits
>>> c64e38ea17a81721da0393584fd807f8434050fa ("xen/blkfront: map REQ_FLUSH
>>> into a full barrier") and be2f8373c188ed1f5d36003c9928e4d695213080
>>> ("xen/blkfront: Implement FUA with BLKIF_OP_WRITE_BARRIER") from the xen
>>> tree.
>>>
>>> I used the xen tree version.
>> I'll drop that because you should be seeing those changes come via Jens.
> Yep, since Linus pulled the last batch, for-linus now has the next bits
> (which include the xen barrier set).

These don't seem to be in -rc3.  Did they get dropped on the ground
somewhere?

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/blkfront

Jeremy Fitzhardinge (4):
      xen/blkfront: map REQ_FLUSH into a full barrier
      xen/blkfront: change blk_shadow.request to proper pointer
      xen/blkfront: Implement FUA with BLKIF_OP_WRITE_BARRIER
      xen/blkfront: cope with backend that fail empty BLKIF_OP_WRITE_BARRIER requests

 drivers/block/xen-blkfront.c |   55 ++++++++++++++++++++++++-----------------
 1 files changed, 32 insertions(+), 23 deletions(-)

Thanks,
	J


