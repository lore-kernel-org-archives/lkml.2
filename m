Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab0JVVWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:22:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51714 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754244Ab0JVVWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:22:39 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont 
	<remi.denis-courmont@nokia.com>,
        Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20101022183601.910822183@clark.site>
References: <20101022183601.910822183@clark.site>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zZ2hfHN36PB72PjHdW8m"
Date: Fri, 22 Oct 2010 22:22:33 +0100
Message-ID: <1287782553.20865.253.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [64/66] Phonet: disable network namespace support
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zZ2hfHN36PB72PjHdW8m
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-10-22 at 11:35 -0700, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
>=20
> From: R=C3=A9mi Denis-Courmont <remi.denis-courmont@nokia.com>
>=20
> [Solved differently upstream]
>=20
> Network namespace in the Phonet socket stack causes an OOPS when a
> namespace is destroyed. This occurs as the loopback exit_net handler is
> called after the Phonet exit_net handler, and re-enters the Phonet
> stack. I cannot think of any nice way to fix this in kernel <=3D 2.6.32.
>=20
> For lack of a better solution, disable namespace support completely.
> If you need that, upgrade to a newer kernel.
[...]

I've had one report today that the bug is still reproducible in the
current Debian kernel, which includes this change.  R=C3=A9mi, how have you
tested this fix?

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-zZ2hfHN36PB72PjHdW8m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATMIAmOe/yOyVhhEJAQJ6Aw//Qc/aWN95v4D5L1WRieqpHEihe7dCZW0Q
pAnGJaK/KELejwUATbE4+l8X9rPiUIqxLvidDLBSmzLjQNghxSmKygmYUfvM/3fU
S9Tw3kxUNXqoiPjwtUWPOk4Y2jDieRYfDFtqQ8SSj2s5t97VBVznN9tpeP/YEc9h
TI61ZyVCrzbDGFSUMbPkHJaRiayIUosATsXLUY7z3qgnRqYW2Qbu5YaWu7gugFvk
Ey8d9lcNiqBvF79P+jotHoxxmxoLumLJI7t2O6JaragTJ+HTVe9NeYswXWjPiNqs
1He7vR6gVyC2+wjEvwvp5xdaQ8XDfYo0lwGio0tiuRMnuwQ2e+EDWrO9laNP+5H9
DYWIoREYENxvAMtQXGA4VTkR9c0PZLLStHpjJvYBgzwIa8O90C0tgsOhsrje9n84
3yyImpBXTBrvSTHQ1H50dzcO+Axs5IFgYIesYGXu91qlPVcA3UZ9u37vh/oyGpOf
aYcRXopzuldU+ojoEw5EOAdSCcyoa3nwCAJPqPx21JUT/fbf5Oz+VfVnlWxH/4Tc
TsB4cRRxwgl9pLDkKXx9dTQzM2EvOkkKBkKTTAzg8lbmt0530mckGeHFO4OTHeGG
Nm6l8uE6+msgb66PA3xH/cOs+x/K4GqVY8duElidtaa1HYKs1Zjo+9jHpqWsR1F3
H1sJMsz0S7k=
=HRz6
-----END PGP SIGNATURE-----

--=-zZ2hfHN36PB72PjHdW8m--
