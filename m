Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2BFPhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:37:53 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:32982 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab2BFPhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:37:52 -0500
Date: Mon, 6 Feb 2012 15:37:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v5 2/5] x86/platform: (TS-5500) add GPIO support
Message-ID: <20120206153742.GE10173@sirena.org.uk>
References: <1328130344-18836-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1328130344-18836-3-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20120201213025.53d820d2@pyramind.ukuu.org.uk>
 <1328211236.2261.152.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328211236.2261.152.camel@groeck-laptop>
X-Cookie: To err is human, to forgive unusual.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 11:33:56AM -0800, Guenter Roeck wrote:
> On Wed, 2012-02-01 at 16:30 -0500, Alan Cox wrote:

> > > My first RFC patches set has every driver separated. As they are
> > > really specific to the platform, people seem to agree with grouping
> > > them, mainly because they won't be shared. I changed that in the
> > > following patches sets, and X86 maintainers seemed to be ok with
> > > that.

> It looks like things are going back and forth a bit. If I were Vivien, I
> would be a bit frustrated by now and be close to giving up (Vivien, I
> really commend you for your patience).

OTOH I just looked back and saw that some of the review comments I just
made were also made against the first version of this driver I noticed
(v2) but appear to have been ignored, the request tracking stands out.

> Is there a written guideline or policy people can look and point to
> if/when something like this comes up ? Otherwise we may have the
> LED/GPIO/xxx maintainers point one way, the X86 maintainers point the
> other way, and thus may have reached a complete deadlock.

I'm not sure I'm seeing much conflict here TBH, looking at the above and
the history I have to hand I'd say it's reading like the x86 maintainers
aren't fussed either way and the people doing kernel wide work on things
like this prefer getting stuff integrated into the frameworks.
