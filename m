Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab2AZJY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:24:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45603 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2AZJYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:24:23 -0500
Date: Thu, 26 Jan 2012 17:36:11 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Pinmux bindings proposal V2
Message-ID: <20120126093610.GD2287@S2101-09.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <20120123210052.GS22818@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123210052.GS22818@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Mon, Jan 23, 2012 at 01:00:52PM -0800, Tony Lindgren wrote:
...
> So to summarize: I suggest we'll just stick to basics to get the system
> booting and devices working using device tree. In most cases the device
> drivers should be able to configure the suspend and off states in a generic
> way using pinctrl API. Everything else, like debugging, we can probably
> do with userspace tools.
> 
> This would mean just using a minimal subset of your binding, probably
> very close to what you originally suggested.
> 
IMHO, as a generic device tree binding, it should be able to cope with
different use cases.  It's really free for you to use the minimal
subset of the binding as your need, but we should not make the binding
design just be that minimal subset to force that everyone else can
only use the minimal subset.

-- 
Regards,
Shawn
