Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab1GSXPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 19:15:50 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6424 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab1GSXPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 19:15:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 19 Jul 2011 16:15:38 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Andrew Chew <AChew@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "olof@lixom.net" <olof@lixom.net>,
        Dan Willemsen <dwillemsen@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 19 Jul 2011 16:15:38 -0700
Subject: RE: [PATCH 2/3] dt: tegra20: Add ehci host controller nodes.
Thread-Topic: [PATCH 2/3] dt: tegra20: Add ehci host controller nodes.
Thread-Index: AcxGZjibySVyNvOjT6ieM+DaizC9YgAAOLuAAACYjNA=
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049EBDED36@HQMAIL01.nvidia.com>
References: <1311115617-9697-1-git-send-email-achew@nvidia.com>
 <1311115617-9697-2-git-send-email-achew@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF049EBDED27@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049EBDED27@HQMAIL01.nvidia.com>
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

Stephen Warren wrote at Tuesday, July 19, 2011 5:00 PM:
> achew@nvidia.com wrote at Tuesday, July 19, 2011 4:47 PM:
> > From: Andrew Chew <achew@nvidia.com>
> >
> > These values were derived from various headers in arch/arm/mach-tegra.
...
> > diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
> > index 83fedf3..a0353bb 100644
> > --- a/arch/arm/boot/dts/tegra20.dtsi
> > +++ b/arch/arm/boot/dts/tegra20.dtsi
> > @@ -160,5 +160,57 @@
> >  		interrupts = < 63 >;
> >  		status = "disabled";
> >  	};
> > +
> > +	ehci@c5000000 {
> > +		#address-cells = <1>;
> > +		#size-cells = <0>;
> > +		compatible = "nvidia,tegra20-ehci";
> > +		reg = <0xc5000000 0x4000>;
> > +		interrupts = < 52 >;
> > +		mode = < 1 >;
> > +		power_down_on_bus_suspend;
> > +		type = "utmi";
> > +		hssync_start_delay = < 0 >;
> > +		idle_wait_delay = < 17 >;
> > +		elastic_limit = < 16 >;
> > +		term_range_adj = < 6 >;
> > +		xcvr_setup = < 15 >;
> > +		xcvr_lsfslew = < 2 >;
> > +		xcvr_lsrslew = < 2 >;
> > +		status = "disabled";
> 
> In the latest devicetree/test, tegra20.dtsi doesn't specify status for
> any nodes, but leaves everything enabled. Instead, board-specific files
> disable any unused devices.

Andrew pointed out that isn't actually true right now. However, Grant
did state that he was *going* to make Tegra work that way, so the
comment basically still stands.

-- 
nvpublic

