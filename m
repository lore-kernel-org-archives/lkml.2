Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab0JKSWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 14:22:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755811Ab0JKSWV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 14:22:21 -0400
MIME-Version: 1.0
In-Reply-To: <20101011173141.GB7116@kroah.com>
References: <AANLkTinyA=bSeSe7eavUb7fuSgM8m=QQFGqCrNtCGqKa@mail.gmail.com>
 <AANLkTikCHzaovYy+g8GBE7zwBOa-=pXk=WwQ_5ts1u5m@mail.gmail.com>
 <20101009235141.GB15564@kroah.com> <AANLkTikBGsO9wy3z-z6_pTKq0vrYme0fEhE8KcXj_Si3@mail.gmail.com>
 <20101011173141.GB7116@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Oct 2010 11:21:20 -0700
Message-ID: <AANLkTikKNHp85iHNunSnC6EJkS5P3M5-OEN3yzzFw_Q8@mail.gmail.com>
Subject: Re: stable cc's in linux -next was Re: [BUG] x86: bootmem broken on
 SGI UV
To: Greg KH <greg@kroah.com>
Cc: Dave Airlie <airlied@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 10:31 AM, Greg KH <greg@kroah.com> wrote:
>
>> So I have no solution to it. I just don't think stable has been quite
>> as stable as people would wish for.
>
> It hasn't?  I haven't heard people saying anything about this before, in
> fact, people seem to get upset at me when I reject the stuff they are
> sending me for inclusion which don't meet the stable criteria.

Quickly searching my email for "bisect" and "stable" gets a few hits
for 2.6.35. One was the problems with the stack guard page in
2.6.35.2, another was some CPU usage issue in 2.6.35.4.  And there was
the scheduler problem in 2.6.32.y or whatever (but that was a "done
differently from mainline" situation, so it was a different kind of
patch entirely).

And there probably are others that my silly search just didn't see.

> Not that I'm trying to say, "it could be worse", just that, "what could
> be done better?"

I really don't know. I suspect that a certain amount of problems are
always going to be inevitable. It's not like you can avoid regressions
entirely, at least not unless you take the "it's dead, Jim" approach
to stable.

                     Linus
