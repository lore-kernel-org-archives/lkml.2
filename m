Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab0C2NMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:12:53 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41635 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751213Ab0C2NMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:12:51 -0400
Date: Mon, 29 Mar 2010 15:12:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hemanth V <hemanthv@ti.com>, kernel list <linux-kernel@vger.kernel.org>
Cc: linux-input@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: Merge plans for Staging  Synaptics Touchscreen Driver
Message-ID: <20100329131136.GA26586@ucw.cz>
References: <19039.10.24.255.18.1269336516.squirrel@dbdmail.itg.ti.com> <20100326144415.GA1591@ucw.cz> <33474.10.24.255.18.1269863733.squirrel@dbdmail.itg.ti.com> <49670.10.24.255.17.1269864940.squirrel@dbdmail.itg.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49670.10.24.255.17.1269864940.squirrel@dbdmail.itg.ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> Pl add (if required) below tested by for the staging driver.
> >
> >>
> >> 1) are you able to use driver in staging?
> >
> > Yes I am able to use staging driver for single
> > touch events.

Good.

> >> at minimum, non-standard multitouch support needs to be removed before
> >> merging to input. Do you have time to help?
> >
> > Could you review the below patch.
> 
> Forgot to remove unused variables in earlier patch, here's
> the updated one.

Thanks, seems ok.

> Remove non-standard multi touch support.
> 
> Signed-off-by: Hemanth V <hemanthv@ti.com>

ACK.

Now... you probably want to send the patch to Greg. And then, I guess
you could take the patch from staging, and ask for another round of
review on linux-input.

If you could figure out if threaded interrupts can be used for this
driver, that would be welcome bonus.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
