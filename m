Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab1BUEKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:10:18 -0500
Received: from foo.stuge.se ([213.88.146.6]:33157 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932152Ab1BUEKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:10:15 -0500
Message-ID: <20110221041011.22543.qmail@stuge.se>
Date: Mon, 21 Feb 2011 05:10:11 +0100
From: Peter Stuge <peter@stuge.se>
To: Indan Zupancic <indan@nul.nu>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [BUG] drm/i915 Screen corruption introduced by
	a00b10c360b35d6431a94cb
Mail-Followup-To: Indan Zupancic <indan@nul.nu>,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl> <20110219182511.GA3977@viiv.ffwll.ch> <20110220035143.15480.qmail@stuge.se> <bf012806f2016262399d27c911a8514d.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf012806f2016262399d27c911a8514d.squirrel@webmail.greenhost.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
> > Confirm I also have this issue on my X40, but there are other bugs
> > that are much more significant so I haven't bothered mentioning this.
> 
> What issues?

The one I confirmed is corrupted graphics within Gecko. I haven't had
Xv working for a long time either. Not sure if I've tried it with
this kernel though.


> If it's backlight related, try my patch at:
> http://lkml.org/lkml/2011/2/16/447

Yeah also have backlight issue whenever the backlight level changes
by other means than Fn+Home/End. (Lid switch, screen blank)
I noticed the patch and that it solved the issue for someone. I'm not
too inconvenienced by this issue though.


> Or if the screen is black after suspend/screen blank

Oh I've stopped using suspend since using KMS. I get way too angry
about all the state that I lose if resume fails so I don't risk it.


> Actually, a lot of bugs were recently introduced and fixed, with
> two months ago you're probably in the new-bugs-only period, so I
> can recommend trying 2.6.38-rc5.

Yeah, I think it's time to pull Linus' git. I've been keeping an eye
on things i915 on the list for a good while already.


> This screen corruption is the only problem for me, but I don't do
> anything fancy with my laptop. The ipw2200 wireless driver is quite
> crappy, but it has always been as far as I know.

I've used ipw2200 with great success for many years, but these days
I'm having fun (no, not at all) with ath9k where there is some very
fundamental hardware issue between laptop and card. I'd need to hook
up logic analyzer to say anything concrete, but I have no end of
problems with internal ath9k in my machine. It's completely unusable.

The only other annoying issue I have is that as wine enumerates
available screen resolutions i915 goes out to the VGA connector,
which on 855 always means a 600ms timeout when nothing is connected,
but this is a bit tricky because the hardware just can not tell if
anything is connected.

I would be very happy if there was a knob for enabling/disabling the
VGA connector though.


> Good luck,

Thanks, you too!


//Peter
