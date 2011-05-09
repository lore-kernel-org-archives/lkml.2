Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1EISbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 14:31:51 -0400
Received: from imr4.ericy.com ([198.24.6.8]:54550 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab1EISbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 14:31:50 -0400
Date: Mon, 9 May 2011 11:31:38 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Sid Boyce <sboyce@blueyonder.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
Message-ID: <20110509183138.GB4964@ericsson.com>
References: <4DB17A3B.3060609@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4DB17A3B.3060609@blueyonder.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sid,

On Fri, Apr 22, 2011 at 08:53:15AM -0400, Sid Boyce wrote:
> Guenter Roeck wrote:
> Depends. In our case, turns out the devices consuming the clock
> have user mode drivers. Lots of history there, but the chip vendors
> provide those user mode drivers, and the teams responsible for
> integrating the drivers decided to not rewrite it to kernel mode drivers.
> Also, for special purposes such as margining, it is necessary to control
> the clock from userspace. So, for our use case, I need the user-visible
> interface. I _don't_ need the kernel interface, at least not right now,
> which is why I did not add it.
> 
> Browsing through the web, it seems the chip is somewhat popular with
> Amateur Radio. No idea if it would ever be controlled for such a purpose
> from Linux, but if so, it would also require a user configurable frequency.
> 
> If there is a better place for such a driver than misc, please let me know.
> 
> Thanks,
> Guenter
> =============================================================================
> Support for these devices included in several Amateur radio programs 
> tend to differ greatly which means reinventing the wheel in most of them.
> Programs like Linrad, sdr-shell, quisk, lysdr, ghpsdr3, etc.
> It's a small addition to the kernel that would significantly help in the 
> development of software for the myriad of SDR (Software Defined Radio) 
> designs based on this chip family.
> I have 5 Amateur Radio transceivers using this chip and 2 more soon to 
> be added.
> They are all open hardware heavily reliant on Linux.
> The addition of UAC2 (USB Audio Class 2) kernel support has helped our 
> SDR hardware design efforts significantly.
> I and the rest of the Linux SDR community would be happy to see it included.
> Regards
> Sid.

Thanks for the feedback. Somehow I missed your reply at the time.

As you probably have noticed from the discussion, I seems to be unlikely that
the driver will be accepted into the kernel, at least not unless there is
significant demand for it from others.

It may help if you can provide a list of requirements from your side (do you need 
a kernel API ? Do you need an ABI to set the frequency from applications ?).

I would be happy to provide and maintain the driver as separate patch until it 
is accepted (if that ever happens), and work with application maintainers to 
integrate it. Let me know if there is interest, and feel free to forward this
e-mail to interested parties.

Thanks,
Guenter
