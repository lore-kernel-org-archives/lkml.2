Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab2KLLDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:03:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49983 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab2KLLD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:03:28 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
Date: Mon, 12 Nov 2012 12:03:23 +0100
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@ti.com>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>,
        devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 7BIT
Message-Id: <11727BE5-7173-4383-BD0E-751EFD093706@dominion.thruhere.net>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 5 nov. 2012, om 21:40 heeft Grant Likely <grant.likely@secretlab.ca> het volgende geschreven:

> Hey folks,
> 
> As promised, here is my early draft to try and capture what device
> tree overlays need to do and how to get there. Comments and
> suggestions greatly appreciated.
> 
> Device Tree Overlay Feature
> 
> Purpose
> =======
> Sometimes it is not convenient to describe an entire system with a
> single FDT. For example, processor modules that are plugged into one or
> more modules (a la the BeagleBone), or systems with an FPGA peripheral
> that is programmed after the system is booted.
> 
> For these cases it is proposed to implement an overlay feature for the
> so that the initial device tree data can be modified by userspace at
> runtime by loading additional overlay FDTs that amend the original data.
> 
> User Stories
> ============
> Note - These are potential use cases, but just because it is listed here
> doesn't mean it is important. I just want to thoroughly think through the
> implications before making design decisions.

I think the beaglebone use cases cover it as well, but it deserves a seperate mention: SOMs. Gumstix is a good example of those, their website has a list of the different expansionboards they sell so we can see if we missed a use case somewhere.
Their expansionboards have an EEPROM to ID them, just like the beagleboard classic/xM expansionboards, but I don't know if all 3rd party vendors honour that standard. I know the Ettus USRP E-100 on my desk has it.

regards,

Koen