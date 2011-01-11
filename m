Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab1AKSiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 13:38:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab1AKSiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 13:38:01 -0500
Date: Tue, 11 Jan 2011 19:37:56 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org, indan@nul.nu
Subject: Re: Linux 2.6.37
Message-ID: <20110111183756.GA3782@tiehlicka.suse.cz>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com>
 <20110106104816.GA4026@tiehlicka.suse.cz>
 <20110111171744.GA3854@tiehlicka.suse.cz>
 <20110111173741.GA3988@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111173741.GA3988@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-01-11 18:37:41, Michal Hocko wrote:
> On Tue 11-01-11 18:17:44, Michal Hocko wrote:
> > [Let's CC Indan - author of the bugzilla patches]
> > 
> > On Thu 06-01-11 11:48:16, Michal Hocko wrote:
> > > Hi,
> > > 
> > > On Tue 04-01-11 17:15:45, Linus Torvalds wrote:
> > > [...]
> > > > We did have another revert to fix hopefullythe last "blank screen"
> > > > regression on intel graphics.
> > > 
> > > It seems that there is still a regression for intel graphic cards
> > > backlight. One report is https://bugzilla.kernel.org/show_bug.cgi?id=22672.
> > > I can reproduce the problem easily by:
> > > xset dpms force standby; sleep 3s; xset dpms force on
> > > 
> > > backlight doesn't get up (there is really dark picture though which
> > > doesn't get brighter by function keys which work normally) after dpms on
> > > until I close and open lid. 
> > > 
> > > The problem wasn't present in 2.6.36
> > 
> > I can confirm that this problem is not present if both patches from
> > bko#22672 are applied on top of 2.6.37 kernel.
> > I haven't tried both patches separately, but I can surely try it if it
> > makes any sense.
> 
> I have just tried that and they are really both necessary.

I must have mixed something. After retesting with the first patch
(https://bugzilla.kernel.org/show_bug.cgi?id=22672#c33) the usecase
works just fine (backlight is on without need to close&open the lid)

Sorry for confusion

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
