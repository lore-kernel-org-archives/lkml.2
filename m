Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971Ab2GBELg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 00:11:36 -0400
Received: from smtp191.dfw.emailsrvr.com ([67.192.241.191]:59832 "EHLO
	smtp191.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2GBELf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 00:11:35 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jul 2012 00:11:35 EDT
Message-ID: <4FF11DC8.7080908@calxeda.com>
Date: Sun, 01 Jul 2012 23:04:24 -0500
From: Rob Herring <rob.herring@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general-request@lists.sourceforge.net,
        devicetree-discuss <devicetree-discuss@ozlabs.org>
Subject: Re: SPI, GPIO, and DT maintainer ship (cry for help)
References: <CACxGe6tyO5u7eiq1OiPX-u439YAcQDFz3eOOGZ4bNPtwmYwNkg@mail.gmail.com>
In-Reply-To: <CACxGe6tyO5u7eiq1OiPX-u439YAcQDFz3eOOGZ4bNPtwmYwNkg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

On 07/01/2012 07:49 PM, Grant Likely wrote:
> Hi Wolfram, Rob & Linus W.
> 
> I believe all three of you know that I'm in the process of moving to
> Scotland. The house is on the market and we have flights booked for
> the end of July.

Cool!

> The problem is that the move is becoming so much work that I barely
> have time to sit down with the computer, let alone handle patches. It
> probably isn't going to get any better either until the kids are
> settled in their new school (mid August).  I need help to prepare for
> the next merge window, and quite possibly the next window.  Since you
> three have agreed to co-maintain those subsystems with me, can you
> please take a look at the patches that have been posted, pick up the
> ones that look ready to go to you, and get them into linux-next?  I
> may even need you to send pull requests to Linus when the window opens
> if I'm still under water.

No problem. I am going on vacation the last part of July, but should be
online off and on. There hasn't been too much that needs to be merged
thru DT tree. I have been queuing up a few things, but hadn't yet
replied on them as my last pull request hadn't been pulled.

> Also, if you have any bug fixes that need to go into v3.5, go ahead
> and send them on to Linus directly (Rob, I think I saw a pull request
> from you).

Yes, will do.

> Things will definitely be better after the move is finished and
> ksummit/plumbers is over.  Until then, thanks in advance for anything
> you can do to help with the load.

See you in San Diego and good luck with the move.

Rob
