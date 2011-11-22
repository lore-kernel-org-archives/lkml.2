Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab1KVAky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:40:54 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15737 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab1KVAkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:40:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 21 Nov 2011 16:40:51 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Denis Kuzmenko <linux@solonet.org.ua>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Wolfram Sang <w.sang@pengutronix.de>
Date: Mon, 21 Nov 2011 16:40:49 -0800
Subject: RE: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
Thread-Topic: [PATCH] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS driver use
 gpiolib
Thread-Index: AcyorVpkOakfxmnbT0CNUs7oYhJ3egAAeTCw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174F08C2F4@HQMAIL01.nvidia.com>
References: <4EC572E1.1020209@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74E87@HQMAIL01.nvidia.com>
 <4EC6C785.5010801@solonet.org.ua> <4EC6D1D5.9060808@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74FAD@HQMAIL01.nvidia.com>
 <4EC6DD8F.9070904@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74FE6@HQMAIL01.nvidia.com>
 <4EC6E75E.2080200@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF174F08C135@HQMAIL01.nvidia.com>
 <4ECAA894.4050500@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF174F08C246@HQMAIL01.nvidia.com>
 <4ECAD613.3030605@solonet.org.ua>
 <74CDBE0F657A3D45AFBB94109FB122FF174F08C2B4@HQMAIL01.nvidia.com>
 <4ECAECA6.7090109@solonet.org.ua>
In-Reply-To: <4ECAECA6.7090109@solonet.org.ua>
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

Denis Kuzmenko wrote at Monday, November 21, 2011 5:28 PM:
> On 11/22/2011 01:39 AM, Stephen Warren wrote:
...
> > Anyway, I guess that means that your patch V1 is at least a pure conversion
> > of the code from custom functions to gpiolib, even if what it was and still
> > is doing doesn't make much sense to me.
> >
> 
> So what do you suggest? Leave original behavior?
> I'd like to remove pull-related actions at all considering:
>  - power consumption
>  - we are both not able to find any sense in that code
>  - s3c2410_gpio_pullup looks like deprecated
>  - can't imagine situation where this change will break functionality
> (of course when this code used to drive actually LED and not something else)

Well, if that works for you, that makes sense to me too.

-- 
nvpublic

