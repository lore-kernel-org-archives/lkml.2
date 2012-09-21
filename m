Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2IUEwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 00:52:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41918 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2IUEwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 00:52:53 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [PATCH] pwm_backlight: Add device tree support for Low
 Threshold Brightness
Thread-Topic: [PATCH] pwm_backlight: Add device tree support for Low
 Threshold Brightness
Thread-Index: AQHNamJlzd+YdPIDHUOkbO/Lje1a5JdBEF2AgACOp9CAT5RugIADXEeg
Date: Fri, 21 Sep 2012 04:51:19 +0000
Deferred-Delivery: Fri, 21 Sep 2012 04:51:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9A676E@DBDE01.ent.ti.com>
References: <1343219042-4371-1-git-send-email-avinashphilip@ti.com>
 <20120730065805.GB15245@avionic-0098.mockup.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E97C4C9@DBDE01.ent.ti.com>
 <20120919064425.GA1506@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120919064425.GA1506@avionic-0098.mockup.avionic-design.de>
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

On Wed, Sep 19, 2012 at 12:14:25, Thierry Reding wrote:
> On Wed, Aug 01, 2012 at 06:51:21AM +0000, Philip, Avinash wrote:
> > On Mon, Jul 30, 2012 at 12:28:05, Thierry Reding wrote:
> > > On Wed, Jul 25, 2012 at 05:54:02PM +0530, Philip, Avinash wrote:
> > > > Low Threshold Brightness should be configured to have a linear relation
> > > > in brightness scale. This patch adds device tree support for low
> > > > threshold brightness as optional one for pwm_backlight.
> > > 
> > > I think this should be more explicit as to why this is required, perhaps
> > > something like this:
> > > 
> > > 	Some backlights perform poorly when driven by a PWM with a short
> > > 	duty-cycle. For such devices, the low threshold can be used to
> > > 	specify a lower bound for the duty-cycle and should be chosen to
> > > 	exclude the problematic range.
> > > 
> > > 	This patch adds support for an optional low-threshold-brightness
> > > 	property.
[snip]
> 
> I think you never sent an updated patch or maybe I missed it. But I
> noticed that this patch has now ended up in Andrew's tree without the
> comments being addressed. Can you please follow up?

I will send a revised patch.

Thanks
Avinash

