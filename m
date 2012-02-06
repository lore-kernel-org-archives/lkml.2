Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab2BFXPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 18:15:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61754 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab2BFXPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 18:15:31 -0500
MIME-Version: 1.0
In-Reply-To: <20120206210456.GV1426@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com>
	<CACRpkdahin4srDh7dphgvq306gjz7CGP=h4dVkUY+w0z0wpXRQ@mail.gmail.com>
	<4F2F6AE2.1040504@nvidia.com>
	<CACRpkdbtTPSoX1x4aBtNVGZ2Qex9t77D09V9JgON_jfShQdx6w@mail.gmail.com>
	<20120206190315.GU1426@atomide.com>
	<CACRpkdZthbejmTqRJAWHb8jU-p8LPT_+zj_CY1q0voMb4FKz2Q@mail.gmail.com>
	<20120206210456.GV1426@atomide.com>
Date: Tue, 7 Feb 2012 00:15:30 +0100
Message-ID: <CACRpkdYrbD3PpJ3wb69yb3Ya8SeZJnPpgJdtttjWTkS5xsD-4g@mail.gmail.com>
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

On Mon, Feb 6, 2012 at 10:04 PM, Tony Lindgren <tony@atomide.com> wrote:

>> I actually had something like unnamed pins in the early patches
>> to register a bunch of anonymous pins ranges, so why not bring
>> it back in.
>
> Yeah it seems that the mux registers should be listed, it might
> require a little bit of thinking for cases where one register
> controls multiple pins. So maybe we need just a new entry for
> mux registers?

I'm not sure if I'm following completely, if this is inside the devicetree-based
driver file, would it work to just add a struct dentry * to the
pinctrl_desc where you put a per-driver file?

Or maybe add extern void pinctrl_add_debugfs(struct dentry *) that adds
a new file to the existing per-driver directory through the core and then
have this add that file?

Or did you mean that the core.c should be register-aware?

Yours,
Linus Walleij
