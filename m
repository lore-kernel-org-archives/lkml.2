Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab2A3CTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 21:19:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43873 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab2A3CTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 21:19:43 -0500
Date: Mon, 30 Jan 2012 10:31:50 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Simon Glass <sjg@chromium.org>, Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>, Dong Aisheng <dongas86@gmail.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Pinmux bindings proposal V2
Message-ID: <20120130023148.GC10470@S2101-09.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <CAPnjgZ3Xhebn1x1A-Vdy78DWbDd=cp0AK6tL-R1SRzS4GdF97g@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178E123E54@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178E123E54@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 09:29:50AM -0800, Stephen Warren wrote:
> Simon Glass wrote at Thursday, January 26, 2012 10:42 AM:
...
> > 1. It doesn't seem to make full use of the device tree format. For example,
> > 
> >    <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > 
> > would be better as something like
> > 
> >     drive-strength = <5>;
> > 
> > if we could arrange it. It also reduces the need for these
> > TEGRA_PMX_CONF_DRIVE_STRENGTH defines.
> 
> Yes I can see the argument this is more readable.
> 
> However, it:
> 
> * Requires a lot of string handling when parsing the device tree, since
>   you have to search for lots of individual properties by name.
> 
> * Bloats the device tree quite a bit due to representing each parameter
>   as a separate property, with a longish name, rather than a single u32
>   cell in the config property I proposed.
> 
It bloats device tree more due to the proposal needs to represent every
single muxable entity (pin for imx case) as a node to accommodate the
properties like 'drive-strength' here.

-- 
Regards,
Shawn
