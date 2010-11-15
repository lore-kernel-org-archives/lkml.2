Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794Ab0KOVFC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:05:02 -0500
Received: from claw.goop.org ([74.207.240.146]:56390 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933694Ab0KOVFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:05:00 -0500
Message-ID: <4CE1A07B.5010202@goop.org>
Date: Mon, 15 Nov 2010 13:04:59 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: manual merge of the xen tree with Linus' tree
References: <20101115112352.6cbf5604.sfr@canb.auug.org.au>
In-Reply-To: <20101115112352.6cbf5604.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2010 04:23 PM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the xen tree got a conflict in
> drivers/block/xen-blkfront.c between commit
> 02e031cbc843b010e72fcc05c76113c688b2860f ("block: remove
> REQ_HARDBARRIER") from Linus' tree and commits
> c64e38ea17a81721da0393584fd807f8434050fa ("xen/blkfront: map REQ_FLUSH
> into a full barrier") and be2f8373c188ed1f5d36003c9928e4d695213080
> ("xen/blkfront: Implement FUA with BLKIF_OP_WRITE_BARRIER") from the xen
> tree.
>
> I used the xen tree version.

I'll drop that because you should be seeing those changes come via Jens.

    J
