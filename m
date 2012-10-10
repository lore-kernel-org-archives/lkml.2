Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab2JJRty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:49:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46301 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab2JJRtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:49:52 -0400
Message-ID: <5075B2F4.60708@pengutronix.de>
Date: Wed, 10 Oct 2012 19:40:04 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: socketcan@hartkopp.net, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for can
References: <30687.1349789402@warthog.procyon.org.uk>
In-Reply-To: <30687.1349789402@warthog.procyon.org.uk>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5BF68A89947E52AE682F4C89"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5BF68A89947E52AE682F4C89
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/09/2012 03:30 PM, David Howells wrote:
> Can you merge the following branch into the can tree please.
>=20
> This is to complete part of the Userspace API (UAPI) disintegration for=
 which
> the preparatory patches were pulled recently.  After these patches, use=
rspace
> headers will be segregated into:
>=20
> 	include/uapi/linux/.../foo.h
>=20
> for the userspace interface stuff, and:
>=20
> 	include/linux/.../foo.h
>=20
> for the strictly kernel internal stuff.

Nice work David. The upstream for can-next is David Miller's net-next
tree. He doesn't like if I pull unrelated stuff into my tree, so I'm
going to cherry pick your patch. This is not yet possible, as net-next
doesn't include the latest patches from the 3.7 merge window, so that
compilation breaks. After the merge window closes David Miller merges
back the latest changes to net-next. I'll postpone your patch until
then, this means the code will go into v3.8. I'm not familiar with the
UAPI conversion, should your patch go via linux-can and David's net into
v3.7?

regards, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig5BF68A89947E52AE682F4C89
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlB1svkACgkQjTAFq1RaXHP3WgCfciHeHTYM3mQLvyldV6D+feL+
1/EAnRlixVfp6dxZWdplNxojKVwWWBl/
=gloJ
-----END PGP SIGNATURE-----

--------------enig5BF68A89947E52AE682F4C89--
