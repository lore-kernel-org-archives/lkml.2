Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2KPRsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:48:54 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:6515 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab2KPRsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:48:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjMIALl7plBbdWOb/2dsb2JhbABEhh6zcSKINYEIgh4BAQQBI0QSBQsLGCoCAlcGE4gHCqt4km2MM4N6gRMDpj+CcA
Message-ID: <1353088114.4563.49.camel@fourier.local.igalia.com>
Subject: Re: [PATCH] ipack: move header files to include/linux
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, jens.taprogge@taprogge.org,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Date: Fri, 16 Nov 2012 18:48:34 +0100
In-Reply-To: <20121116174410.GA2143@kroah.com>
References: <1353087276-4861-1-git-send-email-siglesias@igalia.com>
	 <20121116174410.GA2143@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-HFKKsypIJGxOViCjwp4f"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HFKKsypIJGxOViCjwp4f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-11-16 at 09:44 -0800, Greg Kroah-Hartman wrote:
> On Fri, Nov 16, 2012 at 06:34:36PM +0100, Samuel Iglesias Gonsalvez wrote=
:
> > Move ipack header files to include/linux/ directory where they belong t=
o.
> >=20
> > Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> > ---
> >  drivers/ipack/carriers/tpci200.h |    3 +-
> >  drivers/ipack/devices/ipoctal.c  |    2 +-
> >  drivers/ipack/ipack.c            |    2 +-
> >  drivers/ipack/ipack.h            |  215 ------------------------------=
--------
> >  drivers/ipack/ipack_ids.h        |   32 ------
> >  include/linux/ipack.h            |  214 ++++++++++++++++++++++++++++++=
+++++++
> >  include/linux/ipack_ids.h        |   32 ++++++
> >  7 files changed, 249 insertions(+), 251 deletions(-)
> >  delete mode 100644 drivers/ipack/ipack.h
> >  delete mode 100644 drivers/ipack/ipack_ids.h
> >  create mode 100644 include/linux/ipack.h
> >  create mode 100644 include/linux/ipack_ids.h
>=20
> Can you send me a patch in -M format, that just shows the files moving
> next time?

OK

> Also, do we really need the ipack_ids.h file in include/linux?  It looks
> like only the core ipack code cares about the values there, right?
>=20

Yes, you are right. I will rewrite the patch again and send it.

Sorry for the inconveniences,

Sam


--=-HFKKsypIJGxOViCjwp4f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlCmfHIACgkQWrfbyfmd9eIfTgCgrQNFSHEzmzsWg0Aasyn1zNIC
NCQAoKPq22F5lhBqXXLUSWndD8KbXRtk
=igmt
-----END PGP SIGNATURE-----

--=-HFKKsypIJGxOViCjwp4f--

