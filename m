Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab1HXBMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:12:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37231 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab1HXBMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:12:10 -0400
Date: Wed, 24 Aug 2011 11:12:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: manual merge of the pm tree with the mfd tree
Message-Id: <20110824111201.75aac21e4e4ed697011a093d@canb.auug.org.au>
In-Reply-To: <201108240016.33529.rjw@sisk.pl>
References: <20110823135619.be8b64d2eec7cb78bc0160a8@canb.auug.org.au>
	<201108240016.33529.rjw@sisk.pl>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Aug_2011_11_12_01_+1000_Tb_x8K4oICxzJC9="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Aug_2011_11_12_01_+1000_Tb_x8K4oICxzJC9=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

On Wed, 24 Aug 2011 00:16:33 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> On Tuesday, August 23, 2011, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the pm tree got a conflict in
> > drivers/mfd/twl4030-irq.c between commit 99efe0d4c992 ("mfd: Drop the
> > twl4030-irq kthread") from the mfd tree and commit febab68efa45
> > ("freezer: don't unnecessarily set PF_NOFREEZE explicitly") from the pm
> > tree.
> >=20
> > The former dropped the code modified by the latter, so I did that.
>=20
> Thanks!
>=20
> Unfortunately, I don't think we can really fix that other that making
> one tree depend on the other.

We can just leave it for Linus to fix up during the next merge window.
After all, I figured it out.  :-)

("git rerere" takes care of fixing it up for me from now on)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Aug_2011_11_12_01_+1000_Tb_x8K4oICxzJC9=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVE/hAAoJEDMEi1NhKgbs7/UH/2sl1QULs1/woCFttAx7/o9y
0Rg9Zr8sA5DVxJAgvuGFpFr9NUUWGhjahpKRQWKI5g09JKF/EjcEhAAgf1Y9tFPd
hFw/4tzTZaBT4XA+AlqJ5GDGUmPY6HrSrPwja/57ACprvNSifWSr0kGDa9DigFki
r/7es4eK9afXPtoawfRCeUW915ORFEq1uHg+Jpw6vgLPlY5kwaQR+epBAb5kj11d
nT/AiAIB0j2ywa/VQWQqA9FXxLBTKqnQhKv1kvCJ9vt4AyAAQv1/ZcS6hBtyCbc0
3AOqu747UBGtRC3khWZ/yJtDFxJk/1WulrGAAxhY5Gzj4qTgY45TbY5CXoUvA38=
=Q1Q1
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Aug_2011_11_12_01_+1000_Tb_x8K4oICxzJC9=--
