Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab0KVURH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 15:17:07 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58986 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab0KVURG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 15:17:06 -0500
Message-ID: <4CEACFBC.8050402@kernel.dk>
Date: Mon, 22 Nov 2010 21:17:00 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: manual merge of the xen tree with Linus' tree
References: <20101115112352.6cbf5604.sfr@canb.auug.org.au> <4CE1A07B.5010202@goop.org> <4CE1A124.3010108@kernel.dk> <4CEACF49.8040701@goop.org>
In-Reply-To: <4CEACF49.8040701@goop.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-22 21:15, Jeremy Fitzhardinge wrote:
> On 11/15/2010 01:07 PM, Jens Axboe wrote:
>> On 2010-11-15 22:04, Jeremy Fitzhardinge wrote:
>>> On 11/14/2010 04:23 PM, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> Today's linux-next merge of the xen tree got a conflict in
>>>> drivers/block/xen-blkfront.c between commit
>>>> 02e031cbc843b010e72fcc05c76113c688b2860f ("block: remove
>>>> REQ_HARDBARRIER") from Linus' tree and commits
>>>> c64e38ea17a81721da0393584fd807f8434050fa ("xen/blkfront: map REQ_FLUSH
>>>> into a full barrier") and be2f8373c188ed1f5d36003c9928e4d695213080
>>>> ("xen/blkfront: Implement FUA with BLKIF_OP_WRITE_BARRIER") from the xen
>>>> tree.
>>>>
>>>> I used the xen tree version.
>>> I'll drop that because you should be seeing those changes come via Jens.
>> Yep, since Linus pulled the last batch, for-linus now has the next bits
>> (which include the xen barrier set).
> 
> These don't seem to be in -rc3.  Did they get dropped on the ground
> somewhere?

No, they are in for-linus as written above. Just not shipped off yet,
will be soon.

-- 
Jens Axboe

