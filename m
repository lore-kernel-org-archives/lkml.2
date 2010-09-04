Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab0IDIst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 04:48:49 -0400
Received: from ist.d-labs.de ([213.239.218.44]:50833 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab0IDIsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 04:48:47 -0400
Date: Sat, 4 Sep 2010 10:48:44 +0200
From: Florian Mickler <florian@mickler.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Martin Pirker <lkml.collector@gmail.com>,
        Dan Carpenter <error27.lkml@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>, mjg@redhat.com
Subject: Re: 2.6.35-rc5 inconsistent lock state
Message-ID: <20100904104844.1138b5af@schatten.dmk.lab>
In-Reply-To: <4C81F29C.7030600@kernel.dk>
References: <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>
	<201007142304.48660.rjw@sisk.pl>
	<AANLkTin5Bj6HEEriLVFDQKptrZHmh698TsnMWHzVYt5H@mail.gmail.com>
	<4C42099C.3070708@kernel.dk>
	<AANLkTik5VjJsdWhRcxCGCoayMTZRUwTNUzWNpqYxjzLs@mail.gmail.com>
	<20100903093755.6fa13d4f@schatten.dmk.lab>
	<4C81F29C.7030600@kernel.dk>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Sep 2010 09:17:48 +0200
Jens Axboe <axboe@kernel.dk> wrote:

> On 09/03/2010 09:37 AM, Florian Mickler wrote:
> > On Mon, 19 Jul 2010 21:48:04 +0200
> > Martin Pirker <lkml.collector@gmail.com> wrote:
> > 
> >> On Sat, Jul 17, 2010 at 9:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
> >>> I posted a patch for this the other day, but I just now notice
> >>> that it was a private list of CC addresses.
> >>>
> >>> Can anyone try this completed untested patch?
> >>
> >> [sorry Jens for my first failed test attempt, my idiocy...]
> >>
> >> applied to 2.6.35-rc5 -> error message so far not seen again.
> >> about functionality, well, HD spin up control via laptop_mode I cannot
> >> say, I've a SSD...
> >>
> >> HTH,
> >> Martin
> > 
> > Is this patch on route to mainline? Or did this get fixed some other
> > way?
> 
> The lock is bh safe in mainline now, the patch should not be
> needed. Are you still seeing the bad behaviour?
> 
No, I just followed up the bug report from bug #16400[1]. I'm closing
it now. (It was marked as "resolved", which surfaces as "pending"
in Rafael's reports.)

Thx,
Flo

[1] https://bugzilla.kernel.org/show_bug.cgi?id=16400

p.s.: well, I'm closing it as soon as the bugzilla is available again. 
