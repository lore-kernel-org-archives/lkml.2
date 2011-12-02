Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab1LBT2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:28:23 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:49626 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1LBT2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:28:21 -0500
Message-ID: <1322854083.21423.168.camel@work-vm>
Subject: Re: [PATCH 2/3] clocksource: dbx500: convert to
 clocksource_register_hz()
From: John Stultz <john.stultz@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Date: Fri, 02 Dec 2011 11:28:03 -0800
In-Reply-To: <CACRpkdbMvYr_ezZJ2-8qk0PVzDyPEwGJ+wCTwMnUwToEaK4v+A@mail.gmail.com>
References: <1322724016-9770-1-git-send-email-yong.zhang0@gmail.com>
	 <1322724016-9770-3-git-send-email-yong.zhang0@gmail.com>
	 <1322783723.21423.150.camel@work-vm>
	 <CACRpkdbMvYr_ezZJ2-8qk0PVzDyPEwGJ+wCTwMnUwToEaK4v+A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11120219-2398-0000-0000-00000276BF75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 09:29 +0100, Linus Walleij wrote:
> On Fri, Dec 2, 2011 at 12:55 AM, John Stultz <john.stultz@linaro.org> wrote:
> > On Thu, 2011-12-01 at 15:20 +0800, Yong Zhang wrote:
> >> Convert clocksource_dbx500_prcmu to use clocksource_register_hz.
> 
> > I've queued this myself, but I'd prefer it to go through the appropriate
> > maintainer. That said, if I don't see it in -next in a week or so, I'll
> > go ahead and add it to my 3.3 list for Thomas.
> 
> Given that the driver is in drivers/clocksource/* aren't You+Thomas
> the maintainers?

Fair enough. :) 

I just want to make sure I'm not breaking anything, or surprising
anyone, since I've got limited ability to test all the various hardware
drivers.

> Actually this is one of the instances where we try to push ARM stuff
> down to a subsystem where it belongs for proper handling by the
> subsystem maintainers.

Alrighty, as long as I get an ack or tested-by from someone who has
hardware this sounds reasonable. 

thanks!
-john


