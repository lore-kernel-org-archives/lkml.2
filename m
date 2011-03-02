Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab1CBSRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:17:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46852 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab1CBSRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:17:05 -0500
Date: Wed, 2 Mar 2011 19:16:51 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Dirk Eibach <eibach@gdsys.de>, linux-kernel@vger.kernel.org,
        guenter.roeck@ericsson.com, lm-sensors@lm-sensors.org,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4] hwmon: Add support for Texas Instruments ADS1015
Message-ID: <20110302181651.GA24054@pengutronix.de>
References: <20110224174807.41c7597f@endymion.delvare>
 <1298639897-26856-1-git-send-email-eibach@gdsys.de>
 <20110302185718.3c0e06dc@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20110302185718.3c0e06dc@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > +#ifdef CONFIG_OF
> > +	/* fallback on OF */
> > +	of_channels =3D of_get_property(np, "exported-channels",
> > +				      &of_channels_size);
> > +	if (of_channels && (of_channels_size =3D=3D sizeof(*of_channels)))
> > +		return be32_to_cpup(of_channels);
> > +#endif
>=20
> The be32 thing looks odd. I don't get the idea, but as I don't know
> much about devicetree, I'll trust you.

That's okay. The properties are be32 (coming from powerpc).

Still, there is a new property defined which _always_ needs

a) CCing devicetree-discuss (get_maintainer helps here)
b) Documentation in Documentation/devicetree/bindings

because it needs to be a lot more stable than platform_data.

(I already lost the original mail, so I sadly can't forward it)

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1uiZMACgkQD27XaX1/VRuKVQCcCl2gktfLIVFlib1/uQi1yDpe
MLUAn238BQ+kPb+WCKpIDlQ05nypgZqG
=zf8L
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
