Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2LOT70 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 14:59:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47580 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093Ab2LOT7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 14:59:24 -0500
Message-ID: <1355601558.18807.28.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 162/241] Bluetooth: ath3k: Add support for VAIO VPCEH
 [0489:e027]
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Marcos Chaparro <marcos@mrkindustries.com.ar>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Sat, 15 Dec 2012 19:59:18 +0000
In-Reply-To: <1355407206-17100-163-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
	 <1355407206-17100-163-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-18/8Kz6G0wU+szCx/LbO"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-18/8Kz6G0wU+szCx/LbO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-12-13 at 11:58 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7.2 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Marcos Chaparro <marcos@mrkindustries.com.ar>
>=20
> commit acd9454433e28c1a365d8b069813c35c1c3a8ac3 upstream.
>=20
> Added Atheros AR3011 internal bluetooth device found in Sony VAIO VPCEH t=
o the
> devices list.
> Before this, the bluetooth module was identified as an Foxconn / Hai blue=
tooth
> device [0489:e027], now it claims to be an AtherosAR3011 Bluetooth
> [0cf3:3005].
[...]

This seems to be applicable to 3.{0,2,4,6}.y as well...

Ben.

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-18/8Kz6G0wU+szCx/LbO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUMzWlue/yOyVhhEJAQoGsxAAphsHpbk1uUwGs8EGuJZL8EAbKRr7wrNR
LGisGivc5aOgrHO1I60EGz4orA8CJNBW3qAVK46IkLf1w1TyWNANqlpbl42mehp6
5XV4WfZzFNfHXR6nPGSgZKi5kKY1dxuOMG6qIRCJGqwZSivw4MwMjHlXUb8sl0+q
m8dYaaObq9+fP9lMCkaNbnfFwsXgaokJkfBkpdenDPTBG6NLlQw7PEt5qJ0Yn1hb
ZA8ihhdOfUTVD4o4Y475oOf25839wG5ZC74hsaS5/7C6QXuq/GLpQhfjIk2MLW/t
0u+qv/JnnHH8gEKiWr3n6Mggtye4j+VMdwL4scVbob7etsybuRPf+k1QsziR6GGe
nsLC1gUW+KuaOLBsqwTU+1O5f4bn+neAG5CX1YUbOYMdqTr57sdKyhDk6pJv1+9H
TDIyvU8M5wZdsn4wscsb3n/AOa/E+BF5Z/V1w+8/SUc8Q+iSQppcYZf7Fow3c4D0
ba1F/B1i7+YaLOv3D3lSWFOtMuzEfC/4vHzB2enUp0O16yFsFFR+TJ1+drf85+nf
Dqw3RxjHDnmSNg79WH1NSeKB6oGrNx4oSzBnn4o05GgU+c62c8ak2jH+h1/O5X58
TmSUWSOQPCET6g6gGpvm/TUmtiPl1/bZCSBZv8ZrHQ0N72zORKWElmP+W7DtgDD4
MfzJTVby2/o=
=iDqP
-----END PGP SIGNATURE-----

--=-18/8Kz6G0wU+szCx/LbO--
