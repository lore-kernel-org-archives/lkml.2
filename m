Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964820Ab2KEXWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:22:31 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:25651 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754326Ab2KEXW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:22:27 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/x7nAouzc0Knr7ydG3ZB/Y
Date: Mon, 5 Nov 2012 15:22:19 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tabi Timur-B04825 <B04825@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
Message-ID: <20121105232218.GA8284@atomide.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <6AE080B68D46FC4BA2D2769E68D765B708174B7D@039-SN2MPN1-023.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6AE080B68D46FC4BA2D2769E68D765B708174B7D@039-SN2MPN1-023.039d.mgd.msft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Tabi Timur-B04825 <B04825@freescale.com> [121105 13:42]:
> On Mon, Nov 5, 2012 at 2:40 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> > Jane is building custom BeagleBone expansion boards called 'capes'. She
> > can boot the system with a stock BeagleBoard device tree, but additional
> > data is needed before a cape can be used. She could replace the FDT file
> > used by U-Boot with one that contains the extra data, but she uses the
> > same Linux system image regardless of the cape, and it is inconvenient
> > to have to select a different device tree at boot time depending on the
> > cape.
> 
> What's wrong with having the boot loader detect the presence of the
> Cape and update the device tree accordingly?  We do this all the time
> in U-Boot.  Doing stuff like reading EEPROMs and testing for the
> presence of hardware is easier in U-Boot than in Linux.
> 
> For configurations that can be determined by the boot loader, I'm not
> sure overlays are practical.

I guess the beaglebone capes could be stackable and hotpluggable if
handled carefully enough.

Regards,

Tony
