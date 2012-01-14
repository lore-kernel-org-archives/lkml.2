Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab2ANA7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 19:59:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41682 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2ANA7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 19:59:37 -0500
Date: Sat, 14 Jan 2012 09:10:33 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng <dongas86@gmail.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Message-ID: <20120114011029.GC1810@S2101-09.ap.freescale.net>
References: <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788508AC65@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE3A76A@HQMAIL01.nvidia.com>
 <CAA+hA=RCmctmQJU4-k7YhzQDMi8KuyisBqOFhuMd3RV4_E=gCA@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17801D1FAB@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D1FAB@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 10:33:21AM -0800, Stephen Warren wrote:
> So of_device_alloc(), which is called by of_platform_populate() for each
> device, already parses basic DT content such as reg and interrupts, and
> converts them to Linux resources. I'd consider parsing any pinmux properties
> and registering them with the pinctrl subsystem to be of a similar nature,
> so adding some code to of_device_alloc() that calls a core pinmux function
> to parse the DT node seems reasonable to me.
> 
I hardly believe that device tree maintainers would agree here.
Grant, Rob?

-- 
Regards,
Shawn
