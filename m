Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2KWKgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:36:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51511 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab2KWKgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:36:21 -0500
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
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: RE: [PATCH v4 06/11] pwm: pwm-tiehrpwm: Add device-tree binding
 support for EHRPWM driver
Thread-Topic: [PATCH v4 06/11] pwm: pwm-tiehrpwm: Add device-tree binding
 support for EHRPWM driver
Thread-Index: AQHNx+oGSGeB3uDE5EOv31d3ooFf/5f1/bKAgAEdIMA=
Date: Fri, 23 Nov 2012 10:35:01 +0000
Deferred-Delivery: Fri, 23 Nov 2012 10:35:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9EE9A4@DBDE01.ent.ti.com>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-7-git-send-email-avinashphilip@ti.com>
 <20121122210347.GD16716@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121122210347.GD16716@avionic-0098.adnet.avionic-design.de>
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

On Fri, Nov 23, 2012 at 02:33:47, Thierry Reding wrote:
> On Wed, Nov 21, 2012 at 06:41:03PM +0530, Philip, Avinash wrote:
> [...]
> > +static const struct of_device_id ehrpwm_of_match[] = {
> > +	{
> > +		.compatible	= "ti,am33xx-ehrpwm",
> > +	},
> 
> Same comment as for patch 4.

Ok I will correct it.

> 
> > @@ -437,16 +451,41 @@ static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
> >  		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
> >  		return ret;
> >  	}
> > -
> 
> I think this blank line actually improves readability so it can stay in.

I will add.

Thanks
Avinash

> 
> Thierry
> 

