Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084Ab0EUTYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 15:24:35 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43598 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab0EUTYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 15:24:34 -0400
Date: Fri, 21 May 2010 21:24:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block tree for 2.6.35
Message-ID: <20100521192433.GC23411@kernel.dk>
References: <20100521192026.GB23411@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521192026.GB23411@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21 2010, Jens Axboe wrote:
> Hi Linus,
> 
> This is the initial (and big) part of the bits stashed in the block git
> tree for 2.6.35.
> 
> - A good bunch of IO controller updates. I apologize for the quality of
>   the changelog for those, I should have caught that in due time. Will
>   not happen again.
> - Updates and additions to the discard requests.
> - A big drbd update.
> - Fixes for a few writeback bugs and regressions.
> - The pipe grow/shrink support with the default 256 page limit and
>   a proc file for root to modify that limit.
> - Make laptop mode per-device instead of a global setting.
> - And of course a good bunch of bug fixes.
> 
> Please pull.
> 
>   git://git.kernel.dk/linux-2.6-block.git for-2.6.35

So one of your very latest pulls causes a merge conflict in
ext3/fsync.c. Did not happen an hour or two ago :-)

I'll pull in your latest and send a new diffstat.

-- 
Jens Axboe

