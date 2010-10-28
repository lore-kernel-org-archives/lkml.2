Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934532Ab0J1U6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:58:42 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57386 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933674Ab0J1U6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:58:36 -0400
Date: Thu, 28 Oct 2010 22:58:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: Vasiliy Kulikov <segooon@gmail.com>, Iliyan Malchev <ibm@android.com>,
        Brian Swetland <swetland@google.com>, San Mehat <san@android.com>,
        kernel-janitors@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/8] staging: dream: fix information leak to userland
Message-ID: <20101028205831.GD19421@elf.ucw.cz>
References: <1288296098-18936-1-git-send-email-segooon@gmail.com>
 <20101028204509.GC22785@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101028204509.GC22785@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Structure msm_audio_stats is copied to userland with some fields unitialized.
> > It leads to leaking of contents of kernel stack memory.
> > Also struct msm_audio_config has field "unused" of type array of 3 elements,
> > not 4.  Instead of this, initialize field "type".
> > 
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> > ---
> >  drivers/staging/dream/qdsp5/audio_aac.c |    3 ++-
> 
> {sigh}
> 
> I'd really like to just drop this whole driver as I feel it's _way_
> behind whatever anyone is really using "in the wild".
> 
> Actually, I doubt that anyone even uses this thing, do they?

Not sure, you should definitely talk to codeaurora folks.

> Any objection to me just dropping the drivers/staging/dream/ tree?
> People should be working on the chipset-specific driver tree here
> instead, right?

codeaurora people should know...

> Pavel, it looks like you're not doing any dream work anymore, any
> problems with me dropping it?

Too busy to do any real work on Dream, sorry :-(.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
