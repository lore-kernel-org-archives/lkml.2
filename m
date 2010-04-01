Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab0DAQJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:09:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755565Ab0DAQJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:09:10 -0400
Date: Thu, 1 Apr 2010 09:04:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jason Wessel <jason.wessel@windriver.com>
cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] kgdb fixes for 2.6.34-rc2
In-Reply-To: <4BB0B2AB.2060207@windriver.com>
Message-ID: <alpine.LFD.2.00.1004010857060.3707@i5.linux-foundation.org>
References: <1269285449-1424-1-git-send-email-jason.wessel@windriver.com> <4BB0B2AB.2060207@windriver.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Mar 2010, Jason Wessel wrote:
>
> Ping.
> 
> Linus, please help me understand how we can continue to move forward on
> the kernel debugger pull requests.  There have been numerous requests
> that have not been pulled and have no response as to what needs to be
> acted on to resolve any outstanding issues.

I've been swamped and bad, and since I wrote another email to explain why 
I'm always so grumpy (unrelated thread, nothing to do with kgdb), I'll 
cut-and-paste some of the relevant explanation for my pulling (or not 
pulling, as in this case) here too..

--> begin cut-and-pastee <--
  
  Even on the merging side, what ends up happening is that some trees I 
  decide I can't afford to merge, simply because the potential pain of 
  merging without knowing the code is too high. So I can merge a new 
  filesystem without any issues - if it's buggy, all I need to know is "new 
  filesystem craps out". But when it comes to core generic code that anybody 
  can hit, I have to _rely_ on submaintainers doing the right thing.
  
  And when that doesn't work out, and stuff falls through the cracks, I'm 
  kind of screwed. And this looked like a "fall through the cracks" thing.
  
  [ I skipped the kdb merge this window, for example, and I feel bad about 
    that, and will have to walk over the pull request with a comb once the 
    merge window fallout calms down, so that I can do it the next merge 
    window. Not because I need to understand each line, but because I 
    need to understand what the potential bigger-picture impacts are when 
    something that looks odd pops up ]
  
--> end cut-and-paste <--

and obviously one of the issues is that I end up always prioritizing my 
pulls etc, and because I'm not a huge fan of debuggers (understatement of 
the year), that pull request was always at the bottom of the pile. And 
this merge window I ended up having some Intel event things that took up a 
good chunk of the window, so I never did get to that bottom.

Usually things calm down for me at around -rc4, when it turns into a 
waiting game instead of fighting fires. So I'm expecting to do that "look 
things over" this weekend or next week. 

			Linus
