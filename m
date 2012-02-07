Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab2BGBHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 20:07:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50058 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab2BGBHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 20:07:15 -0500
MIME-Version: 1.0
In-Reply-To: <20120206235733.GY1426@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com>
	<CACRpkdahin4srDh7dphgvq306gjz7CGP=h4dVkUY+w0z0wpXRQ@mail.gmail.com>
	<4F2F6AE2.1040504@nvidia.com>
	<CACRpkdbtTPSoX1x4aBtNVGZ2Qex9t77D09V9JgON_jfShQdx6w@mail.gmail.com>
	<20120206190315.GU1426@atomide.com>
	<CACRpkdZthbejmTqRJAWHb8jU-p8LPT_+zj_CY1q0voMb4FKz2Q@mail.gmail.com>
	<20120206210456.GV1426@atomide.com>
	<CACRpkdYrbD3PpJ3wb69yb3Ya8SeZJnPpgJdtttjWTkS5xsD-4g@mail.gmail.com>
	<20120206235733.GY1426@atomide.com>
Date: Tue, 7 Feb 2012 02:07:14 +0100
Message-ID: <CACRpkdZVvSOOUvobiiahHdyP8pNcX65QRLeoGALBB6t++Ga5vg@mail.gmail.com>
Subject: Re: An extremely simplified pinctrl bindings proposal
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
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
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 12:57 AM, Tony Lindgren <tony@atomide.com> wrote:

>> I'm not sure if I'm following completely, if this is inside the devicetree-based
>> driver file, would it work to just add a struct dentry * to the
>> pinctrl_desc where you put a per-driver file?
>
> I was thinking generic debufs entries for all drivers.

OK.

>> Or maybe add extern void pinctrl_add_debugfs(struct dentry *) that adds
>> a new file to the existing per-driver directory through the core and then
>> have this add that file?
>
> Sounds like you've thought it further than me already :)
>
> Maybe that's the way to go to solve the one register for
> multiple pins issue.
>
>> Or did you mean that the core.c should be register-aware?
>
> I was just thinking string name ignoring core.c, so that would
> be the pinctrl_add_debugfs() option then. Do you see problems
> with this approach?

No probs, something like that you call any number of times
after registering the core device should work fine I guess.

Yours,
Linus Walleij
