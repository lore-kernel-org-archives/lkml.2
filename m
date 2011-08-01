Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab1HAApZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 20:45:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897Ab1HAApX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 20:45:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110731223739.GZ26275@sortiz-mobl>
References: <20110731223739.GZ26275@sortiz-mobl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 31 Jul 2011 14:45:00 -1000
Message-ID: <CA+55aFw3AW5mB-9Q5hkmL1zRPybbAb1vFCkftx3xFGZ6P5uz6g@mail.gmail.com>
Subject: Re: [GIT] [3.1] MFD pull request
To: Samuel Ortiz <sameo@linux.intel.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Sanjeev Premi <premi@ti.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Keshava Munegowda <Keshava_mgowda@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jesper Juhl <jj@chaosbits.net>, Dan Carpenter <error27@gmail.com>,
        Jin Park <jinyoungp@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Om Prakash <omprakash.pal@stericsson.com>,
        Axel Lin <axel.lin@gmail.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Oleg Drokin <green@linuxhacker.ru>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Robert Rosengren <robert.rosengren@stericsson.com>,
        Margarita Olaya <magi@slimlogic.co.uk>,
        Peter Huewe <peterhuewe@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 12:37 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
>
> This is the MFD pull request for the 3.1 merge window.

Guys, I'm getting *really* fed up with these kinds of trees.

This -git tree clearly had no testing at all, and cannot possibly have
been in -next.

How do I know? It's based on something I pushed out this morning, so
all the commits are really recent.

DO NOT DO THIS. It annoys the hell out of me to pull something and be
able to definitely say immediately that the person who wrote the pull
request clearly gave that particular git tree zero amount of actual
testing.

I pulled this time, because I just cannot find it in myself to care
too much about mfd.

But for the very same reason, next time I notice people rebasing their
trees on top of random points, I will just not pull.  If I see that
the tree they based stuff on is from the merge window, I'll just go
"this guy clearly means for this to get more testing, and meant for
this to be pulled in *next* merge window".

And it doesn't matter one whit if you say something like "Oh, but I
use quilt, so it's been tested there, and I just imported a very well
tested tree into -git to push it to you". Dammit, even if you use
quilt or something else to actually maintain your patch series, I KNOW
DAMN WELL THAT YOU DIDN'T TEST THAT SERIES ON TOP OF THE RECENT CRAPPY
NFS PULL!

So if you use quilt or something, then import the patch series on top
of something STABLE AND SANE. Start off with the released 3.0, that at
least doesn't have random pulls that have known compile issues. Use
that for testing, and don't send me a re-based patch-series that
clearly cannot possibly have been tested in that form, and that was
based on a kernel that had ugly problems.

(And during the merge window, pretty much any "Linus' kernel of the
day" tends to have some problem or other. DON'T USE RANDOM KERNELS FOR
YOUR BASE).

Seriously. It really annoys the hell out of me when I get pull
requests that are totally half-assed. And today I got *two* of them
(that NFS pull request that you had based your tree on really was
total crap too, and had clearly not been tested enough)

I'm grumpy. I don't want to know that submaintainers are sending me
untested crap. So if you are too damn lazy to test things, at least
make it not so horribly OBVIOUS to me that it's clearly not tested,
and that it has clearly not been in -next in the form that you sent it
to me. Try to at least spend *some* time trying to make your pull
request look competent, ok?

But best would be if it was actually tested, and had actually been in
-next for a week. That is *especially* true when you send me a pull
request late in the merge window.

There is *NO* excuse for sending me crap this late in the merge
window. If it's not ready at this point, don't send it to me. It's
that simple. And yes, Trond, I'm very much looking at you too.

                  Linus
