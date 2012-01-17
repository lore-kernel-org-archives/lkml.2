Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2AQTf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:35:58 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16526 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab2AQTf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:35:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 17 Jan 2012 11:35:51 -0800
From: Stephen Warren <swarren@nvidia.com>
To: "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
CC: Dong Aisheng <dongas86@gmail.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        "Shawn Guo (shawn.guo@linaro.org)" <shawn.guo@linaro.org>
Date: Tue, 17 Jan 2012 11:35:50 -0800
Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Topic: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Index: AczSV8oRQaMVNJmbRC6br/RpiSxt+gC9zzpw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17801D22FB@HQMAIL01.nvidia.com>
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
 <20120114011029.GC1810@S2101-09.ap.freescale.net>
In-Reply-To: <20120114011029.GC1810@S2101-09.ap.freescale.net>
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

Shawn Guo wrote at Friday, January 13, 2012 6:11 PM:
> On Fri, Jan 13, 2012 at 10:33:21AM -0800, Stephen Warren wrote:
> > So of_device_alloc(), which is called by of_platform_populate() for each
> > device, already parses basic DT content such as reg and interrupts, and
> > converts them to Linux resources. I'd consider parsing any pinmux properties
> > and registering them with the pinctrl subsystem to be of a similar nature,
> > so adding some code to of_device_alloc() that calls a core pinmux function
> > to parse the DT node seems reasonable to me.
>
> I hardly believe that device tree maintainers would agree here.
> Grant, Rob?

I'm explicitly putting Grant and Rob on the To line here to make this
question stand out to them.

-- 
nvpublic

