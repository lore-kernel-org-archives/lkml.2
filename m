Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab1D1RTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 13:19:20 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33175 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755034Ab1D1RTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 13:19:18 -0400
Date: Thu, 28 Apr 2011 17:19:10 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Daniel Walker <dwalker@fifo99.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: [PATCH] msm: watchdog: support watchdog on 8x60 and 8960
Message-ID: <20110428171909.GC7345@localhost.ucw.cz>
References: <1301105894-22835-1-git-send-email-johlstei@codeaurora.org> <1301426560.4049.0.camel@m0nster> <4D92B43B.5050101@codeaurora.org> <1301501006.5346.2.camel@m0nster> <20110330161419.GB28252@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330161419.GB28252@pulham.picochip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It doesn't sound too different that all the other watchdogs in
> > drivers/watchdog/ .. Your just detecting lockups right?
> 
> There are some watchdogs in there such as 
> drivers/watchdog/at91sam9_wdt.c that can't be stopped once enabled so 
> the driver sets up a soft timer in the kernel that kicks the watchdog to 
> prevent the system rebooting.
> 
> With this approach you could have the watchdog always enabled and being 
> kicked even if the userspace daemon wasn't running, but with the 
> flexibility of kicking it from userspace if you wanted.

sounds like a way to do it.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
