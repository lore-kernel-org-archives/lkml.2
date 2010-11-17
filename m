Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616Ab0KQBoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:44:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093Ab0KQBon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:44:43 -0500
Subject: Re: nouveau build failure (was Re: Linux 2.6.37-rc2)
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Martin Peres <martin.peres@ensi-bourges.fr>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4CE332F7.2070805@ensi-bourges.fr>
References: <AANLkTi=34dJ1HJco8gw=Y+7Ear3mC+XnahqODhnn+56u@mail.gmail.com>
	 <20101116125055.74f78634.randy.dunlap@oracle.com>
	 <1289941098.20058.1.camel@nisroch>  <4CE332F7.2070805@ensi-bourges.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 11:43:30 +1000
Message-ID: <1289958210.2326.1.camel@nisroch>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 02:42 +0100, Martin Peres wrote:
> Le 16/11/2010 21:58, Ben Skeggs a écrit :
> > On Tue, 2010-11-16 at 12:50 -0800, Randy Dunlap wrote:
> >> On Tue, 16 Nov 2010 12:45:43 -0800 Linus Torvalds wrote:
> >>
> >>> Looks like commit 34e9d85a1aae ("drm/nouveau: Add temperature support
> >>> (vbios parsing, readings, hwmon)") didn't make things properly
> >>> dependent on CONFIG_HWMON (or do the appropriate "select HWMON" or
> >>> whatever).
> >>>
> >>> Added some collection of hopefully more relevant people to the discussion..
> >>>
> >>>                    Linus
> >>
> >> This build error was reported for linux-next on 2010.1011 and 2010.1025,
> >> with no replies.
> >>
> >> Some process fix would be nice to see.
> > It's actually been fixed in the nouveau tree, I have to go through and
> > get fixes out of it and send them to Dave.
> >
> > Ben.
> Thanks Ben, I should have checked my fix actually went in David's 
> drm-fixes branch. I'll try to be more vigilent on this in the future.
Well I'm partially to blame.  I'd prefer, where possible, for patches to
go through me (so, the nouveau tree) and then get them to Dave.  I've
been busy working on other things lately, and missed it too :)

Ben.
> 
> Martin


