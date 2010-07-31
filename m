Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab0GaV2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:28:52 -0400
Received: from vps.mortis.eu ([79.99.135.181]:45249 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab0GaV2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:28:51 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Jul 2010 17:28:51 EDT
Date: Sat, 31 Jul 2010 23:21:35 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] hwmon: f71882fg: use a muxed resource lock for the
 Super I/O port
Message-ID: <20100731212135.GB3711@salidar.me.mortis.eu>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
 <1269523063-30346-1-git-send-email-me@mortis.eu>
 <1269523063-30346-2-git-send-email-me@mortis.eu>
 <20100425103540.GA5185@salidar.me.mortis.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <20100425103540.GA5185@salidar.me.mortis.eu>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 25, 2010 at 12:35:40 +0200, Giel van Schijndel wrote:
> On Thu, Mar 25, 2010 at 14:17:42 +0100, Giel van Schijndel wrote:
>> Sleep while acquiring a resource lock on the Super I/O port. This
>> should prevent collisions from causing the hardware probe to fail
>> with -EBUSY.
>=20
> Fix a bug which caused f71882fg_find() to pretend to be succesfull on
> Super I/O ports which didn't have a Fintek chip attached.  This was
> caused by returning 0 instead of -ENODEV, adding several 'err =3D
> -ENODEV' statements preceding the 'goto exit' statements fixed this.
>=20
> Patch follows this line:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Sleep while acquiring a resource lock on the Super I/O port. This
> should prevent collisions from causing the hardware probe to fail with
> -EBUSY.
>=20
> Signed-off-by: Giel van Schijndel <me@mortis.eu>

All of this patch's dependencies now reside in mainline, so I'd like to
"renew" the request for applying it.

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxUk98ACgkQZBYm/87l50ISyACeKr0sv9RE0iR5Jwleotj+WIXo
JpkAn0gdr/wNbW1ytVRo9HNvA1drgMYH
=9U23
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
