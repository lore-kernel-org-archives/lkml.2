Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab2KWKf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:35:29 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56697 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab2KWKf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:35:26 -0500
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
Subject: RE: [PATCH v4 01/11] PWMSS: Add PWM Subsystem driver for
 parent<->child relationship
Thread-Topic: [PATCH v4 01/11] PWMSS: Add PWM Subsystem driver for
 parent<->child relationship
Thread-Index: AQHNx+neyFM1R4qRZ02u6klIrgU4Z5f1+QcAgAEhQrA=
Date: Fri, 23 Nov 2012 10:34:01 +0000
Deferred-Delivery: Fri, 23 Nov 2012 10:33:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9EE987@DBDE01.ent.ti.com>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-2-git-send-email-avinashphilip@ti.com>
 <20121122204704.GA16716@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121122204704.GA16716@avionic-0098.adnet.avionic-design.de>
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

On Fri, Nov 23, 2012 at 02:17:04, Thierry Reding wrote:
> On Wed, Nov 21, 2012 at 06:40:58PM +0530, Philip, Avinash wrote:
> [...]
> > +static const struct of_device_id pwmss_of_match[] = {
> > +	{
> > +		.compatible	= "ti,am33xx-pwmss",
> > +	},
> 
> For consistency with other drivers this should be all on one line.

Ok I will correct it.

> 
> > +static const struct dev_pm_ops pwmss_pm_ops = {
> > +	SET_SYSTEM_SLEEP_PM_OPS(pwmss_suspend, pwmss_resume)
> > +};
> 
> This could be even shorter:
> 
> static SIMPLE_DEV_PM_OPS(pwmss_pm_ops, pwmss_suspend, pwmss_resume);

Ok I will correct it.

Thanks
Avinash

> 
> Thierry
> 

