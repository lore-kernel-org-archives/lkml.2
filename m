Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2GEKlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:41:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43300 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755613Ab2GEKlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:41:23 -0400
Date: Thu, 5 Jul 2012 11:41:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Alex Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
Message-ID: <20120705104120.GP4111@opensource.wolfsonmicro.com>
References: <4FF43692.2040805@nvidia.com>
 <20120704130056.GC30009@pengutronix.de>
 <4FF45DDF.9000306@nvidia.com>
 <20120704152451.GA7333@sirena.org.uk>
 <4FF4FDC0.8020405@nvidia.com>
 <20120705062011.GI30009@pengutronix.de>
 <4FF53368.6090805@nvidia.com>
 <20120705064742.GL30009@pengutronix.de>
 <4FF5459F.5090201@nvidia.com>
 <20120705080234.GQ30009@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TJXgsAvz6ds/es3G"
Content-Disposition: inline
In-Reply-To: <20120705080234.GQ30009@pengutronix.de>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TJXgsAvz6ds/es3G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 10:02:34AM +0200, Sascha Hauer wrote:

> So here the regulator core knows that there is no regulator and never
> will be. All that needs to be done is to make _regulator_get look at
> that value.

> There may be some side effects if we just return ERR_PTR(-ENODEV) when
> regulator_dev_lookup returns -ENODEV. Maybe Mark has some comments to
> this.

I'm concerned about how this is going to interact with all the plans
people have for dynamically loading device tree fragments during
enumeration.

--TJXgsAvz6ds/es3G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9W9KAAoJEBus8iNuMP3dUY4P/j5wq6gybou5u54WfhT9wwao
4rDLwZfWtNTQCUTpCZpL774gDIG6H4xnGGEt5pVzC3Xun4VI7wao4+OPzfmViNSC
kc3d9Ei6Yy8TAc/ixb4vl96C3swBLZt3M4/FRHQthxzqzWixzIIrNZPrJYQWYWj+
4AC6d5F/quSeUPcrmZM45mJbCNjbDZEBImiLmUnKvSpf9mCTTGtG0Nish0uj6XI3
uHcGwRzYM1yIx4n44sKaO5bfM85WonxRfXspzLJ7cdt/J0llcHFfIJLmDpo4xkJb
6CQSngYa8PvKuX2okmyWnP9HwHydBSRij+254MrfPWEQK2UTFRspfDJuYcwWJ9e6
WZoM8A0iEFIDtyCppeOGYxHbdC+1LSOZUX2DwkmALy5IvPx1gcV/Wx/qblZE3g3N
a9VbgV4BW8NWYca7LtKgZ90ts5fDb4Hx8YjZ/vGp0kczRl2AWaAOKVDqRGzXagFc
ALLIDW041ZB7zRipMlZHZIng1GrHz0eK263tof8CrDf7ZA0z56+3hVqKm52nTasB
SadR5xlAerSo9DqZzNydlP5zoHQt+DTNh42b0OrJ97aTwFRGmZH+pzoiV3iriwZV
ec1cS6Avsd9vlH0K5z8pmbQ7sb1rS9xrYiVOg66zv+fTnnjlHlX0kbn99JfwBlqf
ADyZyGINt8kCSVzXrdtL
=PCGP
-----END PGP SIGNATURE-----

--TJXgsAvz6ds/es3G--
