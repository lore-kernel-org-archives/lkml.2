Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1DXJdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 05:33:12 -0400
Received: from ch-smtp05.sth.basefarm.net ([80.76.153.6]:53493 "EHLO
	ch-smtp05.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755851Ab1DXJdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 05:33:08 -0400
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Apr 2011 05:33:08 EDT
Message-ID: <4DB3EC35.7000601@fastmail.fm>
Date: Sun, 24 Apr 2011 11:24:05 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20101003 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        xorg-driver-ati@lists.x.org
Subject: Re: Radeon jittery post 2.6.35
References: <4D7CCFC3.7030906@fastmail.fm>	<AANLkTinug=6d6BKrZvA1HGZWNqgUNJKOBC3f8J5B_5oJ@mail.gmail.com>	<AANLkTik0nXX+WEwa2xZ9VV+yHwrWnx+tYNdZXPEjk=SO@mail.gmail.com>	<4D7FD2FB.9090505@fastmail.fm> <AANLkTimboMAFkqTUOwP9m2z361TM_EgthQO07T5Y_az1@mail.gmail.com> <4D8118EB.2070209@fastmail.fm> <4D831E18.9020904@fastmail.fm>
In-Reply-To: <4D831E18.9020904@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.252.234.43
X-Scan-Result: No virus found in message 1QDvYw-0000ER-I0.
X-Scan-Signature: ch-smtp05.sth.basefarm.net 1QDvYw-0000ER-I0 a7bf6a6ddecaa620ff67442976a4dd09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 03/18/11 09:55, Anders Eriksson wrote:
>  On 03/16/11 21:09, Anders Eriksson wrote:
> >  On 03/15/11 22:46, Alex Deucher wrote:
> > >  Try booting with radeon.audio=0 on 2.6.38rc, some TVs have problems
> > > with the hdmi packets we send by default.  disabling audio will treat
> > > the hdmi like dvi.
> > >
> > > Alex
> > You seem to be on to something there. radeon.audio=0 removes
> > what appears to be all of the jitter. I say "appear", because during
> > my many test runs today, I've come across moments where my brain
> > goes "wasn't what I just noticed on the TV something abnormal?" Both
> > in fb mode (post KMS), and in X11. It's definetly improved from useless
> > for family use, to perfectly ok though.
> >
> I was too early on this one. Yesterday (.38) , and today (38-rc8),
> are both jittery in post-KMS fb mode and in X, even though I use
> radeon.audio=0.
>
> A power cycling of the TV stabilizes it though.
>
> I'd be more than happy to test out any patches or ideas you might have.
>
> -A

It turns out all the failure patterns I've thought I've seen so far up
through .38.x are moot.

However, now on .39-rc, the KMS'd console is stable, and starting X
makes it bad again.

It there anything useful I can pull from any logs on the startup of X?
Either from the X
server, or the kernel. Last time I looked at the drm log from the kernel
It was unreadable
to a mere mortal, but I hope you guys can point me to what debug knobs
to enable to get a good
view of the interesting parts (How does one start a minimal X, btw?
"xinit" gives me an
undecorated xterm with the jitter. Can one start something more minimal?)

Currently running today's git xorg-server and xf86-video-dri.

-Anders
 

