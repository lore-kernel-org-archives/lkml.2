Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab2IGNL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:11:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57754 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2IGNLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:11:24 -0400
Date: Fri, 7 Sep 2012 15:10:37 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH v3] pwm i.MX: add devicetree support
Message-ID: <20120907131037.GD29340@avionic-0098.mockup.avionic-design.de>
References: <1346935695-25179-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xm/fll+QQv+hsKip"
Content-Disposition: inline
In-Reply-To: <1346935695-25179-1-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:9klrkZ24tTylmzWHKO9vXOzJIUrd86qIfRN4yo8Pbbl
 AbpEiP1joOinwP/zuxaHmVjqteVejy/zO5c+c3bQMDG2O/W8Vt
 TsP73/ZspgAia9xCDAWpP8OLpHaehzQTQ2BiLDUssMgC6bt9GY
 MtO6BeAqHg9Twy4/TIODguj5FwJ+6i3OubGU5enUOdZmbAnORs
 lY4uTAeXcUTvlKeWYCkks8Wj1Eop4nRkaTpJgCO7MJdNwNj6Hf
 tvuCMZbzvzKgwKuxLvrZEqIke1BrS/NPPlCEVOwiL5yNJKIDEf
 vcaYZ5GDsSs0JmHUeOyI1NCyIUYzLyoYZ6JRBFmRz7UtGTPGAf
 V2dLONErz1D8qedrBnH0/XrE8w/jSbIlWwbgpUEp/NfpPOFfPW
 G0wkf+DA1uKAvAClE5WGA3zHm6nSMPIkeO9BgYiiyVtfXULh6E
 EXLI4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Xm/fll+QQv+hsKip
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 06, 2012 at 02:48:06PM +0200, Sascha Hauer wrote:
> The following is the third version of the i.MX pwm series. I integrated
> the remaining comments from Shawn and Beno=C3=AEt and added their tags.
>=20
> So Thierry, please pull the attached patches. The pull request only
> contains the pwm framework specific patches, the remaining two I'd
> like to push via the arm-soc tree in case the i.MX5 also gets devicetree
> clock lookups.

Hi Sascha,

Sorry for taking so long to get back to you. Apart from my comments to
patch 1, I really like how this series cleans up the i.MX driver. It's
already a bit late in the 3.6 release cycle for these kinds of changes
and none of them fix any regressions, so I'd like to queue them for
3.7 after my comments have been addressed.

Thierry

--Xm/fll+QQv+hsKip
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQSfJNAAoJEN0jrNd/PrOhP/oP/iVQ16e+k680O2BwfMS6q/V+
9QePXB0jA8eXE9huEjZO99x40hOlXkHDW+jLCIryVBQQ7qvuTv80AUkUM54NkXaS
xotT0U45e056PN+3M0CUrXz1G3+a47jVCHzT1Sdx7BGmxNYVMDtFibmAVDHCcVqj
5ntkT79UL8KHFYev2fe86MtKelbU67dVZXCezLiNGFkZO4mtxNSLvGihAFo+nWFq
YJsYbbFNk2mGW584+hIJ7DcZkbyw/u1Z9Xfu1kJkYego4MCl2xQOki95GwsouyJ1
cNrLliR8VOgk2qY/8endjVNE+sqnaQrzA/mJoateDJmExwAcH2raWDcoMY3/KS28
pjI6tm/pD0+7sC9kvCXBn0q5LbUKrzlInv1DMSt5SKn1yLugWiAZn2IW6rEbnuIu
jh9WxerqXaZDpOt+H8fMHMofK+/R69/6/n6vS18nqf1pce1NDERZLTAY/tQfQrVN
2wdb2whXwejmfkX5TaaI8mAoofibaMcwqjF7iCBxIQTVJrOfkMWRjajpQBjZuXpG
d4fXKpW5XjKPZqS+QHlB5fzRuhKTOxSafVD+S/QQ248pG8cL56eaDoYEfjJu/w7Q
EDJHJS2B5gTmawuuwyGNrFqAQwj0Bh1QF1XXoMAWe8eeX9OeetLLnVBHiYEuwVlz
ZzV8o5VvUPA/4gcGNMjg
=k8qp
-----END PGP SIGNATURE-----

--Xm/fll+QQv+hsKip--
