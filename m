Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab2KEKzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:55:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58207 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932092Ab2KEKy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:54:58 -0500
Date: Mon, 5 Nov 2012 11:54:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121105105455.GD1385@opensource.wolfsonmicro.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <1351928793-14375-3-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
Content-Disposition: inline
In-Reply-To: <1351928793-14375-3-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 03, 2012 at 09:46:32AM +0200, Mika Westerberg wrote:

> +	strlcpy(spi->modalias, acpi_device_hid(adev), sizeof(spi->modalias));
> +	if (info.gsi >= 0)
> +		spi->irq = acpi_register_gsi(&adev->dev, info.gsi,
> +					     info.triggering, info.polarity);
> +	request_module(spi->modalias);

request_module()?  Why?

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQl5rtAAoJELSic+t+oim9p8gP/0dRfPl04jxldyhjrkPYXCNv
JMaLbHRdTV/bEPFK+xbLZyR0q+rKw7xlcZbSnTCx8HCRGROXrN+zKpCWJVSPYnrB
uwhwgeIJFMAh0UJ3Z6dYgp0fMsu9T6XmQy6qspW2wDsimS8Zinenw37KRj9GH1VX
NX25ha7YD3HXafFH45bXdNUusAv3u0cPm6NxpJk1Psx+cyJvXpqT7lUkxg1seCG/
j0kLIe4BLGtRG5+agQROs2EiulbSQTY7VcHj0piLYwHRLxOwo9mDWFZTtI+rrNCs
thrw2OTSJNLDMNGbdmDHrt0C2UPFwd5EBjAq8b5r4Ux7+q/QgwlR7wFLQmGlGqb1
FTYVYMTSu17LZVUFlAvosKx0Y8lJLbKXP2Sl9qUB709Q9zl7jU0OsoVv2m8dvQjc
lsXNrFaAxVazSDqQ012DGwyoZeIf7rl9NL7FF2/gNnMFjYUb2SGL1+nxQbSsNo1q
4Bd/M96+E6/383gxdwMa7/24hJk7rlMrIDbaIJ5Y3UnESTa4MJ3sNYwnxApmHbb5
zicDHt1yeBEqZtudeP5/hDtECjZN8l9MEfIw1vCGg1c2Ld9Gh4h1dDxZw9I2Sg/g
E80kETjEQ+3eHFXsuuV1rxTdnayP9br8rsA8ht9xEvWRzyC7iLyw8XDD1kXO4Iou
YGy2AwKBFCN/omZNI3FK
=0+Nl
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--
