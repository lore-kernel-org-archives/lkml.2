Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab2DYIdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:33:23 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64529 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2DYIdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:33:19 -0400
Date: Wed, 25 Apr 2012 10:33:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, apw@canonical.com
Subject: Re: Please fix or revert: [PATCH] checkpatch: add --strict tests for
 braces, comments and casts
Message-ID: <20120425083313.GA20853@gmail.com>
References: <20120416.142728.864894452301706752.davem@davemloft.net>
 <20120416202654.GA4678@gmail.com>
 <20120416203451.GA4248@gmail.com>
 <20120416.170004.2154403807488537042.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416.170004.2154403807488537042.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@kernel.org>
> Date: Mon, 16 Apr 2012 22:34:51 +0200
> 
> > 
> > * Ingo Molnar <mingo@kernel.org> wrote:
> > 
> >>     If you don't "see" it as ugly it's simply because your brain
> >>     is not wired up to see 3D/2D geometry as a significant
> >>     source of information. A significant portion (I'd 
> >>     guesstimate a narrow majority) of kernel hackers *does* see
> >>     2D/3D layout details in code and finds inconsistencies in 
> >>     them counterproductive.
> >> 
> >>     ( It's roughly the same distinction that makes some people
> >>       love the typographic layout of the iPhone/iPad while 
> >>       others consider it unnecessary bling. )
> > 
> > Another example are the recent Google+ layout changes. Those who 
> > don't see 2D details found it an unnecessary waste of screen 
> > real estate.
> > 
> > To me and many others the new layout, while sparser, is actually 
> > noticeably less taxing to read, because information is 
> > structured in such a "geometrically obvious" way.
> 
> I guess us visual retards will have to find a new web site to 
> use then, thanks for the lesson Ingo.

All I'm trying to point out is that it's a visual conflict that 
exists which probably has genetic origins.

For you it's too much whitespace, for me (and apparently Linus) 
the lack of it results in harder to read patterns of code due to 
missing geometric symmetry clues.

Since I don't have your brain and your eyes I cannot know 
exactly how bad the extra whitespaces are for you - and you 
probably don't know how bad the lack of symmetry is for me and 
others.

So I did not intend to make any judgement about it one way or 
another, but I guessed that a bit more vertical size is probably 
less taxing than less structure - but I'm obviously biased. If 
it's really bad for you we can still reconsider.

( I suspect it would be pretty hard but not impossible to
  construct an objective readability test to settle similar 
  issues scientifically and create an 'ideal' coding style based 
  on objective rules alone, eliminating subjective 'taste'. )

Thanks,

	Ingo
