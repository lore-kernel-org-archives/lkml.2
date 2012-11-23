Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab2KWKga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:36:30 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53030 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2KWKg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:36:26 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "paul@pwsan.com" <paul@pwsan.com>, "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Subject: RE: [PATCH v4 10/11] ARM: dts: AM33XX: Add PWM backlight DT data to
 am335x-evm
Thread-Topic: [PATCH v4 10/11] ARM: dts: AM33XX: Add PWM backlight DT data
 to am335x-evm
Thread-Index: AQHNx+pVrDpSL+7VQ0yEgMCWAhBYlJf1/+6AgAEx9QA=
Date: Fri, 23 Nov 2012 10:35:01 +0000
Deferred-Delivery: Fri, 23 Nov 2012 10:35:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9EE9AE@DBDE01.ent.ti.com>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-11-git-send-email-avinashphilip@ti.com>
 <20121122211147.GI16716@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121122211147.GI16716@avionic-0098.adnet.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 02:41:47, Thierry Reding wrote:
> On Wed, Nov 21, 2012 at 06:41:07PM +0530, Philip, Avinash wrote:
> [...]
> > diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
> > index 9f65f17..4178ba4 100644
> > --- a/arch/arm/boot/dts/am335x-evm.dts
> > +++ b/arch/arm/boot/dts/am335x-evm.dts
> > @@ -44,6 +44,12 @@
> >  				0x154 0x27	/* spi0_d0.gpio0_3, INPUT | MODE7 */
> >  			>;
> >  		};
> > +
> > +		ecap0_pins: backlight_pins {
> > +			pinctrl-single,pins = <
> > +				0x164 0x0	/* eCAP0_in_PWM0_out.eCAP0_in_PWM0_out MODE0 */
> > +			>;
> 
> This looks kind of funky, but I see the rest of the file uses similar
> formatting, so I guess it's okay.
> 
> > @@ -158,6 +174,13 @@
> >  			gpio-key,wakeup;
> >  		};
> >  	};
> > +
> > +	backlight {
> > +		compatible	= "pwm-backlight";
> 
> Maybe you don't want a tab between "compatible" and "=", but a space
> instead.

I will correct it.

Thanks
Avinash

> 
> Other than that, looks good:
> 
> Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> 

