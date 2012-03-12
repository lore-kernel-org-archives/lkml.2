Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2CLXGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:06:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34347 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab2CLXGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:06:36 -0400
Date: Tue, 13 Mar 2012 10:06:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rob Lee <rob.lee@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the cpuidle-cons tree with the
 arm-soc tree
Message-Id: <20120313100625.b500f0efb546a9f4ceeb12ba@canb.auug.org.au>
In-Reply-To: <CAMXH7KH_vgri3EPRvkXR+LddRUc=0ve=4u7yr51utBfgV5bF3w@mail.gmail.com>
References: <20120309183732.512d3676599da324f4747219@canb.auug.org.au>
	<4F5E1ECC.1040605@atmel.com>
	<CAMXH7KH_vgri3EPRvkXR+LddRUc=0ve=4u7yr51utBfgV5bF3w@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_10_06_25_+1100_HEgG0i=jaSiYrDYo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_10_06_25_+1100_HEgG0i=jaSiYrDYo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rob,

On Mon, 12 Mar 2012 12:03:48 -0500 Rob Lee <rob.lee@linaro.org> wrote:
>
> On Mon, Mar 12, 2012 at 11:05 AM, Nicolas Ferre <nicolas.ferre@atmel.com>=
 wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> >
> > On 03/09/2012 08:37 AM, Stephen Rothwell :
> >>
> >> Today's linux-next merge of the cpuidle-cons tree got a conflict
> >> in arch/arm/mach-at91/cpuidle.c between commit 00482a4078f4 ("ARM:
> >> at91: implement the standby function for pm/cpuidle") from the
> >> arm-soc tree and commit 7a1f6e72dce1 ("ARM: at91: Consolidate time
> >> keeping and irq enable") from the cpuidle-cons tree.
> >>
> >> I fixed it up (I think - see below) and can carry the fix as
> >> necessary.
> >
> > Yes: resolution correct. Please carry it.
>=20
> Who should carry this fixup and related necessary at91 changes?  Me?
> FYI, my at91 changes are dependent on my core cpuidle change, but my
> core cpuidle changes do not require any at91 changes as the at91 and
> other platform changes were only made to consolidate duplicate code.

I will carry the fixup and Linus will presumably do the same fix when he
merges these trees in his tree.  I am not sure what you mean by "related
at91 changes".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Mar_2012_10_06_25_+1100_HEgG0i=jaSiYrDYo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXoFxAAoJEECxmPOUX5FEffYP/3/RYBupwv7zYO3LVID/KfAA
kjXR8QMl4tp4BT9UmoTatJH8CQ+V03/sKlSdEynEdpR/8g0VAU56pSwhOq8OmWiM
8xPumPxYJ/DcdtSww9hygjdjxe79tSTnvCCk+dS85t/G4oXlKfshhXK9H1f18jRy
OyeYWxFn6jMCN4QbZnuTGvkQiYqhD7gH+XZroWkfLFxODhrgxAV+6xPrtawKFLn3
GtOvRWLcYHRQxqAx2rT43CT8XPoY9LhyvWzB23ddkmwFIX1Yzc/Up8QrJ3LIvhVO
1CsxhkHEwMOcNrFOZJ0Lykrl7BFJ0Nltb8jiEBJH73SPbBffNLd9XtSI9/2AkwEA
q+AJBg7EPQw0QsjVCyLt/5cwcxlWAtR7uFAQaj1cUy8A1/l0LviDxxZ6mSikBodI
G+ENvwe8LN/R3ksB9ZpY31ymlH16CuV/+OJbibt50SKv/+bNU0Yd2BpEkkCfJgG2
ycUtRHmNzWVe7bOPAEn/xIxKNxkXuuBOIfM+ueq0smGdr4/KtCloaCksK5FO/bDj
LQ7acljTy5mrnEJkWwm2pmQDx3PvOg6bhVehRRI24ZFm9l7/dQ/yJHX0u0aUT5Xs
3qgYbOMZxmhqFJU4FUhTW87PpauIYe4XEWUD80vJ/9ZISZIZpvHu5y7TXVVoFDPb
KdcmVSjl1Swvp64/ulzn
=lcP4
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_10_06_25_+1100_HEgG0i=jaSiYrDYo--
