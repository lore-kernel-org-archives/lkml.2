Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab1AKNdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:33:24 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48678 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932138Ab1AKNdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:33:21 -0500
Date: Tue, 11 Jan 2011 14:33:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Michal Hocko <mhocko@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
Subject: Re: Linux 2.6.37
Message-ID: <20110111133320.GB10705@atrey.karlin.mff.cuni.cz>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com> <20110106104816.GA4026@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106104816.GA4026@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> On Tue 04-01-11 17:15:45, Linus Torvalds wrote:
> [...]
> > We did have another revert to fix hopefullythe last "blank screen"
> > regression on intel graphics.
> 
> It seems that there is still a regression for intel graphic cards
> backlight. One report is https://bugzilla.kernel.org/show_bug.cgi?id=22672.
> I can reproduce the problem easily by:
> xset dpms force standby; sleep 3s; xset dpms force on

(You are using "vesa" or "fbcon" X11 driver, right? I seen same problem
until I switched to "intel" X11 driver).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
