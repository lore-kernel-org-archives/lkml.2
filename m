Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab1FAOdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:33:12 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:42519 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756766Ab1FAOdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:33:08 -0400
Date: Wed, 1 Jun 2011 17:32:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        gadiyar@ti.com, sameo@linux.intel.com, parthab@india.ti.com,
        tony@atomide.com, khilman@ti.com, b-cousson@ti.com, paul@pwsan.com
Subject: Re: [PATCH 4/4] mfd: global Suspend and resume support of ehci and
 ohci
Message-ID: <20110601143256.GG2409@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1306934847-6098-1-git-send-email-keshava_mgowda@ti.com>
 <1306934847-6098-4-git-send-email-keshava_mgowda@ti.com>
 <1306934847-6098-5-git-send-email-keshava_mgowda@ti.com>
 <201106011554.38415.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E69HUUNAyIJqGpVn"
Content-Disposition: inline
In-Reply-To: <201106011554.38415.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E69HUUNAyIJqGpVn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 01, 2011 at 03:54:38PM +0200, Rafael J. Wysocki wrote:
> > +static const struct dev_pm_ops usbhsomap_dev_pm_ops =3D {
> > +	.suspend	=3D usbhs_suspend,
> > +	.resume		=3D usbhs_resume,
> > +};
>=20
> Please add .freeze()/.thaw() and .poweroff()/.restore() callbacks too.
> They may point to the same routines, but must be present.
>=20
> You can actually use the SIMPLE_DEV_PM_OPS() convenience macro for this
> purpose.

good point. BTW, do we need this #ifdef CONFIG_PM stuff which has been
popping on most drivers recently ? To me it looks like driver.pm field
is always available even if PM is disabled, so what's the point ? Saving
a few bytes ?

--=20
balbi

--E69HUUNAyIJqGpVn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN5k2YAAoJEAv8Txj19kN1bcMH/3Y21ajd9zctO7SZtuZipk8x
yPZUb3tLZi0VCEBrM4qBx76nKVEx8Mo1Kf4bYUBfAqeS4jlgohC9Ot5G70PeRwFd
Dxq4hPBVxR9tKughwwJFHqE5tHlqcgpaetcfr+eOfOnETCE4v6djuQGZMSQ47zMZ
ZDPlHjj+InXs22g7Tnv2udRinHoXpFFMQbZdGK+U7rPZdo6it0CtIeHEUPYY883e
GyUDxhtX9f+Gj4D5bpeuQ5fO9A2DOhlX/v3Xj6+slqSTtdYuKcaZ/X2x24rOhi/L
aspvUGvjfcdC2g/Sxmgt441rELxZ94ip2k6L0G2uavAJ/3yqpWhAVrFuZrY6rtQ=
=Rwus
-----END PGP SIGNATURE-----

--E69HUUNAyIJqGpVn--
