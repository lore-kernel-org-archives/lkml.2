Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab0D3Rbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:31:41 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39609 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758746Ab0D3Ra1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:30:27 -0400
Date: Thu, 29 Apr 2010 09:33:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anton Blanchard <anton@samba.org>,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
Message-ID: <20100429073354.GF27497@kernel.dk>
References: <20100429135204.eb79a986.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100429135204.eb79a986.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29 2010, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next merge of the block tree got a conflict in
> fs/block_dev.c between commit b8af67e2681c693a21f3933e3bdfce4cf66596d3
> ("fs/block_dev.c: fix performance regression in O_DIRECT|O_SYNC writes to
> block devices") from Linus' tree and commit
> fbd9b09a177a481eda256447c881f014f29034fe ("blkdev: generalize flags for
> blkdev_issue_fn functions") from the block tree.
> 
> I fixed it up (see below) and can carry the fix for a while.

I'll merge -linus in to resolve this one so you don't have to carry this
fix.

-- 
Jens Axboe

