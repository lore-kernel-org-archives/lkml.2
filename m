Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2BFT4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:56:49 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50291 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab2BFT4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:56:48 -0500
MIME-Version: 1.0
In-Reply-To: <20120206190315.GU1426@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com>
	<CACRpkdahin4srDh7dphgvq306gjz7CGP=h4dVkUY+w0z0wpXRQ@mail.gmail.com>
	<4F2F6AE2.1040504@nvidia.com>
	<CACRpkdbtTPSoX1x4aBtNVGZ2Qex9t77D09V9JgON_jfShQdx6w@mail.gmail.com>
	<20120206190315.GU1426@atomide.com>
Date: Mon, 6 Feb 2012 20:56:47 +0100
Message-ID: <CACRpkdZthbejmTqRJAWHb8jU-p8LPT_+zj_CY1q0voMb4FKz2Q@mail.gmail.com>
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

On Mon, Feb 6, 2012 at 8:03 PM, Tony Lindgren <tony@atomide.com> wrote:

> So far the only
> change needed for pinctrl drivers containing no data is that
> we should make the string names optional and structure debugfs
> around the physical register addresses instead. I'm basically
> just setting the mux register physcal address as the pin name
> for now to work around this.

OK please make a patch to do it really optional in the core if
you find the time, it seems like a good change anyway, because
it will make it possible to reduce some current pin name lists
quite easily.

If you need to change the layout of debugfs just do it.

I actually had something like unnamed pins in the early patches
to register a bunch of anonymous pins ranges, so why not bring
it back in.

Thanks,
Linus Walleij
