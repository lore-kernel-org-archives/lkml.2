Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab2KPSOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:14:11 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:61664 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab2KPSOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:14:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjMIACWCplBbdWOb/2dsb2JhbABEhh6zcSKINYEIgh4BAQQBI1YFCwsYKgICVwaIGgqsB5JskC2BEwOmP4Jw
Message-ID: <1353089655.4563.56.camel@fourier.local.igalia.com>
Subject: Re: [PATCH] ipack: move header files to include/linux
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net, jens.taprogge@taprogge.org
Date: Fri, 16 Nov 2012 19:14:15 +0100
In-Reply-To: <1353089331.2512.2.camel@joe-AO722>
References: <1353087276-4861-1-git-send-email-siglesias@igalia.com>
	 <1353089331.2512.2.camel@joe-AO722>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-c/oC4eRSxciG8iBYOgkQ"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-c/oC4eRSxciG8iBYOgkQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-11-16 at 10:08 -0800, Joe Perches wrote:
> On Fri, 2012-11-16 at 18:34 +0100, Samuel Iglesias Gonsalvez wrote:
> > Move ipack header files to include/linux/ directory where they belong t=
o.
>=20
> Why do these belong in include/linux?

They are used for other drivers that could be in other directories.

> What's wrong with path relative includes?

There is nothing wrong with relative includes. It's just to do the
things as other subsystems do: keeping the bus' header file in
include/linux directory.

Is this approach wrong for this case?

Sam


--=-c/oC4eRSxciG8iBYOgkQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlCmgncACgkQWrfbyfmd9eJYxACfWuTGBPTsn6xCLUB7V3CAlUOg
na8An1ElOVacnOEQGD9fgMyEjS74QZ+w
=T+Nk
-----END PGP SIGNATURE-----

--=-c/oC4eRSxciG8iBYOgkQ--

