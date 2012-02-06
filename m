Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2BFT0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:26:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48567 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2BFT0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:26:52 -0500
MIME-Version: 1.0
In-Reply-To: <4F302474.1020701@firmworks.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com>
	<4F302474.1020701@firmworks.com>
Date: Mon, 6 Feb 2012 20:26:52 +0100
Message-ID: <CACRpkdYt-L+an5DTdYkS5Hi+18-rszAt7hXwZNUNVK-d0UaCWA@mail.gmail.com>
Subject: Re: An extremely simplified pinctrl bindings proposal
From: Linus Walleij <linus.walleij@linaro.org>
To: Mitch Bradley <wmb@firmworks.com>
Cc: Stephen Warren <swarren@nvidia.com>, Dong Aisheng <dongas86@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "ext Tony Lindgren (tony@atomide.com)" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 8:05 PM, Mitch Bradley <wmb@firmworks.com> wrote:

> I like the general approach of simplifying the pinctrl thing, as the
> previous approach did not appear to be converging.

pinctrl as such is upstream, widely ACKed and quite converged I'd say.

But the Device Tree bindings and general path to get data out of the drivers
and board files are not (yet) converging...

> Both Open Firmware and ACPI have addressed this general problem.  In
> addition to a numeric identifier for the register, you need to specify the
> access semantics.  It's difficult to finitely enumerate all possible cases,
> but you can get to 99.9% with a modest number of access models, and then add
> new models as needed.

This is interesting. So are you referring to a piece of Open Firmware
that is not in the Device Tree? Since this is all about device tree that
comes from OF, we might be reinventing the wheel.
Can you give some pointers?

Indeed it seems related to ACPI or some BIOS stuff on
non-embedded systems.

Yours,
Linus Walleij
