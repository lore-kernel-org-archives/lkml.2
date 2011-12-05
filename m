Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab1LEVme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:42:34 -0500
Received: from 20.mo1.mail-out.ovh.net ([188.165.45.168]:44160 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932409Ab1LEVmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:42:33 -0500
Date: Mon, 5 Dec 2011 16:40:11 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Igor Grinberg <grinberg@compulab.co.il>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH 1/2] gpiolib: introduce gpio_set_pullup
Message-ID: <20111205154011.GE9192@game.jcrosoft.org>
References: <1322230120-14120-1-git-send-email-plagnioj@jcrosoft.com>
 <20111125153409.GA4975@sirena.org.uk>
 <4ED2045E.7010206@compulab.co.il>
 <20111129023708.GN15008@game.jcrosoft.org>
 <74CDBE0F657A3D45AFBB94109FB122FF174FDAFAC8@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174FDAFAC8@HQMAIL01.nvidia.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 16623067701439933323
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedruddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpeen
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedruddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpeen
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:51 Tue 29 Nov     , Stephen Warren wrote:
> Jean-Christophe PLAGNIOL-VILLARD wrote at Monday, November 28, 2011 7:37 PM:
> > On 11:35 Sun 27 Nov     , Igor Grinberg wrote:
> > > On 11/25/11 17:34, Mark Brown wrote:
> > > > On Fri, Nov 25, 2011 at 03:08:39PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > >
> > > >> +/**
> > > >> + * gpio_set_pullup - sets @pullup for a @gpio
> > > >> + * @gpio: the gpio to set pullup
> > > >> + * @pullup: pullup level
> > > >> + */
> > > >> +int gpio_set_pullup(unsigned gpio, unsigned pullup)
> > > >
> > > > This has some overlap with the pinmux subsystem.  We also need
> > > > documentation of what the pullup values mean.
> > yes and no
> > 
> > as some gpio IP (only gpio i2c extender as example ) have it too
> > so you can not use the pinmux for this
> 
> Why not?
> 
> I believe the pinctrl subsystem should be applicable to any chip, be it
> the main SoC/CPU in the system, or any other chip. We don't currently
> have any non-SoC drivers, but that's just because nobody has written them
> yet; there's no technical reason they couldn't exist.
> 
sorry pinmux for gpio specific management i's overkill

Best Regards,
J.
