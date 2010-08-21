Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab0HURF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 13:05:59 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54993 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751089Ab0HURF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 13:05:57 -0400
Date: Sat, 21 Aug 2010 19:05:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-acpi@vger.kernel.org,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fan runs full speed after S3 sometimes (regression)
Message-ID: <20100821170551.GA27159@elf.ucw.cz>
References: <4C613619.30309@gmail.com>
 <4C619CF0.30609@gmail.com>
 <20100820063107.GB1607@ucw.cz>
 <4C6E233A.5000209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6E233A.5000209@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> till I was running on 2.6.34-rc5-mm1 (mmotm) and earlier everything was
> >>> fine. Now, I'm running 2.6.35-rc6-mm1 (.35-rc5-mm1 was the same) and
> >>> sometimes when the computer (desktop) returns from S3, the CPU fan is
> >>> running at full speed making a big noise.
> >>
> >> Just to add, full power cycle is needed to get rid of that. Warm reboot
> >> is not enough.
> > 
> > Seems like bios problem... Update bios?
> 
> I don't think so, it had been working for more than 2 years before this
> issue appeared.

Well; if it survives warm reboot, then it looks like BIOS problem...

> >>> I don't know how to debug that. Bisection is out of question -- it
> >>> happens once in 10 or 20 cases. There are no fan entries in /sys.
> > 
> > Well, doing 20 suspends in a row from a script should not be too bad.
> 
> 20 is just a guess. I haven't seen it for pretty few days until the day
> before yesterday. And it looks like CPU1 is brought up a half way. When
> the fan was at full speed I tried:
> echo 0 > /sys/devices/system/cpu/cpu1/online
> and whole system freezed. Otherwise this commands succeeds.

Ok, so this looks like the kernel problem, on the other hand. Two
different problems?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
