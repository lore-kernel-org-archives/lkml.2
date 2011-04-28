Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003Ab1D1Mly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 08:41:54 -0400
Received: from glenfiddich.ikibiki.org ([88.191.124.82]:39267 "EHLO
	glenfiddich.ikibiki.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1D1Mlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 08:41:53 -0400
Date: Thu, 28 Apr 2011 14:41:50 +0200
From: Cyril Brulebois <kibi@debian.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [PATCH 3/4] Documentation/00-INDEX.sh: add script to help
 keeping the index up-to-date
Message-ID: <20110428124150.GG9517@debian.org>
References: <1303575344-10403-1-git-send-email-kibi@debian.org>
 <1303575344-10403-3-git-send-email-kibi@debian.org>
 <20110423093304.8a31e512.rdunlap@xenotime.net>
 <20110423210537.GI32680@debian.org>
 <20110424115811.e96c121f.rdunlap@xenotime.net>
 <20110426162007.13929384.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="APlYHCtpeOhspHkB"
Content-Disposition: inline
In-Reply-To: <20110426162007.13929384.rdunlap@xenotime.net>
Organization: Debian
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--APlYHCtpeOhspHkB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Randy Dunlap <rdunlap@xenotime.net> (26/04/2011):
> ad I don't see any environment variables that would affect grep either.
>=20
> Anyway, using this line instead of any one of the lines above works for m=
e:
>=20
> documented=3D$(sed '1,/^00-INDEX$/d' 00-INDEX|grep -G -v ^[[:space:]]|sed=
 's:/$::')
>=20
> i.e., use ^[[:space:]] instead of the (original) '^\s'.

Hm, I still can't reproduce your original issue, even with a Fedora 11
system; but anyway, using [[:space:]] looks good. In the upcoming
patch I'm also dropping -G: It's the default for GNU grep, and it's
not POSIX-documented[1] anyway.

 1. http://pubs.opengroup.org/onlinepubs/009695399/utilities/grep.html

Thanks, and sorry for the extra round-trips for such a simple patch.

KiBi.

--APlYHCtpeOhspHkB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk25YI4ACgkQeGfVPHR5Nd3t2wCfXsQYHv2prc3itAYF46LMp+0o
x/UAoJgSApotf6m8+Q9TJfxBoo19zJSe
=KHJS
-----END PGP SIGNATURE-----

--APlYHCtpeOhspHkB--
