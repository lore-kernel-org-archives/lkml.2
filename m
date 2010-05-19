Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab0ESLNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:13:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34217 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755468Ab0ESLNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:13:10 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100518.233752.256882583.davem@davemloft.net>
References: <20100518.233752.256882583.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-D/pchMba3QnnOe6pvnJO"
Date: Wed, 19 May 2010 12:13:02 +0100
Message-ID: <1274267582.2763.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [GIT] Networking
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-D/pchMba3QnnOe6pvnJO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-05-18 at 23:37 -0700, David Miller wrote:
[...]
> Some other things that stand out:
>=20
> 1) Allow the administrator to reserve port ranges, such that the
>    kernel bind allocation scheme won't use them.  From Amerigo Wang.
>=20
> 2) ipv6 address et al. handling converted to use generic kernel lists.
>    From Stephem Hemminger.
>=20
> 3) PHY module autoloading support from David Howells
[...]

For the record, that was actually David Woodhouse.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-D/pchMba3QnnOe6pvnJO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS/PHsue/yOyVhhEJAQLJ/w/+P1QQof1U0Mx80Ffl1x1UEAz5soGkO9gH
vRJPvVbKTn1P86nyJqeNgKEyhweboOTOJ8s9SXKXO2xlYpTjhYNFGfjWpbR8egsy
Oph4HOQqo0DeV/3nsFUYLoeqD24TWi6taUjW2FoipMmnE6PaALB+vGpgj1h1VhES
xncqcZgfTR7WwQp9k3rjEqJt+9kWu8BgPtyT1S/FZNdVPuH8Y6/c8CqcEfzZFjZI
zjLc2zGTMokESb5TJPuqW635LDI7OZXS//uSVR9Nzg23cQQSWIfdcK5YZQRo6Pxi
R+c7yDgwnQhW9OBHLMj6q+O4NReDzYh+d2cIKLNC880pVu8syaxkGsuLFl2f+Rjl
9QCefOLP6Sn1tB6Aa/Orl8ewditCISXFQoI3luIA0D878fGEYn5ibeLbfaYlkiKt
ZNetz0qLFUOwVwVZfsk4+ExbFfUydCtgyz9oRcBDEyo704STgRgKudXVfG5KfmcJ
rvuq23pNjmWaeyHas5c2CmB7klRtv4Lm69PgDotdf/cG51pieh8mPYr15H8Qcu6L
aPIyjQAxR3bZpOZ4vuRukqqXqqdT5TQZ8LwjGHyZ24wW8nzNrXh4/AcQPXyF7xJY
HuulrlBOZ4uk0W6G0xvcdL+2huDDstfYS27qbqFNh2lnSNV39zxvbLI/l6ytOB7Y
6mN0WCktWSQ=
=4UAb
-----END PGP SIGNATURE-----

--=-D/pchMba3QnnOe6pvnJO--
