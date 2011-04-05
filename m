Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1DEHpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 03:45:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48448 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1DEHpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 03:45:50 -0400
Date: Tue, 5 Apr 2011 08:45:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, david@lang.hm,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, Detlef Vollmann <dv@vollmann.ch>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110405074510.GA4699@n2100.arm.linux.org.uk>
References: <201104031726.37420.arnd@arndb.de> <20110403160324.GA8050@n2100.arm.linux.org.uk> <201104040259.26601.arnd@arndb.de> <1301915022.15819.28.camel@e102109-lin.cambridge.arm.com> <20110404112104.GB19854@n2100.arm.linux.org.uk> <1301923457.417.34.camel@e102391-lin.cambridge.arm.com> <20110404133104.GA23266@n2100.arm.linux.org.uk> <1301925445.417.54.camel@e102391-lin.cambridge.arm.com> <BANLkTi=d-rQpinSW9YPsZbkh9tDK5FLS+w@mail.gmail.com> <4D9AB958.5010304@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9AB958.5010304@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 12:10:24PM +0530, Santosh Shilimkar wrote:
> The only issue I see is the clock-events implemented using
> local timers capabilities in low power modes. The local timers
> won't be able wakeup CPU from DORMANT or OFF state and hence
> you will need an additional wakeup capable clock-event
> working together with the local timers using clock-notifiers.

So yet again, we have something that almost works but doesn't, and
we're going to have to have board-specific hacks to work around this.

This makes the architected timers totally *pointless*.
