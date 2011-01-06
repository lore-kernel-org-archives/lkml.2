Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1AFRD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:03:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633Ab1AFRDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:03:25 -0500
Date: Thu, 6 Jan 2011 18:03:22 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
Subject: Re: Linux 2.6.37
Message-ID: <20110106170322.GA27606@tiehlicka.suse.cz>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com>
 <20110106104816.GA4026@tiehlicka.suse.cz>
 <AANLkTi=aTKFVO8Lx=fDUGrxVaQL73XrsxoOP7-qYKksb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=aTKFVO8Lx=fDUGrxVaQL73XrsxoOP7-qYKksb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just for reference, my initial report was:
https://lkml.org/lkml/2010/11/23/146

On Thu 06-01-11 08:29:22, Linus Torvalds wrote:
> On Thu, Jan 6, 2011 at 2:48 AM, Michal Hocko <mhocko@suse.cz> wrote:
> >
> > It seems that there is still a regression for intel graphic cards
> > backlight. One report is https://bugzilla.kernel.org/show_bug.cgi?id=22672.
> > I can reproduce the problem easily by:
> > xset dpms force standby; sleep 3s; xset dpms force on
> >
> > backlight doesn't get up (there is really dark picture though which
> > doesn't get brighter by function keys which work normally) after dpms on
> > until I close and open lid.
> 
> Hmm. That commit no longer reverts cleanly, so it's not trivial to
> test whether all those things are exactly the same issue. It's been
> bisected in the bugzilla entry, but it would be good to verify that
> yes, reverting it really does fix the issue, and your issue is the
> exact same one.
> 
> Chris, any ideas?
> 
>                        Linus

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
