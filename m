Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab1ERSgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:36:43 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44224 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933460Ab1ERSgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:36:41 -0400
Date: Wed, 18 May 2011 20:36:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] PM / Hibernate: Add sysfs knob to control size of
 memory for drivers
Message-ID: <20110518183638.GA8887@elf.ucw.cz>
References: <201105100059.25372.rjw@sisk.pl>
 <201105150056.55601.rjw@sisk.pl>
 <20110518172717.GA5734@elf.ucw.cz>
 <201105182009.55813.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105182009.55813.Martin@lichtvoll.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > OK, there are no comments, so my understanding is that everyone is
> > > fine with this patch and I can add it to my linux-next branch.
> > 
> > Actually no, I don't like it. Yes, knob might be useful for debugging,
> > but having it as part of official kernel interface...
> 
> Well I and people with similar setups it is actually quite useful. It 
> makes the difference between does hibernate *every time* versus does not 
> hibernate sometimes. And I don't see why it can't go again, when the issue 
> is taken care of elsewise in the future. I think that autotuning / drivers 
> allocating their memory via whatnot is better, but until such a mechanism 
> is agreed, developed and included in official kernel I do think that this 
> knob does help.

Yes, autotuning would be better, and yes, knob is useful for you now.

I'd say the knob is for debugging and should go to debugfs somewhere.

> I think missing is some documentation so that the advanced user can figure 
> out this knob.

...so we can easily delete the knob when it is no longer neccessary.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
