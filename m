Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab2GXI0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 04:26:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52506 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab2GXI0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 04:26:31 -0400
Date: Tue, 24 Jul 2012 10:26:24 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: "Philip, Avinash" <avinashphilip@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, nsekhar@ti.com, gururaja.hebbar@ti.com
Subject: Re: [PATCH] PWM: Add support for configuring polarity of PWM
Message-ID: <20120724082624.GA4476@avionic-0098.mockup.avionic-design.de>
References: <1342616053-7793-1-git-send-email-avinashphilip@ti.com>
 <20120723083032.GA12868@avionic-0098.mockup.avionic-design.de>
 <500DB0CB.1000600@metafoo.de>
 <20120724065121.GA30417@avionic-0098.mockup.avionic-design.de>
 <500E5BED.6050401@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <500E5BED.6050401@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:JyNCsrh1NAwpFa5tYxC26ZAQbcOx7kISc6hdgqPauc3
 0k941L176si5wowdwNQqLVAboJsv7di5/WHMEHZb4sqPBJj0Ln
 N1pi/7qS686qQpEELWc/XpvTjexXzqDJXn8+VTlWmIfBqW7DTq
 8CrcGOKjr45LLXXp5HIVqDBwp92boJ2xDCl+YSh/wg3YQxsV4w
 vhXl01LHXJbapmoCifvwMUNnKF9/M1sf68E5ucloB29bRfjuHC
 mTF0NohKaDqMzdv5RXTaX9ETMFL35i9ha/eOvSQ/uxnwS3JTDL
 3UL5cirKttdyDIChFvWYVtLP4vHyRkLnPbqJdUbs5QwCjgtZ4v
 Wb0in2g8NV02yh9YQ5iLfoo/ycYE6VKqPR9+aM3NHgAGPRbEFK
 74/B9kLxORsyDBazni/aVjtvQIO3G56ujDNo2avshuveM7ZRmx
 rgzax
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 24, 2012 at 10:25:17AM +0200, Lars-Peter Clausen wrote:
> On 07/24/2012 08:51 AM, Thierry Reding wrote:
> >=20
> > How about the following?
> >=20
> > /**
> >  * enum pwm_polarity - polarity of a PWM signal
> >  * @PWM_POLARITY_NORMAL: a high signal for the duration of the duty-
> >  *   cycle, followed by a low signal for the remainder of the pulse
> >  *   period
> >  * @PWM_POLARITY_INVERSED: a low signal for the duration of the duty-
> >  *   cycle, followed by a high signal for the remainder of the pulse
> >  *   period
> >  */
> > enum pwm_polarity {
> > 	PWM_POLARITY_NORMAL,
> > 	PWM_POLARITY_INVERSED,
> > };
> >=20
>=20
> Looks fine :)

Philip: can you fold this into your patch?

Thierry

--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQDlwwAAoJEN0jrNd/PrOh62cP/i77Mw0m4gmbVn8eVoSLTCvP
sGoOMu/ah++aako1tUVAmRF0tYqwzsXhgS625U3kUPL1MEsDepKP8WModFwz8VOX
XZju7gduZ9bqhFcCuV3cmyM+tHhjC0O58n1wijpMNS8xdLDmVSX2yR9fHSCpNj1M
Dep0Uw9PRj0SZgcFVtVsNOFXnbJen+3njJNR2S7RZSuRSZybdDlekTiw5Vm9Nmuy
pL1ELZhtRkN6X7z0pDbpFIWZo+UCeNMaps445gA6pcBS0aQcqyuDdeZCCzzEjJjO
0QJwsn/PGtfAsfZstPgxl1Fyf4Fg9zQ2tBqkNOwwYh0nJYH5m8Kq2XRZiPthIizz
ka6BHN9okUbbAVTRbIstFYlx6IJd1ge1kKKdjHFGuN5G49gI62dBI5QuyzFMdWwV
jwCy3UbKKv40w/KfnrQ/Ao8N8A0cWNotHQVKW36dM7YWeIa7+468ILoujKL3ie9Z
f6gPm6223R6tX7dh6MjwE9Eq87m9CaJc4j2D1i4yJ70f4/vwMO0K/yn6ubRrzYGa
rQBahj4xtQYRonu1GQhw0YfEyZmV2k5KUePNV7706LYmQ54ivsHuNF/2JTXgTasd
kI5dwzFcDkQVbdMlRgSHzcYmntFG54HE+rEUJ68NjoEMZ2zUwfPCXhWHM3jmZdPt
UCLoR8a0bUIlN1zshkMN
=j9i3
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
