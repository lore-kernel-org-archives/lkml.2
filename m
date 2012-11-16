Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2KPRxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:53:02 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:37542 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2KPRxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:53:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjMIALl7plBbdWOb/2dsb2JhbABEhh6zcSKINYEIgh4BAQUjRBIQCxgqAgJXBhOIEat4km2MM4N6gRMDpj+CcA
Message-ID: <1353088388.4563.52.camel@fourier.local.igalia.com>
Subject: Re: [PATCH] ipack: move header files to include/linux
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, jens.taprogge@taprogge.org,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Date: Fri, 16 Nov 2012 18:53:08 +0100
In-Reply-To: <1353088114.4563.49.camel@fourier.local.igalia.com>
References: <1353087276-4861-1-git-send-email-siglesias@igalia.com>
	 <20121116174410.GA2143@kroah.com>
	 <1353088114.4563.49.camel@fourier.local.igalia.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-f/KJXnyu5BjCr/QDArjJ"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f/KJXnyu5BjCr/QDArjJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-11-16 at 18:48 +0100, Samuel Iglesias Gons=C3=A1lvez wrote:
> On Fri, 2012-11-16 at 09:44 -0800, Greg Kroah-Hartman wrote:
> > On Fri, Nov 16, 2012 at 06:34:36PM +0100, Samuel Iglesias Gonsalvez wro=
te:
> > > Move ipack header files to include/linux/ directory where they belong=
 to.
> > >=20
> > > Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> > > ---
> > >  drivers/ipack/carriers/tpci200.h |    3 +-
> > >  drivers/ipack/devices/ipoctal.c  |    2 +-
> > >  drivers/ipack/ipack.c            |    2 +-
> > >  drivers/ipack/ipack.h            |  215 ----------------------------=
----------
> > >  drivers/ipack/ipack_ids.h        |   32 ------
> > >  include/linux/ipack.h            |  214 ++++++++++++++++++++++++++++=
+++++++++
> > >  include/linux/ipack_ids.h        |   32 ++++++
> > >  7 files changed, 249 insertions(+), 251 deletions(-)
> > >  delete mode 100644 drivers/ipack/ipack.h
> > >  delete mode 100644 drivers/ipack/ipack_ids.h
> > >  create mode 100644 include/linux/ipack.h
> > >  create mode 100644 include/linux/ipack_ids.h
> >=20
> > Can you send me a patch in -M format, that just shows the files moving
> > next time?
>=20
> OK
>=20
> > Also, do we really need the ipack_ids.h file in include/linux?  It look=
s
> > like only the core ipack code cares about the values there, right?
> >=20
>=20
> Yes, you are right. I will rewrite the patch again and send it.

Looking at the code, 'drivers/ipack/devices/ipoctal.c' needs
IPACK1_DEVICE_ID_SBS_OCTAL_* and IPACK_ID_VERSION_1 constants defined in
ipack_ids.h file.

Is it better to keep ipack_ids.h file in include/linux/ or change the
#include sentence?

Cheers,

Sam


--=-f/KJXnyu5BjCr/QDArjJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlCmfYQACgkQWrfbyfmd9eIuQwCfeNiS4wd4wIO7ORO9I/VUZTFG
QOgAn09tESLZOSWh+YQe/LC8+dZxMosb
=3Fcn
-----END PGP SIGNATURE-----

--=-f/KJXnyu5BjCr/QDArjJ--

