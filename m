Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab0GSAj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 20:39:57 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45819 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757803Ab0GSAj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 20:39:56 -0400
Message-ID: <4C439ED5.8010002@kernel.dk>
Date: Sun, 18 Jul 2010 18:39:49 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Martin Pirker <lkml.collector@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-rc5 inconsistent lock state
References: <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>	<201007142304.48660.rjw@sisk.pl>	<AANLkTin5Bj6HEEriLVFDQKptrZHmh698TsnMWHzVYt5H@mail.gmail.com>	<4C42099C.3070708@kernel.dk> <AANLkTikk_UNVoo9CC9DhCSwiI5mEB3j1RrXqqOPdei1L@mail.gmail.com>
In-Reply-To: <AANLkTikk_UNVoo9CC9DhCSwiI5mEB3j1RrXqqOPdei1L@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2010 11:56 AM, Martin Pirker wrote:
> On Sat, Jul 17, 2010 at 9:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> Can anyone try this completed untested patch?
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 5ab3ac2..a108b8e 100644
> ....
> 
> /usr/src/linux-2.6.35-rc5 # patch -p1 <jens.patch
> patching file block/blk-core.c
> Hunk #1 FAILED at 451.
> Hunk #2 FAILED at 515.
> 2 out of 2 hunks FAILED -- saving rejects to file block/blk-core.c.rej
> patching file include/linux/backing-dev.h
> Hunk #1 FAILED at 84.
> 1 out of 1 hunk FAILED -- saving rejects to file include/linux/backing-dev.h.rej
> patching file include/linux/writeback.h
> patching file mm/page-writeback.c
> Hunk #1 FAILED at 698.
> Hunk #2 FAILED at 719.
> Hunk #3 FAILED at 739.
> 3 out of 3 hunks FAILED -- saving rejects to file mm/page-writeback.c.rej
> 
> 
> ummmm.... help?

Oh, the patch is for the next branches. I'll see if I can fiddle it into
.35-rcX

-- 
Jens Axboe

