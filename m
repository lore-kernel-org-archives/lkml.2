Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab0ICHiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:38:00 -0400
Received: from ist.d-labs.de ([213.239.218.44]:49192 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab0ICHh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:37:59 -0400
Date: Fri, 3 Sep 2010 09:37:55 +0200
From: Florian Mickler <florian@mickler.org>
Newsgroups: gmane.linux.kernel
Cc: Martin Pirker <lkml.collector@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Dan Carpenter <error27.lkml@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>, mjg@redhat.com
Subject: Re: 2.6.35-rc5 inconsistent lock state
Message-ID: <20100903093755.6fa13d4f@schatten.dmk.lab>
In-Reply-To: <AANLkTik5VjJsdWhRcxCGCoayMTZRUwTNUzWNpqYxjzLs@mail.gmail.com>
References: <AANLkTikDF0TL6OyPVCzPlUTwxFehcrETn3ysgSSeTq92@mail.gmail.com>
	<201007142304.48660.rjw@sisk.pl>
	<AANLkTin5Bj6HEEriLVFDQKptrZHmh698TsnMWHzVYt5H@mail.gmail.com>
	<4C42099C.3070708@kernel.dk>
	<AANLkTik5VjJsdWhRcxCGCoayMTZRUwTNUzWNpqYxjzLs@mail.gmail.com>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 21:48:04 +0200
Martin Pirker <lkml.collector@gmail.com> wrote:

> On Sat, Jul 17, 2010 at 9:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
> > I posted a patch for this the other day, but I just now notice
> > that it was a private list of CC addresses.
> >
> > Can anyone try this completed untested patch?
> 
> [sorry Jens for my first failed test attempt, my idiocy...]
> 
> applied to 2.6.35-rc5 -> error message so far not seen again.
> about functionality, well, HD spin up control via laptop_mode I cannot
> say, I've a SSD...
> 
> HTH,
> Martin

Is this patch on route to mainline? Or did this get fixed some other
way?
