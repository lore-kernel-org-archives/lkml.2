Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435Ab2HJCV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 22:21:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34124 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759229Ab2HJCV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 22:21:26 -0400
Message-ID: <1344565271.13142.217.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 055/109] tg3: Fix Read DMA workaround for 5719 A0.
From: Ben Hutchings <ben@decadent.org.uk>
To: Michael Chan <mchan@broadcom.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 10 Aug 2012 03:21:11 +0100
In-Reply-To: <20120807222047.913258424@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
	 <20120807222047.913258424@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-a8OnLcnVvtDCyPWMZ8wF"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a8OnLcnVvtDCyPWMZ8wF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-08-07 at 15:35 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
>=20
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Michael Chan <mchan@broadcom.com>
>=20
> commit 10ce95d6ef36c65df7dcd3b8fcf86913f8b298bd upstream.
>=20
> The workaround was mis-applied to all 5719 and 5720 chips.
[...]

Isn't this needed for 3.0.y and 3.2.y as well?

Ben.

--=20
Ben Hutchings
Unix is many things to many people,
but it's never been everything to anybody.

--=-a8OnLcnVvtDCyPWMZ8wF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCRwF+e/yOyVhhEJAQr1yA//bnoCG6WsE8bvEB8mBMxhqbo5Vz+Sf74z
m8W2nTDx8jwgiek8Ct50ihUPitEB8BHMJPCPxyHpsdr8QmSJLyo/X3KNIDetSxId
mzWzYo1Wm44NzM4snH6Hb8beFocCvqNvmNSu9LNn2rIus+N/vk1NIuBA4vEzfzoZ
6uzJa6lcTzv68QunXrlq6xBHL2s+lhBVkem0eYcWcSP7GnWKSjdjwCIVZnHOmxJt
f73QGfRgcCmGuR5b9RapCsd+zLJlr48xR2p6+skqQ0Rri6AxvfaXmBobmHlJ1wsO
5JVJ1nQo6WrcHJ2M+ed8e64EB7F9e1XhnERulcDlXj+dbHaPCXBM+vdB+sOcldQy
Y2pQqFI5oOzOA40Xqi1cjXCYpf/fwtZmuFmLQLQA8LpNMe8fuTbGTskGmbZPYGW4
0UN6a5Mom8uuEWhgwEapDrIVhpUy7KrLVVbRhNGJ+cwkdR99aCKgfV29gy7+fhpR
Fb/wZwmhL7O3kVJcLfone2bm+11K18OwK1JfW2uhKRla1lnrzbgyeFvo3DTAm8Uv
RSvTqmWgcrJyCayDIqgH8fhu+lIobuK8MCKXP5ZMeCpytXxNr3+lad6WIHTBmYvt
/+OpQcsDcJiZEu82iMmF8iTY5aZfZ1fpNIoEg6pexKmzmmKt6WOzly3OYglGyC9N
AL+l9XnfnAM=
=8Qsh
-----END PGP SIGNATURE-----

--=-a8OnLcnVvtDCyPWMZ8wF--
