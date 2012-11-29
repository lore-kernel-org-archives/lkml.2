Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2K2Gsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:48:40 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57886 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2K2Gsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:48:38 -0500
Date: Thu, 29 Nov 2012 07:48:32 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Greg KH <greg@kroah.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: linux-next: manual merge of the pwm tree with the driver-core
 tree
Message-ID: <20121129064831.GD28582@avionic-0098.adnet.avionic-design.de>
References: <20121129162945.ee9cf8d7620477159e038ccf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g7w8+K/95kPelPD2"
Content-Disposition: inline
In-Reply-To: <20121129162945.ee9cf8d7620477159e038ccf@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:kQN3h91j0fNpjQjerE77/1KDXLPEtBwvS1xH63Sv7OR
 AkwzeXAtdfkH0tHFGMXockcRPrmjVtM8Gu5Yll2iLLGGs3pBHU
 UlIc0IUeOPBlE91T6Xix4rc5KPSAFDsVSHe4AT1E3iIHlQDCj2
 pN+uLWVWUy5c8DZ7ZSwGfxDzTjqpGv1VVDd7pLUFwVxe9ugMP1
 IVc7VppEJyILXGxxQ4o1fcXIsHc+dyCtlJpWyv5uibV7LimM4D
 lmawcL7VTRYrB3UycvYE/2GALT3vWsZxFZprnFTSHj30XTJ+cv
 h+2yue81RJ/073FcdtcPaVuishr5am2dmNgbFU7+ZarrkDmixb
 G9HCfUuhV0Gr+wonhnt5uDb4+StUJ2CURf2939OkGhCDsWo+uq
 Fuka7Sq6y/ikY3RsUOwQcWK8LGN6LHWDJo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g7w8+K/95kPelPD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2012 at 04:29:45PM +1100, Stephen Rothwell wrote:
> Hi Thierry,
>=20
> Today's linux-next merge of the pwm tree got a conflict in
> drivers/pwm/pwm-twl6030.c between commit fd1091125a1d ("pwm: remove use
> of __devexit_p") from the driver-core tree and commit 6179a58ec7e2 ("pwm:
> Remove pwm-twl6030 driver") from the pwm tree.
>=20
> I fixed it up (the latter removed the file) and can carry the fix as
> necessary (no action is required).

Great, thanks!

Thierry

--g7w8+K/95kPelPD2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQtwU/AAoJEN0jrNd/PrOhUrYP/jNWpFGp4oM+9joVT0QCE/jZ
U/SbQEBSL80Hzo+R3d1AACKvrccw0ouaUINKn0z8KVhagXVj2J7V0HOYGqEkmb+T
htaO3nxh1VtReeywAjz7ohG2Af2Wphbd//ePIepKCkZF5GQK32zwJBu8cNBdX7++
RqSVyUZtqQK6cKOlprx22CIg+yDcRgNd7yuOI49/zbOt27/4MTrPXyOb0uPpNYEg
h8LFvI6+F4eZZgxWhPANddn2y/mhCMo9ZFx8wl9uWbSs7OMlyzCMjY645hED1Jc6
ikMPrNJDRyU6ExmgnkkFVdz6pnaR785mnsiG+HkXdKA/5eS4BYIR0kRYGKsIPoZp
7NuUIFzerbDpiyxkvuYhTRY1fE6HvAnGs1z38GpcIvslVyL/EZ4PTWLzNBxWokI1
4cSS371R7pzEjkRJjBkpX8mPrv+hFQqjzs10enJf3llu3td2xh7irTrG0wEiTigt
+hwt9sar52sT0QnOeQCTRwoeeGUXT8p3swAvmNaj5ii5h7U/J1SMjbYgyOmBST5U
uCs8V1CAQGAm28jfPWBhu6X3yDFpeP5/DA9LradKdw603vYf0kwNyaio/s1DnKQr
YZ5Wh42KN6ZRt/W1zXpN5jeTtDWBzq8jppTuhZNPxIEr1WVOvz3lYhFF9hLiXNKq
idjUlOwQtRVpuzH0YP4c
=nKhl
-----END PGP SIGNATURE-----

--g7w8+K/95kPelPD2--
