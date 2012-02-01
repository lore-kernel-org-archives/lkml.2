Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab2BAPXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:23:00 -0500
Received: from postkast.cyber.ee ([195.50.202.7]:52540 "EHLO postkast.cyber.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab2BAPW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:22:59 -0500
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Feb 2012 10:22:58 EST
Date: Wed, 1 Feb 2012 17:16:19 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.3-rc2
In-Reply-To: <20120201150015.EBB2413A4D6@koiott.cyber.ee>
Message-ID: <alpine.DEB.2.00.1202011703280.16175@ondatra.cyber.ee>
References: <20120201150015.EBB2413A4D6@koiott.cyber.ee>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One thing that has happened is that I've liked seeing the merge
> message things that have come in through signed tags so much that I've
> decided to try to write more explanations even for the merges that
> don't get that kind of love from their subsystem maintainers. Some
> subsystem maintainers (David with networking is a good example) have
> tended to write nice good explanations in their pull requests, and
> I've started to try to make those kinds of things part of my merge
> messages.
>
> I'm not sure how many people really look at merges, and maybe it's a
> waste of my time, but I thought I'd try it. I've also spent more
> effort trying to explain even fairly trivial merge conflicts (although
> the truly trivial "touched next to each other" that just aren't
> interesting from a code standpoint I generally have left without
> explanation).

Having human-readable merge summaries is very good. But simple merge 
summaries that list the commits by one-line descriptions can also be 
easily improved - just increase the number of lines there.

Looking at git.kernel.org for "todays merges" gives a quick summary and 
these merge messages are artifically truncated there. Are these made by 
git? In that case, increasing the line limit of these messages to 
something that covers most normal cases would just help?

-- 
Meelis Roos (mroos@linux.ee)
