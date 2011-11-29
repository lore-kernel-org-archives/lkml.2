Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1K2Qvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 11:51:54 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1567 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab1K2Qvx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 11:51:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 29 Nov 2011 08:51:43 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Igor Grinberg <grinberg@compulab.co.il>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 29 Nov 2011 08:51:42 -0800
Subject: RE: [PATCH 1/2] gpiolib: introduce gpio_set_pullup
Thread-Topic: [PATCH 1/2] gpiolib: introduce gpio_set_pullup
Thread-Index: AcyuQEaDpTOTsgoXTOug5hpM0vyKzQAdkNgw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174FDAFAC8@HQMAIL01.nvidia.com>
References: <1322230120-14120-1-git-send-email-plagnioj@jcrosoft.com>
 <20111125153409.GA4975@sirena.org.uk> <4ED2045E.7010206@compulab.co.il>
 <20111129023708.GN15008@game.jcrosoft.org>
In-Reply-To: <20111129023708.GN15008@game.jcrosoft.org>
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

Jean-Christophe PLAGNIOL-VILLARD wrote at Monday, November 28, 2011 7:37 PM:
> On 11:35 Sun 27 Nov     , Igor Grinberg wrote:
> > On 11/25/11 17:34, Mark Brown wrote:
> > > On Fri, Nov 25, 2011 at 03:08:39PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > >
> > >> +/**
> > >> + * gpio_set_pullup - sets @pullup for a @gpio
> > >> + * @gpio: the gpio to set pullup
> > >> + * @pullup: pullup level
> > >> + */
> > >> +int gpio_set_pullup(unsigned gpio, unsigned pullup)
> > >
> > > This has some overlap with the pinmux subsystem.  We also need
> > > documentation of what the pullup values mean.
> yes and no
> 
> as some gpio IP (only gpio i2c extender as example ) have it too
> so you can not use the pinmux for this

Why not?

I believe the pinctrl subsystem should be applicable to any chip, be it
the main SoC/CPU in the system, or any other chip. We don't currently
have any non-SoC drivers, but that's just because nobody has written them
yet; there's no technical reason they couldn't exist.

-- 
nvpublic

