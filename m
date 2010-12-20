Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab0LTUtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 15:49:22 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54382 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933127Ab0LTUtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 15:49:20 -0500
Date: Tue, 21 Dec 2010 07:49:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 20
Message-Id: <20101221074914.a53c1e19.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTikerjf=yEyeq8cy-_yPRLcfx01=1M9x9sYJ2kEv@mail.gmail.com>
References: <20101220200013.df8fbc88.sfr@canb.auug.org.au>
	<AANLkTikerjf=yEyeq8cy-_yPRLcfx01=1M9x9sYJ2kEv@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Dec_2010_07_49_14_+1100_Sxu45fpfWpG/7kWd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Dec_2010_07_49_14_+1100_Sxu45fpfWpG/7kWd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 20 Dec 2010 17:14:34 +0100 Zimny Lech <napohybelskurwysynom2010@gma=
il.com> wrote:
>
> Looks like something is borked
>=20
> Fetching linux-next
> fatal: The remote end hung up unexpectedly
> fatal: protocol error: bad pack header
> error: Could not fetch linux-next

It works for me now, though it is slow.  Apparently the kernel.org
machines are under quite a bit of load after the recent Android release.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Dec_2010_07_49_14_+1100_Sxu45fpfWpG/7kWd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJND8FKAAoJEDMEi1NhKgbspbcH/jlpW5vxRVV0K1Bz5R6hNBJm
d+zDTy9m/xVBZaz8F8Ule5rtdUdTIhb8ujpI+RIJZQZcuwnFmjDENuadbbNXd4cp
p0gzqgmwsCioUkvMDzFifWC/llhGbYsCGoOa/Zy5DG1iN3CY9UAtaPJQ5OK0QOjA
N7y5rMgpv8CKM1T6RnfGaIxiQMx4uCrhsRSVa0WkpqJG/CgBnJf2zQen2c2kgXm8
QFVDouy/Dfx3hl3LWxa1CriSU5jxMPQjjpBz5Cd9iUNTs/Yyj9EoAKMmWIHqnl4I
lRHxTCEtKjpzS1BrzpnFF35TAyZYdC7loUrXvEyK6qWdrLcg6UnjWUk6z4jRbYQ=
=44ZF
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Dec_2010_07_49_14_+1100_Sxu45fpfWpG/7kWd--
