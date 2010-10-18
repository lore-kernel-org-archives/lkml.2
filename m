Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0JRDjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 23:39:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56779 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab0JRDjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 23:39:32 -0400
Date: Mon, 18 Oct 2010 14:39:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20101018143925.9e104b48.sfr@canb.auug.org.au>
In-Reply-To: <20101018142934.65f5d0fa.sfr@canb.auug.org.au>
References: <20101018142934.65f5d0fa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Oct_2010_14_39_25_+1100__5NMnk47qt5ARXhh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Oct_2010_14_39_25_+1100__5NMnk47qt5ARXhh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 18 Oct 2010 14:29:34 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the sound-asoc tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> sound/soc/codecs/max98088.c:28:28: error: sound/max98088.h: No such file =
or directory
	.
	.
>=20
> Caused by commit e65d255a5a610ce9e185e0df855250706aca7c21 ("ASoC: Add
> max98088 CODEC driver").
>=20
> Please, please build test what you are submitting.
>=20
> I have used the sound-asoc tree from next-20101015 for today.

I have also had to use the version of the sound tree from next-20101015
since it had merged the sound-asoc tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Oct_2010_14_39_25_+1100__5NMnk47qt5ARXhh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMu8FtAAoJEDMEi1NhKgbsaWcH/2sNbIor9KfCjENr8sk7b99P
JBkgDq+nmeV7uk7mZLqL/a0wyQBb6ziy+FYPthkNIucWLg8gEcDvhmzPQap6mZ1M
5DX+wuou3LzeQ6h6ctwBG8xOJ8dhkgsTaoj4le06L+jS1hPQ5tUzh+8iLWvejgJK
8sDtfOmqlsrLPs2k4p/6eUDkEGyM8xe1qahKL6mw+AD5LlSAolFBFUxv6JGFy+zG
2SMHWp4cG8et1KxIis+1khq2RkrZ7FeZdXvtiGgGb/E0/taA+s9VJVgwpuzFgF8z
a3n88GDLDRnQ0Z2OLoNuMKghhzYhOlZ/EZGG8m3xcWOSoEcW8Jp66j2i3zU2usI=
=935c
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Oct_2010_14_39_25_+1100__5NMnk47qt5ARXhh--
