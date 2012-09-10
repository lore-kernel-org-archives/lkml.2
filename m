Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab2IJHrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:47:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50555 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab2IJHrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:47:04 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Porter, Matt" <mporter@ti.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH RESEND] arm/dts: AM33XX: Add SPI device tree data
Thread-Topic: [PATCH RESEND] arm/dts: AM33XX: Add SPI device tree data
Thread-Index: AQHNi//SwOt9H6nOBECKV0p8upzVLpd+fRAAgASc+fA=
Date: Mon, 10 Sep 2012 07:45:48 +0000
Deferred-Delivery: Mon, 10 Sep 2012 07:45:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E99E663@DBDE01.ent.ti.com>
References: <1346914815-860-1-git-send-email-avinashphilip@ti.com>
 <20120907125936.GH27758@beef>
In-Reply-To: <20120907125936.GH27758@beef>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 18:29:36, Porter, Matt wrote:
> On Thu, Sep 06, 2012 at 12:30:15PM +0530, Philip, Avinash wrote:
> > Add McSPI data node to AM33XX device tree file. The McSPI module (and so
> > as the driver) is reused from OMAP4.
> > 
> > Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> > ---
> > Resenting patch because ARM & OMAP mailing list was not copied.
> > 
> > :100644 100644 bb31bff... 6b469bd... M	arch/arm/boot/dts/am33xx.dtsi
> >  arch/arm/boot/dts/am33xx.dtsi |   25 +++++++++++++++++++++++++
> >  1 files changed, 25 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> > index bb31bff..6b469bd 100644
> > --- a/arch/arm/boot/dts/am33xx.dtsi
> > +++ b/arch/arm/boot/dts/am33xx.dtsi
> > @@ -210,5 +210,30 @@
> >  			interrupt-parent = <&intc>;
> >  			interrupts = <91>;
> >  		};
> > +
> > +		spi0: spi@48030000 {
> > +			compatible = "ti,omap4-mcspi";
> > +			#address-cells = <1>;
> > +			#size-cells = <0>;
> > +			reg = <0x4830000 0x400>;
> 
> Please fix this typo, should be 0x48030000.
> 
> With the typo fixed, it's working on bone for me:

Thanks for review and testing.
I didn't notice the issue as currently hwmod fills up reg 
resource data & hence I missed it.

I will correct & re-send.

Thanks
Avinash

> 
> Tested-by: Matt Porter <mporter@ti.com>
> 
> -Matt
> 

