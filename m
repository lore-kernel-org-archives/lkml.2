Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1AAQZP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 11:25:15 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34273 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab1AAQZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 11:25:12 -0500
Date: Sun, 2 Jan 2011 03:25:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: yotam.medini@gmail.com
Cc: Avery Pennarun <apenwarr@alumnit.ca>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org
Subject: Re: APM_CONFIG on x86 - Is it possible?
Message-Id: <20110102032502.e579f2d0.sfr@canb.auug.org.au>
In-Reply-To: <20110101000558.56c77a55@janini.home>
References: <20101231193858.2c742025@janini.home>
	<20101231103345.baba0f8c.rdunlap@xenotime.net>
	<20101231212800.1e47f200@janini.home>
	<20101231113954.dc9adbdf.rdunlap@xenotime.net>
	<20101231234010.0165f0e8@janini.home>
	<AANLkTi=GY+ZFNMCdCQAj7aL6smUmiJZ=a-kcc76EECj7@mail.gmail.com>
	<20110101000558.56c77a55@janini.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__2_Jan_2011_03_25_02_+1100_o0cN39iJKPTT4EPe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__2_Jan_2011_03_25_02_+1100_o0cN39iJKPTT4EPe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, 1 Jan 2011 00:05:58 +0200 Yotam Medini <yotam.medini@gmail.com> wro=
te:
>
> Indeed:
>     $ dmesg  | grep -i apm
>     [   52.897795] apm: BIOS not found.
> I will try to investigate this.

Try building APM into your kernel instead of as a module and see if that
makes any difference.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__2_Jan_2011_03_25_02_+1100_o0cN39iJKPTT4EPe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNH1VeAAoJEDMEi1NhKgbsoVUH/07JRRmLtad287sYF67gjxza
4/sCDhxNiQTxd4ock84t83Y03grDHtQ6PtnTS1MrQS7+X56y3Gtqrtj7KSkYx1Ag
KGw86asVhFGDD3odOijI/XvDk29hZQYJj/ci6FyEVRTb2RHTV0Y+nmKIFVFz0Blf
E5eEOiuHTvOyLJTANC61lNnaJCxtwOY53dh2y5LaRizHbrFAHeviVMJni0m8UZyR
kzaeNjLa3lzgzCk3TPLOIg+MsQWJDUzqqNamPjF2vYDNM1BL8pSQcffae/b1NxNZ
0RlqTyGj2kjwxMRKpCmy8dtjnaGRym9ZfaayU0BsLaPlOS5N3+SJPy+XGF5Kf98=
=6GT5
-----END PGP SIGNATURE-----

--Signature=_Sun__2_Jan_2011_03_25_02_+1100_o0cN39iJKPTT4EPe--
