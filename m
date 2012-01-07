Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab2AGGsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 01:48:21 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:42740 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2AGGsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 01:48:19 -0500
Date: Sat, 7 Jan 2012 17:48:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hui Wang <jason77.wang@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120107174806.723b1d9c2f7ddbe74a491591@canb.auug.org.au>
In-Reply-To: <20120107054829.GF4790@S2101-09.ap.freescale.net>
References: <20120106120345.8157a839b1c924315d728eea@canb.auug.org.au>
	<20120107054829.GF4790@S2101-09.ap.freescale.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__7_Jan_2012_17_48_06_+1100_oVfdZH3YCkrpmYZD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__7_Jan_2012_17_48_06_+1100_oVfdZH3YCkrpmYZD
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

On Sat, 7 Jan 2012 13:48:31 +0800 Shawn Guo <shawn.guo@linaro.org> wrote:
>
> On Fri, Jan 06, 2012 at 12:03:45PM +1100, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the arm-soc tree got a conflict in
> > arch/arm/mach-imx/mm-imx5.c between commit 9bdd46257ab3 ("ARM: plat-mxc:
> > hook special idle handlers to arm_pm_idle") from the arm tree and commit
> > 010dc8af8f28 ("ARM: mx5: use generic irq chip pm interface for pm
> > functions on") from the arm-soc tree.
> >=20
> > I fixed it up (I think - see below) and can carry the fix as necessary.
>=20
> When I was testing this fix on next-20120106, I spotted another compile
> error from this file.
>=20
>   CC      arch/arm/mach-imx/mm-imx5.o
> arch/arm/mach-imx/mm-imx5.c:58:24: error: redefinition of =E2=80=98mx50_i=
o_desc=E2=80=99
> arch/arm/mach-imx/mm-imx5.c:48:24: note: previous definition of =E2=80=98=
mx50_io_desc=E2=80=99 was here
> arch/arm/mach-imx/mm-imx5.c:48:24: warning: =E2=80=98mx50_io_desc=E2=80=
=99 defined but not used
>=20
> The fix could just be removing the duplication.

Yeah, sometimes (I think it has happened to me about 3 times over the
last 2.5 years) both sides of a merge will insert the same function and
git does not notice (they are to far apart or the context is not unique)
and inserts them both as part of the automatic merge.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__7_Jan_2012_17_48_06_+1100_oVfdZH3YCkrpmYZD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPB+qmAAoJEECxmPOUX5FEGLMQAIsOD2e0QUYmf2E2pytA4xme
Wvuz/XvU32VWnbMptMdXgrNedn4CfW5fvTBb1T4XUM4R0yfn9w0h8er8bbyNYoCl
qWgM0Y7twr78z3V8qNmefKWEX2XBfreiefRZka/1y8moOwl7MHUKbcBHp1jUb1ef
SnJ1wFL48Knva1dtbj5Lvgj38nM0RUrSVMX8EwCKBVQABuu26PPqpDLJrJ8dsVQP
+5SSBCQ0czKkx1/YetP9KN6oFeLBmRK+NXwxuCXQCiaHVPVSZLOOl2m7QXO7eC+j
PB0E5QiyF8hOliTmPDZDx2/wv9S6zA9zs5aIdN7sRB1VdlIO4jX3nbvlcwX8SHR0
6kc3uVObo8ppDI1F55h3ZpCYsI7rQvdl8l3h4N2Q1Fh0Gi+Cr0kqYLZhdlqg+dlO
xQJgFG8axl/fDossglwp9lmOeU08J1TM7YBsvAoR6BPuzH487TGbMNqrMAFnGHAu
QfQlGXNzcnH8yafQvpGmrlcLAJ3HhkcWuyswu9Vta6IRbpck1N41W/RcoaooQTmz
3VT5dEN15ty7cdLYVIK4tALom5BecCBjfeocbkXgVIMBpNV99gA6ibFA3BR6X91k
orXAYmzYlf+6oUImvLwBisRPI2n4hy1fY1QbLgP6Hzdg1MIKBUukgZ5wQ7Jtco//
fYTvu44WNg1xpSc1HQa9
=AA58
-----END PGP SIGNATURE-----

--Signature=_Sat__7_Jan_2012_17_48_06_+1100_oVfdZH3YCkrpmYZD--
