Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab2GXIid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 04:38:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51766 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab2GXIiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 04:38:17 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Lars-Peter Clausen <lars@metafoo.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH] PWM: Add support for configuring polarity of PWM
Thread-Topic: [PATCH] PWM: Add support for configuring polarity of PWM
Thread-Index: AQHNZOZ2DrTfmztun0iwJK4BcEJ8xpc2NNgAgADE3ICAALHEAIAAGj2AgAAAUACAAF6+oA==
Date: Tue, 24 Jul 2012 08:37:10 +0000
Deferred-Delivery: Tue, 24 Jul 2012 08:37:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E972880@DBDE01.ent.ti.com>
References: <1342616053-7793-1-git-send-email-avinashphilip@ti.com>
 <20120723083032.GA12868@avionic-0098.mockup.avionic-design.de>
 <500DB0CB.1000600@metafoo.de>
 <20120724065121.GA30417@avionic-0098.mockup.avionic-design.de>
 <500E5BED.6050401@metafoo.de>
 <20120724082624.GA4476@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120724082624.GA4476@avionic-0098.mockup.avionic-design.de>
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

On Tue, Jul 24, 2012 at 13:56:24, Thierry Reding wrote:
> On Tue, Jul 24, 2012 at 10:25:17AM +0200, Lars-Peter Clausen wrote:
> > On 07/24/2012 08:51 AM, Thierry Reding wrote:
> > > 
> > > How about the following?
> > > 
> > > /**
> > >  * enum pwm_polarity - polarity of a PWM signal
> > >  * @PWM_POLARITY_NORMAL: a high signal for the duration of the duty-
> > >  *   cycle, followed by a low signal for the remainder of the pulse
> > >  *   period
> > >  * @PWM_POLARITY_INVERSED: a low signal for the duration of the duty-
> > >  *   cycle, followed by a high signal for the remainder of the pulse
> > >  *   period
> > >  */
> > > enum pwm_polarity {
> > > 	PWM_POLARITY_NORMAL,
> > > 	PWM_POLARITY_INVERSED,
> > > };
> > > 
> > 
> > Looks fine :)
> 
> Philip: can you fold this into your patch?

Sure. I will add.

Thanks
Avinash

> 
> Thierry
> 

