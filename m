Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab0FNJId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 05:08:33 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55911 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab0FNJIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 05:08:31 -0400
Message-ID: <4C15F18C.3050905@kernel.dk>
Date: Mon, 14 Jun 2010 11:08:28 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the drbd tree with the block trees
References: <20100610135203.4649453a.sfr@canb.auug.org.au>	<4C107FBF.9050209@kernel.dk> <20100614112639.ef45a777.sfr@canb.auug.org.au>
In-Reply-To: <20100614112639.ef45a777.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-14 03:26, Stephen Rothwell wrote:
> Hi Jens, Philipp,
> 
> On Thu, 10 Jun 2010 08:01:35 +0200 Jens Axboe <axboe@kernel.dk> wrote:
>>
>> I'm starting to think that it would be a little easier if you did not
>> pull the drbd tree, I really should be pulling that into my -next branch
>> instead.
> 
> Given that the drbd tree has not been updated to match the increasingly
> different block tree, I have dropped it for today.
> 
> There a a few possibilities here:
> 	- I just drop the drbd tree completely and it only gets merged
> into the block tree.
> 	- if the drbd tree doesn't actually depend on any of the features
> in the block tree then it could be rebased onto Linus tree (and I would
> cope with any merge fixups - as I do with many other trees).
> 	- if it does depend on things in the block tree, those particular
> features in the block tree could be put in a separate branch that is
> never rebased and then that branch could be merged into both the block
> and drbd trees (this has been done before e.g. stuff in the vfs tree.
> 	- the drbd tree could be rebased on tom of the current block tree
> (but then it must be kept up to date if the block tree is rebased).

The thing with the dependencies is that sometimes they are true,
sometimes they are not. What I suggested to the drbd team is that they
always just base off Linus and then ask me to pull their changes, then I
will resolve any potential conflicts when that happens. The consequence
would be that you stop pulling the drbd tree separately.

-- 
Jens Axboe

