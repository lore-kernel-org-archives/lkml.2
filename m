Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2A0RgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:36:19 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2340 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2A0RgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:36:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 27 Jan 2012 09:36:09 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Tony Lindgren <tony@atomide.com>
CC: "Shawn Guo (shawn.guo@linaro.org)" <shawn.guo@linaro.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 27 Jan 2012 09:36:08 -0800
Subject: RE: Pinmux bindings proposal V2
Thread-Topic: Pinmux bindings proposal V2
Thread-Index: AczcmJaPTHcn6VqPQ4yKEUlZTHNlOgAgOP3g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E123E57@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <20120123210052.GS22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81C0D@HQMAIL01.nvidia.com>
 <20120124012038.GT22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81EDB@HQMAIL01.nvidia.com>
 <20120125000407.GU22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB82433@HQMAIL01.nvidia.com>
 <20120127020832.GJ29812@atomide.com>
In-Reply-To: <20120127020832.GJ29812@atomide.com>
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

Tony Lindgren wrote at Thursday, January 26, 2012 7:09 PM:
...
> I don't think we should try to pass the different possible states from
> device tree. The pinmux/pinconf driver should know how to deal with that,

Somehow, the pinctrl driver needs to know how to implement each state. In 
general, I believe this will be board-specific.

Do you disagree with this assertion?

If the data is board-specific, I don't see how it can be represented
anywhere but the device tree.

> and the driver using the mux should be able to communicate what it wants
> to the pinmux/pinconf driver. If people really want to be able to pass
> alternative mux states from device tree, they should be standard bindings
> for things like active/idle/suspend/off.

As I've mentioned before, people have asked for driver-specific states to
handle the case where e.g. drive strength must be adjusted based on clock
rates of the interface. Again, I believe that's board-specific data since
the actual values to use may be derived during board calibration, not
SoC design.

Do you disagree that this data may be board specific?

--
nvpublic

