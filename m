Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab0FBGTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 02:19:10 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:41063 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab0FBGTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 02:19:08 -0400
Date: Wed, 2 Jun 2010 08:19:07 +0200
From: Jens Axboe <jaxboe@fusionio.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: linux-next: manual merge of the drbd tree with the block tree
Message-ID: <20100602061907.GI3564@kernel.dk>
References: <20100602140322.7e374a2e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602140322.7e374a2e.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02 2010, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the drbd tree got a conflict in
> fs/fs-writeback.c between commit f17625b318d9b151e7bd41e31223e9d89b2aaa77
> ("Revert "writeback: ensure that WB_SYNC_NONE writeback with sb pinned is
> sync"") from the block tree and commits
> 5c92877730b509fefc445bbba6b3bc441c2c272a ("writeback: fix early free of
> work struct") and dff38fd3d1d0914ac0715445bbe21fbce9abed15 ("writeback:
> fix non-integrity write-back") from the drbd tree.
> 
> I suspect this is caused because the drbd tree id based on a different
> version of the block tree to what is in the block tree for-next branch.
> I just used the version of this file from the block tree.

Yeah, I had to yank a few patches since they didn't quite work out in
Christophs testing. The for-next version in the block tree has it all,
so that approach works.

-- 
Jens Axboe

