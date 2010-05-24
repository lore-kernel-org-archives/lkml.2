Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab0EXTCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 15:02:18 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40440 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753733Ab0EXTCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 15:02:16 -0400
Date: Mon, 24 May 2010 21:02:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Matt Reimer <mattjreimer@gmail.com>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
Message-ID: <20100524190206.GL1292@ucw.cz>
References: <Pine.LNX.4.44L0.1005162219330.24400-100000@netrider.rowland.org>
 <4BF0F3FF.2010603@crca.org.au>
 <201005172235.37824.rjw@sisk.pl>
 <4BF1C86B.8000203@crca.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF1C86B.8000203@crca.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >>- We're dealing with the symptom, not the cause. Almost always a bad idea.
> >
> >I very much prefer to have a fix for a symptom than no fix at all, which is the
> >realistic alternative in this case.
> >
> >So, I think we should merge the patch and if someone finds the root cause
> >at one point in future, then we can just use the *right* approach instead of
> >the present one.
> >
> >The problem is real and people in the field are affected by it, so if you don't
> >have a working alternative patch, please just let go.
> 
> I'm not denying that the problem is real. What I am concerned about
> is finding a real solution, not just putting a sticky plaster over
> the wound. It seems to me to be much wiser to deal with the issue
> properly now instead of doing extra work later to diagnose what
> might be a harder to reproduce symptom of the same problem. I'd
> happily put the time in now myself, but I simply don't have the time
> this week.
> 
> Would it be possible to apply the patch, adding some sort of new tag
> that can be used to say "This needs further attention", perhaps
> including an enduring reference to this conversation. Later, the
> 'real' fix could include another special tag that says "Proper fix
> for the symptom addressed in commit 5e94f810"?

WARN_ON() whenever patch triggers?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
