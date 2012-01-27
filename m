Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab2A0RjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:39:13 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2769 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2A0RjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:39:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 27 Jan 2012 09:38:49 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Tony Lindgren <tony@atomide.com>, Simon Glass <sjg@chromium.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>, Dong Aisheng <dongas86@gmail.com>,
        "Shawn Guo (shawn.guo@linaro.org)" <shawn.guo@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 27 Jan 2012 09:38:47 -0800
Subject: RE: Pinmux bindings proposal V2
Thread-Topic: Pinmux bindings proposal V2
Thread-Index: AczcmluDG1Pve/zoRAabNjsUBaUoRQAf9XAw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E123E59@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <CAPnjgZ3Xhebn1x1A-Vdy78DWbDd=cp0AK6tL-R1SRzS4GdF97g@mail.gmail.com>
 <20120127022111.GK29812@atomide.com>
In-Reply-To: <20120127022111.GK29812@atomide.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Lindgren wrote at Thursday, January 26, 2012 7:21 PM:
> * Simon Glass <sjg@chromium.org> [120126 09:11]:
> >
> > On Fri, Jan 20, 2012 at 2:22 PM, Stephen Warren <swarren@nvidia.com> wrote:
> >
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
> I agree. This is something that most pinmux/pinconf drivers need to
> implement, so it's best done in a generic way.

Yet:

* Some controllers don't have a "drive strength" property
* Others have a single "drive strength" property
* Others configure drive strength separately for driving a signal high
or low.

Hence, representing this in a generic fashion doesn't seem possible to
me, except through (key, value) pairs where the individual drivers or
bindings define what the keys are.

-- 
nvpublic

