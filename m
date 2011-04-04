Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab1DDSXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:23:04 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38477 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab1DDSXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:23:02 -0400
Subject: Re: [PATCH] Make clocksource name const
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1104041943580.19945@localhost6.localdomain6>
References: <20110219153450.GI29493@n2100.arm.linux.org.uk>
	 <20110402141134.GA23324@n2100.arm.linux.org.uk>
	 <1301938920.2319.2.camel@work-vm>
	 <alpine.LFD.2.00.1104041943580.19945@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 11:22:53 -0700
Message-ID: <1301941373.2319.28.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 19:44 +0200, Thomas Gleixner wrote:
> On Mon, 4 Apr 2011, john stultz wrote:
> 
> > On Sat, 2011-04-02 at 15:11 +0100, Russell King - ARM Linux wrote:
> > > Has this patch been rejected?
> > 
> > No, just my clocksource cleanups tree didn't get pulled for 2.6.39.
> 
> Crap.

Sorry, I probably should have nagged you a bit more.


> > Thomas: The commit can be found here:
> > http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=commit;h=36d8593ec74dc04d3bd7c1c897a7b7cfbd0b0dc6
> 
> Is there more stuff pending ?

Just clocksource_register_hz/khz bits, but those aren't critical, and
can be moved in slowly via arch maintainers if you're not comfortable
with them. I also need to refresh some of them, as there were some
collisions in the merge window.

thanks
-john




