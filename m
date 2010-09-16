Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0IPG02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:26:28 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40463 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab0IPG01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:26:27 -0400
Message-ID: <4C91B895.8090808@kernel.dk>
Date: Thu, 16 Sep 2010 08:26:29 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: manual merge of the block tree with the Linus' tree
References: <20100916120440.f3fdcbda.sfr@canb.auug.org.au>
In-Reply-To: <20100916120440.f3fdcbda.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-16 04:04, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next merge of the block tree got a conflict in
> drivers/block/loop.c between commit
> 5e00d1b5b4c10fb839afd5ce61db8e24339454b0 ("BLOCK: fix bio.bi_rw
> handling") from Linus' tree and commit
> 6259f28459a9de820f47a9ece4ffa22d4596a9af ("block/loop: implement
> REQ_FLUSH/FUA support") from the block tree.
> 
> I fixed it up (the latter removed the line that the former changed) and
> can carry the fix as necessary.

Thanks Stephen, I will merge in -git in for-next to resolve these
for you so you don't have to carry it.

-- 
Jens Axboe

