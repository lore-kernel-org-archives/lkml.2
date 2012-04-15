Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab2DORt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 13:49:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60399 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab2DORtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 13:49:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP44s3mOsCGG5_gd6zTUeXewTFKeVEmAkt2FvM=wTm-5AEC+w@mail.gmail.com>
References: <20120412144626.GA14868@kroah.com> <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
 <CA+55aFwKYYgZcBX=L-q_6UdvkvFai+yjzgVxq7cA+HLL-Zojhw@mail.gmail.com>
 <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
 <CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com>
 <CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com>
 <CA+55aFwaOGbD6S_7So34ZuANG-6fZXZhEah8G0X7McDGhionSg@mail.gmail.com>
 <CAMP44s06jrPBzf5Lt86-GDxD_PxqcaeJgmYS4tJhcvDdf=J5zA@mail.gmail.com>
 <20120414104733.GA4871@gmail.com> <CAMP44s0tBbgmunXTN9Jyw=HHnXFyvRY3qo5Vf-jXETUM4HEGWA@mail.gmail.com>
 <20120415065124.GC29563@gmail.com> <CAMP44s3mOsCGG5_gd6zTUeXewTFKeVEmAkt2FvM=wTm-5AEC+w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Apr 2012 10:49:02 -0700
X-Google-Sender-Auth: LuQ1uKMs1kZJESaCe9Pl_furobM
Message-ID: <CA+55aFz8oepgj7W8W=d18qwQt3JUGgv+pCto-_2WS3WJ3ZKqzQ@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 10:15 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
>
> This is not a reason, this is just stating what happens without
> explaining *why*.
>
> Q: What changes when a tag is made?
> A: A tag is made

I'll make one more try at explaining to you, but then I'll just set my
mail reader to ignore you, because judging by past performance (not
just in this thread) you will just continue to argue.

I'll explain two things. None of those two things are actually about
"tags", although I will start with the issue that is at least
"coincidental" with tags, namely the fundamental nature of reality.

At no point is the "tag" at all important. You are bringing up all
these red herrings, and trying to actively confuse the issue.

The only thing that matters is "it's been made available to others".
That's fundamentally what a release is. If you know physics, think of
a release (and the tag is associated with it) as "collapsing the wave
function". Before that, the outside world doesn't know the exact state
of your tree (they may have good guesses based on the patches they've
seen) - after that, it's "done". You cannot change it. And more
importantly, other people can see the state, and measure it, and
depend on it.

This true regardless of git, btw, but git actually makes that "it's
been available to others" be a real technical distinction, since the
identity of something cannot be changed (so "availability" ends up
meaning "identity" - something is absolutely fixed in stone - you
can't change it, because what you made available is fixed and outside
of your control).

So once some release has been made, you can't change it. If Greg has
made a 3.3.2 release (the tag is not the important part, although the
tag is *coincidental* with the release, of course), then that is what
it is. You cannot change history. You cannot say "oh, we can go back
in time and undo things". There is no change that is a no-op.

THAT is important. And it seems to be something that you don't
understand. The past is immutable. A "tag" has no real other meaning
than as a particular marker of a particular past state. But the tag
itself is not what makes the past immutable. REALITY is what makes the
past immutable.

And reverting a patch DOES NOT CHANGE HISTORY.  It does not magically
go back in time and say "nothing happened". Every time you say that
"reverting a pacth is a no-op", you look more and more stupid, because
you don't seem to understand this fundamental fact.

A revert is nothing but another change. A revert is *exactly* the same
thing as a patch that doesn't revert, but instead fixes. If you cannot
understand that, you're not worth talking to.

And the reason we don't do reverts in stable releases without having
the revert upstream is *EXACTLY* the same reason we don't make other
changes in stable releases without making that change upstream first.

And another really fundamental thing that you don't seem to understand
is that the most important part of "stability" is not actually "bug
free" (which is something we can never attain in any project that is
non-trivial and still evolving), but "reliability". Not even of a
single release, but in *time*. We want to make fundamental and
*reliable* forward progress. And that is why we have the whole "we
don't make changes to the stable tree without having those changes in
upstream first".

And the thing is, it's not just 3.3.3 that follows 3.3.2. It's 3.4.1
too. The reason we have the "no stable fixes before it's been
upstreamed" (and again: a "revert" is *nothing* but another name for a
fix, that gives some additional information about *how* we fixed
something too) is because we want to make nice plodding reliable
forward progress. Mistakes (== bugs) will happen, but the stable rules
are there to make sure that those mistakes get fixed, and don't have
long-term impact. THAT is the "stable" part of the stable series.
Things are monotonic in the big picture, even if we may have some
non-monotonic noise in the details.

If you think that "stable" means "bug free", you are fundamentally
confused about software engineering.

If you think you can go back in time and "undo" things, you are even
more fundamentally confused about reality.

And if you cannot understand what tens of people have tried to explain
to you, you are just f*cking stupid.

                     Linus
