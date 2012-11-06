Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab2KFGqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 01:46:32 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59128 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab2KFGqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 01:46:30 -0500
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: "Philip, Avinash" <avinashphilip@ti.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "paul@pwsan.com" <paul@pwsan.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>
CC: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 8/8] ARM: dts: AM33XX: Add PWM backlight DT data to
 am335x-evm
Thread-Topic: [PATCH 8/8] ARM: dts: AM33XX: Add PWM backlight DT data to
 am335x-evm
Thread-Index: AQHNuzkRkxvyfx1KxUOdbJr2TC1wd5fcXbHQ
Date: Tue, 6 Nov 2012 06:46:13 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433EC04488@DBDE01.ent.ti.com>
References: <1352106749-9437-1-git-send-email-avinashphilip@ti.com>
 <1352106749-9437-9-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1352106749-9437-9-git-send-email-avinashphilip@ti.com>
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

On Mon, Nov 05, 2012 at 14:42:29, Philip, Avinash wrote:
[...]

> +	am33xx_pinmux: pinmux@44e10800 {
> +		ecap0_pins: backlight_pins {
> +			pinctrl-single,pins = <
> +				0x164 0x0	/* eCAP0_in_PWM0_out.eCAP0_in_PWM0_out MODE0 */
> +			>;
> +		};
> +	};
> +
Ok I see the pinctrl entries here. Shouldn't this be done before
the change in the driver?

Regards.
Vaibhav
