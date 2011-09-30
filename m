Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab1I3NTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:19:33 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:60441 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214Ab1I3NTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:19:31 -0400
Date: Fri, 30 Sep 2011 23:19:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110930231906.7859fd1df20e5609301b3646@canb.auug.org.au>
In-Reply-To: <CACRpkdYkVOxHhyV1yap20YupFdw_ux39DqMK6wLb+LR+EHRusg@mail.gmail.com>
References: <20110930145042.4a7ee530848262294b297939@canb.auug.org.au>
	<CACRpkdYkVOxHhyV1yap20YupFdw_ux39DqMK6wLb+LR+EHRusg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Sep_2011_23_19_06_+1000_UIwyr9llX5c28N/u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Sep_2011_23_19_06_+1000_UIwyr9llX5c28N/u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 14:52:28 +0200 Linus Walleij <linus.walleij@linaro.org>=
 wrote:
>
> On Fri, Sep 30, 2011 at 6:50 AM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> > I have applied the following patch for today (Linus, the
> > drivers/pinctrl/pinmux.c part of this can be applied to your tree).
>=20
> Thanks a lot Stephen, applied and pushed this to the pinctrl tree!

You can't apply the whole patch since export.h doe not exist outside the
moduleh tree in linux-next (did you try to build it?).  As I said above
only the drivers/pinctrl/pinmux.c part is applicable to your tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Sep_2011_23_19_06_+1000_UIwyr9llX5c28N/u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOhcHKAAoJEDMEi1NhKgbs2RIH/2sCJZKui/MbX46lZn/uxiKp
PKoU+wyQju5EHCDGQ2Trpxh2Q8TS5OdId/wzrCqebzsL4edc2B0jbaY1SXt8jopD
rFxI26WSM1/k8gtjVamEiuQRO0ZACW4Bf62/HiBiNebwYadWFk6uzsdDmtvBVarx
OwUXtftAqw8SymssCNJmMNsTRhH/7VG8yuxn380xPZV12coWmjT9hvN7pt2cXp6Z
vAUlnXSZ2guosoLzis1DfRw9qt0YItNs4/Os6uxTn+2NOSDP4+bth/cMNO4514e4
+Zt11XQhWR30dMKZuKoA6kIdK5k99CoytloKyDWracXNk+d8H/ItxluHWJdp5Yw=
=gpG5
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Sep_2011_23_19_06_+1000_UIwyr9llX5c28N/u--
