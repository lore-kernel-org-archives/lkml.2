Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab2GCFnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 01:43:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34925 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab2GCFn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 01:43:29 -0400
Date: Tue, 3 Jul 2012 15:43:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: linux-next: build failure after merge of the final tree (pwm
 tree related)
Message-Id: <20120703154318.9e32d4a490c0b32e7d955ca4@canb.auug.org.au>
In-Reply-To: <20120701065639.GA25470@avionic-0098.adnet.avionic-design.de>
References: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au>
	<201206301920.21158.arnd.bergmann@linaro.org>
	<20120630194139.GA24300@avionic-0098.mockup.avionic-design.de>
	<201206302012.32476.arnd.bergmann@linaro.org>
	<20120701065639.GA25470@avionic-0098.adnet.avionic-design.de>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jul_2012_15_43_18_+1000_mg8h.ytcjI5SBTwJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jul_2012_15_43_18_+1000_mg8h.ytcjI5SBTwJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Sun, 1 Jul 2012 08:56:39 +0200 Thierry Reding <thierry.reding@avionic-de=
sign.de> wrote:
>
> But if we make the new PWM symbol conflict with HAVE_PWM, then it'll do
> the right thing for any of the legacy PWM implementations, without
> having to track them down. Furthermore it'll also keep the legacy
> version by default and not allow the generic one to be enabled in that
> case. This is more likely to cause less side-effects than the other way
> around.
>=20
> > One question though: if the generic pwm implementation does not set
> > HAVE_PWM, how can a driver check its presence?
>=20
> The driver depends on PWM. HAVE_PWM is the symbol for the legacy
> implementations, while PWM is the new PWM API symbol.

I am still getting the mutliple definition errors from my powerpc
allyesconfg build.

$ grep PWM .config
CONFIG_TWL6030_PWM=3Dy
CONFIG_BACKLIGHT_PWM=3Dy
CONFIG_PWM=3Dy

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__3_Jul_2012_15_43_18_+1000_mg8h.ytcjI5SBTwJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8oZ2AAoJEECxmPOUX5FEkFoP/i+sS7E8wxKvpnaScdfyWwx8
rXwKJizBOgvcsdLkFrHV4XpBN006BBhkd3CfLA3PuxdBYLr4ZUIMmS0Z6jYgn3Ei
tNl8PJ5KHUHhjlapX5Yv7iQzsEprnPgEGF/+NAF4AFpRDQutI/2FeogodhIdLtqG
CBcvEQg90uzjEFRoDd7xOv/lpOLFJKPnm0G17vm95PnjKJSr4088FJXr544pF0EG
F+sMDbE5kvQfO2lkj0+yeOWMJqcmUZfm8+5TV+4JHQFsopFGUG10Qqslnd/t9/Ug
P8k9fCLI6Do2Ddt9bdRTQTlcSkx+jPJ1r8u1KI/aRZuG/uei2/VCwUWkJQgsFwH2
YJje+xYSnY0WPrHOPYeYAQPQ0d2E5us3BgvENHuC5o+WH/PWmOth2lZplcIS2dH6
NAlXmgGD5fS8PXBA173yRLXC8sF0arsDXMmVJTyK7XRsxNCzcn9qqaN819CYq7sN
yOWBB0HLcb3hTwPdK+ooq1AmN+Tp+Jh5VMy5RGjkJUrk5EVpLgKwNCoo0wi0h5Ob
Ck/E6Z2NxA/xFf162y75/Qbs5zLjeAy8nxmrdZPSU7rgzrM0QQkbkCvHfvXK7Xph
isNSJsAURzc7nblfpu7C2wD17aXrCLcigi7ASYjIpv0i2mj4Elhi8nHLiv9ra9cD
RhiStMWnLyIPACZQlrTq
=UVzW
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jul_2012_15_43_18_+1000_mg8h.ytcjI5SBTwJ--
