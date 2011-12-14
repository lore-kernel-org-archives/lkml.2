Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab1LNQwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:52:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42173 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752045Ab1LNQwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:52:36 -0500
Message-ID: <1323881520.2825.196.camel@deadeye>
Subject: Re: [RFC] modpost: add option to allow external modules to avoid
 taint
From: Ben Hutchings <ben@decadent.org.uk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-wireless@vger.kernel.org
Date: Wed, 14 Dec 2011 16:52:00 +0000
In-Reply-To: <1323879603-2961-1-git-send-email-linville@tuxdriver.com>
References: <1323752547.2825.101.camel@deadeye>
	 <1323879603-2961-1-git-send-email-linville@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Pu9591LkloWm7kDU3jDZ"
X-Mailer: Evolution 3.2.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Pu9591LkloWm7kDU3jDZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-12-14 at 11:20 -0500, John W. Linville wrote:
> In some cases, it might be desirable to package a module from an
> external source tree alongside the base kernel.  In those cases, it
> might also be desirable to not have those modules tainting the kernel.
>=20
> This patch provides a mechanism for an external module build to declare
> itself as an "integrated build".  Such a module is then treated the same
> as an intree module.
>=20
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Any thoughts on this?  I'm thinking of adding this to Fedora kernels,
> where I have been working to integrate the compat-wireless package as
> part of the base kernel RPM.
[...]

If you're integrating it then why can't you *really* build it in-tree?

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-Pu9591LkloWm7kDU3jDZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATujUMOe/yOyVhhEJAQpmoQ/+MNjjKgGa+Mvl0VZWqsRlw3Y69IE6A68q
CLWRAAkFLLiWqrbAj3h8+qBmnV8CqX0q/iyJinrf1lJN8+lPCDwc3DPmnkLn6ntK
ALykQTHZe+NSrpeLOw3pIxrFZvAtDLTQ7Pi9Xu6cR2HsJ20epTfWEG1DtSRQAgoi
InFPufQ2una2bwnvD9lMO2D8/AIYgJkDyqKkx8lcOVECDPjN8q2Mpy9w7VK1VM0q
0RVzojZK73e30ZyNXFx7oMXb0lIFZV5tfk2EODkX11HTTNPq1Zz0h2wcapLpi7UI
C5evoCykpXdrVsJ1q3xvT+fNZV1KFRaeiHh+cERIh1RofVca2Vh14pRUDN8LN5Tu
8tuEcaDttpUPbfBBJA9zIltGFU0hGOT/p6l9vU5/BjrcYQkYKI5PfQLcBWJw9BhY
XU8KN800xDCO8EjrlBBH7vadYrAst3NA64NJFiTsND0VWfnVMfDJKAs9MXhWakK+
OXFs7TJz0NETAWhV7oMLhQxP+qZRKFNC+S0Sp0/wjntA8Zjw4mY+Uck3R+CLCCOk
rOgE8/N3CIjtOvCSgw4GkUAV0QqUUR41Z45/zXB6Fg1r3frU5r2lczgvRS5Y6khO
RCisQe9LMUuuwtp+de/oo80H6W8P+JjcCVl0We4Bj2q3CHcGSo3EOTWxSY7PWFsp
AZsWB4dmooM=
=Faz6
-----END PGP SIGNATURE-----

--=-Pu9591LkloWm7kDU3jDZ--
