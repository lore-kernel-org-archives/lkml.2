Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab2FUJSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:18:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53623 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759132Ab2FUJSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:18:00 -0400
Date: Thu, 21 Jun 2012 10:17:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/3] regulator: enable module build config for lp872x
Message-ID: <20120621091758.GI4037@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FC04A@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Op27XXJsWz80g3oF"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FC04A@DQHE02.ent.ti.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Op27XXJsWz80g3oF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 21, 2012 at 08:03:36AM +0000, Kim, Milo wrote:
>=20
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

No, this breaks the build.  We can do this *after*
devm_gpio_request_one() is exported.

--Op27XXJsWz80g3oF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4ua/AAoJEBus8iNuMP3dhhUP/1kxMH90P7rAmvDyhdvlzSTK
Py8pJGPg/7XrPscU+dwZugP6EctGUPlWY+K/3Rgm5Z8I6navcBUgUg/Z8XGIbGqM
S12aQK9URUPUo8zFBVIpnD2gQTQQNefJgWm6KJRURooGZoARoy52orpsXeQubdUm
Kmyx1Pfe7jUIP7u8UMTAsU2ViWnPTTugkZmeGP7Xwjyy2UuVl5noiWySTAEwnYGF
1SpS6k/qm2IYTZOwrHYIQUC2AmQZr4Llr6UH+yg/GONQ9lBwFYrj700DlcGW1L+F
UMmJQRzaLuELbmJsRSa2Hc3YJOSnyVa9WyVaez0Ck+4N5UiL7iFcJNTJp3GAUuxU
WN+5m86lx/HX3bFL6VtlN9g5ZdS4YgFpO28ILgH1dSFCyixPWwDVWq+H3nDVg5eF
eaZywHtcNTMa2t6i/mU7m6XppLy1rPxIkinkngNHhMo9eYZ5FmHBidazzi0XdqC7
RN0ffZiplj2Vqy0W1qZJGgGzHLzxMT8FmpSMKeq7aYthTSeW+QnDivt7kPNUNfkN
GiF2W9Gpur4FvV5/x6a+63BFgSSiqSOXhhsTOX31PH7XP8Kyu4c2RpYO5urzZdEq
q5mhbQyjNAFFrtlM7XJ9GyaY0Swa52hsBOJecn4EKpdeoQF7/HlZYyUvycXv0jKf
7tBORYS+VDHF0O7rRuxj
=ikE2
-----END PGP SIGNATURE-----

--Op27XXJsWz80g3oF--
