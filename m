Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1K2CkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 21:40:13 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:60328 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab1K2CkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 21:40:11 -0500
Date: Tue, 29 Nov 2011 03:37:08 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 1/2] gpiolib: introduce gpio_set_pullup
Message-ID: <20111129023708.GN15008@game.jcrosoft.org>
References: <1322230120-14120-1-git-send-email-plagnioj@jcrosoft.com>
 <20111125153409.GA4975@sirena.org.uk>
 <4ED2045E.7010206@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED2045E.7010206@compulab.co.il>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5046283383349291815
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrudejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpeen
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrudehucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:35 Sun 27 Nov     , Igor Grinberg wrote:
> On 11/25/11 17:34, Mark Brown wrote:
> > On Fri, Nov 25, 2011 at 03:08:39PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > 
> >> +/**
> >> + * gpio_set_pullup - sets @pullup for a @gpio
> >> + * @gpio: the gpio to set pullup
> >> + * @pullup: pullup level
> >> + */
> >> +int gpio_set_pullup(unsigned gpio, unsigned pullup)
> > 
> > This has some overlap with the pinmux subsystem.  We also need
> > documentation of what the pullup values mean.
yes and no

as some gpio IP (only gpio i2c extender as example ) have it too
so you can not use the pinmux for this
> 
> +1
> 
> AFAIK, 3 values are there: up, down and highz
> Also, IMO, this should have no effect if the GPIO is configured for output.
I see some pio IP have 2 highz

but yes 3 value normaly

Best Regards,
J.
