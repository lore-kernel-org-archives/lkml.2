Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab2KFGo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 01:44:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61438 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab2KFGo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 01:44:27 -0500
Date: Tue, 6 Nov 2012 07:44:06 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] pwm-backlight: Add support for active low PWM backlights
Message-ID: <20121106064405.GB14863@avionic-0098.mockup.avionic-design.de>
References: <1352130541-16819-1-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <1352130541-16819-1-git-send-email-alban.bedel@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Odcul1jVImrpoG3IaMG3AXK9XsLx/pofKs4KKGF5+Yq
 r9xzZ70lCHDPwosjI1XEoeUswgGIzu6OLjAbKV1R+3sIn4zyi3
 jCHG9u4L8MX3QVsKvjBm7CEarh2qFIX7MAQ+h+Lq0i1CLazldK
 NCVZ5kYxWnd9jd0n9w8KgX2BUV3BfkeVpVTdNhTOd5xUlQqpAd
 UVOHem9kkECWRZyh+gBEm8gFFyHoVdRatQ+DgbvUAiZTnjSDgQ
 +Sm/hHvUUc4OLQLG8GCdq1xPimN2rpapddA3IC96WV8h2fsBFW
 2aujAfsKdFUjCn7Cc+/n4u29lCWS2gWJvBoClqw17TH0Gee2tL
 RrOOIJbmUkEXvvGttZVP9UM25Zn55huOhZnN4XCo6NTz4xvOh2
 UFi3PBKClXLawR+UMbQVIpaKFRmC0dxw84=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 05, 2012 at 04:49:01PM +0100, Alban Bedel wrote:
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
> ---
>  .../bindings/video/backlight/pwm-backlight.txt     |    1 +
>  drivers/video/backlight/pwm_bl.c                   |   22 ++++++++++++++=
-----
>  include/linux/pwm_backlight.h                      |    1 +
>  3 files changed, 18 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backli=
ght.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.t=
xt
> index 1e4fc72..3a40539 100644
> --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> @@ -14,6 +14,7 @@ Required properties:
>  Optional properties:
>    - pwm-names: a list of names for the PWM devices specified in the
>                 "pwms" property (see PWM binding[0])
> +  - active-low: boolean indicating that the backlight use active low log=
ic

Couldn't you use the brightness-levels property to achieve the same
effect?

Thierry

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQmLG1AAoJEN0jrNd/PrOhbjkP/0QmIHo5x/iU8KQiwD9OdqCO
21ZW3WYJayD9CdGn2DdIYfm9bO5BZrL75cOyp2odPgn49nAiIWBXOqgIiwqvwZu2
D1rFspnczx9BADts97Y1mBU8xZPZfpvPUFhDSWSgkaqu3Y8Xj6IFcQzspSK7yhwL
4Y3LP/8tzsQDOKNkwc3LYcq03j2gJOTzVdKIRhFPYS6UF00WZ+17IgB6WsboZiLZ
zdj9HnWYJAzcbC8bR9d9Mef88fgwB9buz1zTy2aNgLvP/55+Qk8Uu9tFT8TZoWYr
ELGFrew19Ug/8quCtB5yCR+p+WNy26jpCWiP4FcOfyhLD8wMIkqwA5l7h2VYfvw7
2V27yEH97nu9OUYWQgzB/oKV3ShM8rDeph+lfHlt3V9RIxn7z1RWIr0UkPLjdflH
OGII1LnTYYKdy3GX1zFY3QlTIwikRdKiqbpERcn/sMmEci3tuuvI22xipqEOeKKZ
Ed2IXyCyTAH0zeeOEo0NpylLey6X9dE6Isl4hY82Ttqeae8xfGxTjppSfvTjbBJh
U/nPZ3mMZ87ppa0Scr9dw3BlyoE24AiUQXqgpxHAbXOhfpzJ7eThMXPoiimUd1Nq
2iIEG9uP4e5Xvy7GRN4ArnbYiynNpGnrcQLHIIMrDxonSyHLZzfGQTBwTqF9yzQ4
Dv2X41YY6Z+IMAfk0aCG
=WqTr
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
