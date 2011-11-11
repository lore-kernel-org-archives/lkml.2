Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1KKXzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 18:55:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57523 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab1KKXzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 18:55:10 -0500
Date: Sat, 12 Nov 2011 00:55:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, len.brown@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] NULL deref in swapin_readahead
Message-ID: <20111111235502.GA29116@elf.ucw.cz>
References: <4EBD0767.8040901@cwi.nl>
 <201111111307.02203.rjw@sisk.pl>
 <4EBD14B4.5000201@cwi.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBD14B4.5000201@cwi.nl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >Well, the trace doesn't indicate how the problem is related to the
> >suspend/resume code paths.
> >
> >Is this a regression for you?
> >
> >Thanks,
> >Rafael
> Hi Rafael,
> 
> This problem manifests itself when resuming from RAM, but only very
> infrequently. This is the third occurrence since I started using
> this machine three months ago. I suspend it to RAM at least twice a
> day. The previous two occurrences were on 3.0. So not a clear
> regression in that sense. (Note this is from memory, I didn't record
> those other two oopses)
> 
> However, since it happens immediately upon resume, I suspected it
> was related. Would you have any tips for stress testing resumes? If
> I can increase the reproducibility then I could try to bisect it.

It should be possible to configure machine for Wake-on-lan on
wake-on-rtc, then run s2ram in a loop...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
