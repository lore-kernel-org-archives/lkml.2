Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2BFUXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:23:25 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:37017 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2BFUXY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:23:24 -0500
Date: Mon, 6 Feb 2012 15:23:07 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "x86@kernel.org" <x86@kernel.org>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH v5 2/5] x86/platform: (TS-5500) add GPIO support
Message-ID: <20120206152307.7d1fb316@v0nbox>
In-Reply-To: <20120206153742.GE10173@sirena.org.uk>
References: <1328130344-18836-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1328130344-18836-3-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20120201213025.53d820d2@pyramind.ukuu.org.uk>
	<1328211236.2261.152.camel@groeck-laptop>
	<20120206153742.GE10173@sirena.org.uk>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Mon, 6 Feb 2012 15:37:42 +0000,
Mark Brown <broonie@opensource.wolfsonmicro.com> a écrit :

> On Thu, Feb 02, 2012 at 11:33:56AM -0800, Guenter Roeck wrote:
> > On Wed, 2012-02-01 at 16:30 -0500, Alan Cox wrote:
> 
> > > > My first RFC patches set has every driver separated. As they are
> > > > really specific to the platform, people seem to agree with
> > > > grouping them, mainly because they won't be shared. I changed
> > > > that in the following patches sets, and X86 maintainers seemed
> > > > to be ok with that.
> 
> > It looks like things are going back and forth a bit. If I were
> > Vivien, I would be a bit frustrated by now and be close to giving
> > up (Vivien, I really commend you for your patience).
> 
> OTOH I just looked back and saw that some of the review comments I
> just made were also made against the first version of this driver I
> noticed (v2) but appear to have been ignored, the request tracking
> stands out.
> 
> > Is there a written guideline or policy people can look and point to
> > if/when something like this comes up ? Otherwise we may have the
> > LED/GPIO/xxx maintainers point one way, the X86 maintainers point
> > the other way, and thus may have reached a complete deadlock.
> 
> I'm not sure I'm seeing much conflict here TBH, looking at the above
> and the history I have to hand I'd say it's reading like the x86
> maintainers aren't fussed either way and the people doing kernel wide
> work on things like this prefer getting stuff integrated into the
> frameworks.

Thanks for the comments. I'll then move the GPIO driver back to
drivers/gpio and fix what Mark pointed out.

I Cc Richard Purdie, to have his maintainer view on the platform LED
declaration. Is it ok in the ts5500_led.c platform file, or should it
better be moved into drivers/leds/leds-ts5500.c, or maybe directly
declared in the main ts5500.c platform code?

Thanks,
Vivien.

-- 
Vivien Didelot
Savoir-faire Linux Inc.
Tel: (514) 276-5468 #149
