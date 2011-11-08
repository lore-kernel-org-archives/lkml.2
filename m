Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab1KHXAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:00:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40650 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab1KHXAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:00:34 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=wom5GMh1gUkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=D19gQVrFAAAA:8 a=LyQmd4zf4snJh9QsEnAA:9 a=CjuIK1q_8ugA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Date: Tue, 8 Nov 2011 18:00:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2-rc1
Message-ID: <20111108230032.GB4510@home.goodmis.org>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 06:10:02PM -0800, Linus Torvalds wrote:
> So it's been two weeks since 3.1, and you know how it works by now.
> 
> I have to say, this wasn't my favorite merge window ever. I really
> wanted to take only things that had been in -next, but verifying it
> was fairly painful, since a lot of the trees had been rebased, and the
> ones that hadn't been rebased often had some extra patches that still
> showed up when I did my "git log linux-next..FETCH_HEAD" thing.
> 
> On the whole, most of it was all good, and I didn't really end up
> complaining to people. I'm pretty sure that there were trees I
> shouldn't have let through, but the majority really had been in -next.
> 
> The other point of irritation was that there really was a lot of stuff
> that came in yesterday and basically treated the merge window as some
> kind of high-tech limbo dance. If it hadn't been for a few trees I
> wanted to pull, I had actually planned to do the -rc1 release Sunday
> afternoon instead, just to cut those annoying last-minute pull
> requests off.
> 
> And some trees didn't get pulled. You know who you are, and you can
> try to appeal to my softer side if you think it was unfair. Of course,
> if you *do* find my softer side, please tell my wife and kids too,
> they'll be thrilled.

/me searches for the softer side.

> 
> But the main reason some trees didn't get pulled was that they
> generated long flame-wars, and I just felt like I really didn't need
> the aggravation this time around, especially as I knew I had plenty
> other trees to pull.

Is there a reason that the ktest tree didn't get pulled? Is it because
it is not in next (nor has it ever been). I could arrange to put it
there, but as it is a simple tool in the tools directory I didn't think
it required the next processing. But I could update that if so desired.

There hasn't been any flame wars on ktest either, so that could not be
it. Maybe I could start a flame war with myself to get it more
attention.


Anyway, the pull request is here, hopefully that softside exists.

https://lkml.org/lkml/2011/10/28/97

Thanks!

-- Steve

