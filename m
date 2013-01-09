Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab3AIHre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 02:47:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54052 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab3AIHrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 02:47:32 -0500
Date: Wed, 9 Jan 2013 08:47:27 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCHv2 2/2] pwm: vt8500: Add polarity support
Message-ID: <20130109074727.GD12782@avionic-0098.adnet.avionic-design.de>
References: <1357155856-9552-1-git-send-email-linux@prisktech.co.nz>
 <1357155856-9552-2-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XvKFcGCOAo53UbWW"
Content-Disposition: inline
In-Reply-To: <1357155856-9552-2-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:2rMFDLICUD2uo9C2BBIcHfeo/DGeujjs4yHrS2v/7A0
 b8WC/8duJCCeCcCTqJgrg6ZhkhTaskuG/eeNVwoIgys4Cf5ry9
 eMwS8OLYN7QkjVxHkJgPvjPMBtMzh1ovles7IZuUvzpx8w26So
 ttT5mzdSXkK2lCOxCy0/TpSzYuX0oyoWNDqVyrbU7DYPTay8uS
 n/PBjmFcp85w6E3JesPRVNdugNjdnfg5EY4FpQdtyB0q+mUky7
 gkia/czAwUl7LW98ig7lbwhLzGsGGds4yPPrjjx55Xq1kb5Y2F
 79zINcDoA/e85B02tUqHahJpG5NfTi9NVOHS3mh8Ndt4mOiNTb
 JHi+b1+YXQbEs4DkoxwpJ+s3+it6sdjVu+o+UGYM6wfIKQvwx0
 HVXReCHL/CIU8+T9AX14liQzwd9HNLw568=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XvKFcGCOAo53UbWW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 03, 2013 at 08:44:16AM +1300, Tony Prisk wrote:
> Add support to set polarity on PWM devices, allowing for inverted
> duty cycles.
>=20
> Also update the binding document to #pwm-cells =3D <3> to allow
> passing the flags from devicetree.
>=20
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
> v2:
> Change binding document to detail flags usage.
> Add missing .of_xlate function
> Add missing .of_pwm_n_cells
>=20
>  .../devicetree/bindings/pwm/vt8500-pwm.txt         |    9 +++++---
>  drivers/pwm/pwm-vt8500.c                           |   23 ++++++++++++++=
++++++
>  2 files changed, 29 insertions(+), 3 deletions(-)

Applied, thanks.

Thierry

--XvKFcGCOAo53UbWW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7SCPAAoJEN0jrNd/PrOhv+0P/1T/0XqBSovl15Oa+Eh+3iA0
M+9qN1w2UVnIH0oAn1jbCdaPZSH2/Pi2JTGBGmTx3Z5cpi2wvgfPiyGFiRFTJUG1
1rKwA3FAnZaMLbfrDhC2fTQmCEFPJL57yMF4FigGYiTUoDcgIMiNSzZR3XMwVvwB
kFlNguLzB4uDpMI4L2FCfPGeSfmypmQ/vkixE2L+5nXswnb0gpx4kOWmIzXFxCHv
SJCH9Cw2rc/k1X4Shzw8ZYRIvwLQQiyPfh04X1t1TQ1/zWZE6LmcTfmkrMH9ALPN
6BkJv1f2SUGjGhUUnYPcotoCfdtcqJCHz3OzP2ds3YCszGqfsvLOFh1de9hd/qAE
Tl24daeyHHGzvwrqZgUQuydIs14DrU5lHiuFpJsGF9xw33KO9DxB/WPu9KOHuohO
MF8+zQlUw4aYpvK4wiHBtzZjM/khdUoPiOcZwg8Xms+Z3C7MILq/oTLM3E3sIgj2
xcaVzvn26vBAARwpWRLZhvg00MPqP51QSKd3U+MSzZv0AVFKeRMv4kl0iH03ysi9
rhtpXtf6ZxRrlc77esLbdiJiaeOCsYmmXJmpUG8W+nPMb1ngzA90QhiqyJE5G0Yo
XRyy1ghSZ+d+w9HWOfaSdpqfjpeT7DGZv13Ci+IQo8twlAD/03ULq7KRvGk3+IQi
Ob/BHNODYxVII0Ft1psT
=LPLQ
-----END PGP SIGNATURE-----

--XvKFcGCOAo53UbWW--
