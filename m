Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab2LJA3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 19:29:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48084 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900Ab2LJA3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 19:29:09 -0500
Message-ID: <1355099334.20838.97.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 266/270] ARM: 7566/1: vfp: fix save and restore when
 running on pre-VFPv3 and CONFIG_VFPv3 set
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <dave.martin@linaro.org>,
        =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans.rullgard@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Date: Mon, 10 Dec 2012 00:28:54 +0000
In-Reply-To: <1353949160-26803-267-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
	 <1353949160-26803-267-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-OP2okDkNwjEcFaK9dqMa"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OP2okDkNwjEcFaK9dqMa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-26 at 14:59 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7u1 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Paul Walmsley <paul@pwsan.com>
>=20
> commit 39141ddfb63a664f26d3f42f64ee386e879b492c upstream.
>=20
> After commit 846a136881b8f73c1f74250bf6acfaa309cab1f2 ("ARM: vfp: fix
> saving d16-d31 vfp registers on v6+ kernels"), the OMAP 2430SDP board
> started crashing during boot with omap2plus_defconfig:
[...]
> [ herton: no uapi directory on 3.5 ]
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>
[...]

I've also queued this up for 3.2.  Greg, you'll want to add this to the
other 3.x series since you applied commit 846a136881b8.

Ben.

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-OP2okDkNwjEcFaK9dqMa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUMUsxue/yOyVhhEJAQqoshAAw0lBkHusmPzxJXBhVq+c1MtpwAqUyXOW
q9grL7fR9QJSGDSRkiQg5BpRcW0hrvnmvHAdvhnfiCCGMrZSgSkNyde7Rc7PdUhq
sIVKogV5YibB/bKiFQXvBasBm2f/qrhqkMQfZA2nYIJFvKnpOedHtZKl48bt9yjc
4n9zFfr7oIhOiecsifaozAG+XCQensVGA1qNeHqwr8zdWRxAKW2cjagcQNEW3MBB
Re9c/t9ciUH6SHjEbMcZluPeVrYfKNKEJWPfrh4s0fskL6uIcyktk5b6p4gWiy7n
Npt9DYoyR0SUIK5yCpxXCgnGQITcw9bGbk2m2nbtITkLGHd2b4MBckozZ7BG9oJt
o4O5+tHsTw7hFJ0tDxGFp+eIEV6Oi+zjkmLG37r99XwbYo3ZU3NZC2egiMdJKhuL
FQFyXpCBSIos30lwwRUvPnRrbnPtqE207W9O+CoWFsqRfEkb8wfAhLdLbYiQNq4k
MAPZczqGhGg0+Wx9sTbX6IKBQxUAivxHtXTlt+xssQF8zOdeCQej28Qzf6OVO3IH
D5EbqwWap7yspTmYECcbiIZInNix7f1iVLyjw3zBI+nxr5O0SRQzPstoK/vX1dwE
2CgV9BJgUBEq5exWjnWosxxgKWe+qMbwiIlKZPJR2LJVaw1PGk/jtqTq3cEDxXxi
1Oe5ldlgwHQ=
=y2gw
-----END PGP SIGNATURE-----

--=-OP2okDkNwjEcFaK9dqMa--
