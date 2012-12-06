Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2LFH6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:58:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56331 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab2LFH6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:58:21 -0500
Date: Thu, 6 Dec 2012 08:58:16 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Roland Stigge <stigge@antcom.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: [PATCH 0/3] pwm: lpc32xx - Various small fixes
Message-ID: <20121206075816.GC25316@avionic-0098.adnet.avionic-design.de>
References: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f0KYrhQ4vYSV2aJu"
Content-Disposition: inline
In-Reply-To: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:4bDo5+0yUL7UJCnXU3XG96O4jdv6R7bh73bS4cCmk1K
 HdrJPScxFSUY+8LSEi5iWmYqkAewq8Gtu1D0H4LWfddn9NcDCQ
 vFSYWei+l+GmS9nGOvwMCdVR9/T0HONJnKwjigSDEw5TV8x4Ut
 FZiV9DWVTdUc8MWa1imPEpcFhbTTx9QzBReb9AbEy6Oc3t+Rpv
 bFZbtf8ODwvuLaTMpy+Do/GLMj6CRNDRiwERBx9gyBencuU0oX
 MkreJa6pc8CRh+yo1n2aZrTE/0tEU6Efznfk3w3kAtldWb5Scj
 fRsaGcHIrNeGzjEe/7Hhjhf4WRmI79VNHyLd5aBLCVic7V5Kcw
 VUrbGF0Xb3wzqlzUdlg/L4FhxobDmVQiMp125u736KYtLCssDM
 URaHC5pxpte/mVLYS+y3i9ibkq2FY5k8FI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f0KYrhQ4vYSV2aJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2012 at 12:58:12PM +0100, Alban Bedel wrote:
> A few fixes for the LPC32 PWM driver:
>=20
> * [PATCH 1/3] pwm: lpc32xx - Fix the PWM polarity
> * [PATCH 2/3] pwm: lpc32xx - Properly disable the clock on device remove
> * [PATCH 3/3] pwm: lpc32xx - Set the chip base for dynamic allocation

All three patches applied, with the minor fixes that Roland and I
requested.

Thierry

--f0KYrhQ4vYSV2aJu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQwFAYAAoJEN0jrNd/PrOht7sP/ilGvUm8ZeSYUIB1zS3r3vis
2Yki4JaQd5oo0y/z5E+8KpCzkpvFO2Np5CjsrlmJiM2Eplz2T7tITAkti6d/II+w
Oiv5y3XdNpxS1r5lbPgaxZhr/srfePUiEF3k395NKhxA9HP4QzyjSoPICqqLD8so
VC+uFQN6m34S7smE9pNf0oiyBEwUDlBsUQQH08FONKfboEBrC6mcW2UlA2IcXq0l
/uHDBln5i3LljDDsL8uIutFMVettr7gL+eKVvKq3//bjNqgwYoJYSFgho0BKVhal
g/rjanoErvtc0ddPTQ260SaSl5q7FjD90QGVciC/H8Tq1RWDUgGZXjaFN5lL7pkA
nk/TTWtN/wgtB6O2wG2FvS85r6Bi7xPkq6JK0kCMMutsPq7XoabYHKOyKsBSiLGs
vlWY25oQ9G75qPnXgJHO84ofBqPu6eANK+StgwUADt8uUV//i9Jz26jWD6u9oQ5H
QI6cqBSWvgs2uHPBGOggRmoFa+zn3yoNzkrArYKnJR8gMD+HCNeIBMzOlUw/AkAa
vlbnD3/vpmletiSDRoUXgxfG/fL85Ncjb9wJJA8B1Q1xY/qYRTrrHlfVJDF+MaWF
uTf/L4NPwkscTiz7Ls5C9nmk1iJn/ScvQarUmV2Y74CuxymJyaHIzjmFyxfuXMiR
mXIrFqh2jNOdI9TQBRq3
=Xd9A
-----END PGP SIGNATURE-----

--f0KYrhQ4vYSV2aJu--
