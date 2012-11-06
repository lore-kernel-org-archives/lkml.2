Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab2KFNGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:06:42 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50217 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab2KFNGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:06:40 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>,
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
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 3/8] ARM: OMAP: AM33xx hwmod: Add parent-child
 relationship for PWM subsystem
Thread-Topic: [PATCH 3/8] ARM: OMAP: AM33xx hwmod: Add parent-child
 relationship for PWM subsystem
Thread-Index: AQHNuzgM2/eEkgdCM0a7va/En/vrrpfcOuSAgACM72A=
Date: Tue, 6 Nov 2012 13:06:21 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EB64313@DBDE01.ent.ti.com>
References: <1352106749-9437-1-git-send-email-avinashphilip@ti.com>
 <1352106749-9437-4-git-send-email-avinashphilip@ti.com>
 <B5906170F1614E41A8A28DE3B8D121433EC049D9@DBDE01.ent.ti.com>
In-Reply-To: <B5906170F1614E41A8A28DE3B8D121433EC049D9@DBDE01.ent.ti.com>
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

On Tue, Nov 06, 2012 at 15:39:11, Bedia, Vaibhav wrote:
> On Mon, Nov 05, 2012 at 14:42:24, Philip, Avinash wrote:
> [...]
> 
> > +
> > +static struct omap_hwmod_ocp_if am33xx_epwmss0__ecap0 = {
> > +	.master		= &am33xx_epwmss0_hwmod,
> > +	.slave		= &am33xx_ecap0_hwmod,
> > +	.clk		= "l4ls_gclk",
> > +	.addr		= am33xx_ecap0_addr_space,
> > +	.user		= OCP_USER_MPU,
> > +};
> 
> Noticed this in another patch which is quite similar so commenting here
> again. Is the user field required if you are just creating a parent-child
> relationship here?
> 

I think user field is not related to parent-child nodes, it defines the initiator to interact with hwmod

Copy-pasted from "arch/arm/plat-omap/include/plat/omap_hwmod.h"

"indicate the initiators that use this interface to interact with the 
hwmod"

And in this case, its MPU is the initiator to interact with this interface.


Thanks,
Vaibhav
> Regards,
> Vaibhav 
> 
> 

