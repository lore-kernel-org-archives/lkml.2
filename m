Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab1FOMlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 08:41:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38773 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab1FOMlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 08:41:46 -0400
Date: Wed, 15 Jun 2011 22:41:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.0-rc3
Message-Id: <20110615224139.96a28669.sfr@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.00.1106151111200.18110@ayla.of.borg>
References: <alpine.DEB.2.00.1106151111200.18110@ayla.of.borg>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Jun_2011_22_41_39_+1000_2=sD6fKDqFZJ9VJt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Jun_2011_22_41_39_+1000_2=sD6fKDqFZJ9VJt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Wed, 15 Jun 2011 11:11:54 +0200 (CEST) Geert Uytterhoeven <geert@linux-m=
68k.org> wrote:
>
> [1] http://kisskb.ellerman.id.au/kisskb/head/4110/ (107 out of 108 config=
s)
> [2] http://kisskb.ellerman.id.au/kisskb/head/4019/ (all 108 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/4085/ (107 out of 108 config=
s)

Hmm, the web page says that there are 107 configs.  The extra one is
systemh_defconfig on sh4.  Not sure what is up there.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Jun_2011_22_41_39_+1000_2=sD6fKDqFZJ9VJt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+KiDAAoJEDMEi1NhKgbsydMH/0a21bYPbnuFh2Vs/TIkTrQJ
CCk4DX124TGQ3hZGiUllv5OsO83k/ADht9nIKBfuKAj0Eekz0uRRnJRJF0AxZwHS
h3nHgXcAQ9lJy4WUTN9COoC4jifOLpgX+j7aCxWsWcR5JeUIk1UzbJ7HD41jZGDG
vFHJF5E7RxAjvwCyTi7qAWP3Dh6y9TU6Tbjn246Seg8Q60ofUmnculdu+bX5zteo
QwXt+2tI9ufkebFZ4K4C4OyWTqDxuvtHtl3LMu4WedoslyY9SAtJTiy+yT1Qq2Ud
Fyj1Xs0ZJHrrWVkdnH+nWcs3/LurctUWNEZtjKpztrHqFXKJ0CGPv6HxS4RjpR4=
=TkEm
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Jun_2011_22_41_39_+1000_2=sD6fKDqFZJ9VJt--
