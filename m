Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab2J0S0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 14:26:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58624 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758499Ab2J0S0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 14:26:42 -0400
Message-ID: <1351362392.4834.17.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 60/85] xtensa: add missing system calls to the syscall table
From: Ben Hutchings <ben@decadent.org.uk>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 27 Oct 2012 19:26:32 +0100
In-Reply-To: <20121026000037.158689095@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
	 <20121026000037.158689095@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-hQcy/AqtblwcMx3rTtPs"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hQcy/AqtblwcMx3rTtPs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-25 at 17:06 -0700, Greg Kroah-Hartman wrote:
> 3.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Chris Zankel <chris@zankel.net>
>=20
> commit 7216cabfff5149670445cd65d415ed5db21314b4 upstream.
>=20
> Add the following system calls to the syscall table:
[...]
>  #define __NR_available287			287
> -__SYSCALL(287, sys_faccessat, 0)
> +__SYSCALL(287, sys_ni_syscall, 0)
[...]

Why was this one un-plumbed rather than properly numbered (#define
__NR_faccessat)?

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-hQcy/AqtblwcMx3rTtPs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUIwnWOe/yOyVhhEJAQrbCxAAxYSxzq1f4BGNQSLmRjLvrQSX+saE8C+2
v3BKwVWrpEj3dQutZykVfjwDsoLeGfhcz3gpUMd6w9z2zeYOzx1wCG/4/6fbwX3A
tB/GIxFYhlfRpYKwSLyFX/iMXuW80YncezWE7b1M8pIh/mXpG1u9eeHR6APBhX7O
KLAyuNNt8W1V3tPqbapk/X18RXZAiPyk271N8Iw5x0xjObfvmRkNcsdB1vHa3GAL
6OpW6NwjV/EOfomw5dRk+jcDRHs572zfBq52BsoFWG056aIMN47HlYieXj7nwTDn
m8DJLQyVM4wXZk0I6bXrgO+nmfnw97z65BMa/ribR1dxELET8jubLGmnmlUkP5ZK
VIfpXuJD6qwvaX8b6TohLEksnmVMq0ueZeopwEcf3ZdDpzOTXd3331fRAE15EvZj
pWqTlqppUxZrgRdgwpSgm+mtCvqmeiaQbxIh7yCc/np46gwOLrG+QvJ2UK/EHXOr
dr6kpNrjPFJdTRe7viTS4uV7XVuiUiSKT8HjnoKSOC5yz0O31sVr4epvVbYpRk0F
KQScN69vlrLp5FKWiI9Lypi5e4LDUADHD0xhRARCbwAnKG2uETblGE6CwQXjT4Vb
LjyPeVT2gNARV0CsLcQihxulNQZyhZ6X9/7gZvcBaHYmxCiGh9fVRALH7nWvKYMC
0/u+1YaMgj0=
=UaqA
-----END PGP SIGNATURE-----

--=-hQcy/AqtblwcMx3rTtPs--
