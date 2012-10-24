Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654Ab2JXK1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:27:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43787 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933801Ab2JXK1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:27:10 -0400
Date: Wed, 24 Oct 2012 11:27:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linus.walleij@stericsson.com, arnd@arndb.de,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/2] ASoC: ux500_msp_i2s: Fix devm_* and return code
 merge error
Message-ID: <20121024102707.GC18814@opensource.wolfsonmicro.com>
References: <1350306806-5688-1-git-send-email-lee.jones@linaro.org>
 <1350306806-5688-2-git-send-email-lee.jones@linaro.org>
 <CAPDyKFqrS0QT+UO0L3B29UcnjX0bSv3XvWTmC6E_ubgr8NTDiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
In-Reply-To: <CAPDyKFqrS0QT+UO0L3B29UcnjX0bSv3XvWTmC6E_ubgr8NTDiQ@mail.gmail.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 24, 2012 at 11:34:00AM +0200, Ulf Hansson wrote:
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
>=20
> I assume this shall go into 3.7, right?
>=20
> Kind regards
> Ulf Hansson

You may recall that only yesterday I reminded you not to top post...

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQh8JhAAoJELSic+t+oim9WV8P+wQMhXFAqro5p8jxTp4gYKk5
NhIHI6HLEDH52fOIP80p5wNOAVb5ZlD2A+PCAIU3eTqpDOzQdXQyQm0Ij4fs6C1T
/nKjROiiuCOZxsWscf8hTgdJJEaQGxkqEhmkibmF0NLwLjIlDGBvny+TswJSo8TZ
Zw4N69pQofBnWTTps1OM5W4J0Z4CuQduWwg2R8J77wUkpXtIhSwcR46dS7eaiCHv
25aAi6p4GvtK0WtDJl8vIcIVgy1hSoXl7JivswEAjBPMmaT942owfUJyc/DssMsp
l3S9E4jxxbv9GBYwP1bsYau5kNcP+BvIGzJtkZk3VD6Ew3ABuuTQNu6dNtrK8GwO
teSY0yQsQ7EEi477PmqWOeWJr3qkybNbxGZrMMaz+M621BGSaJWnpuz9tiCycT5s
02BWFjHWqsJGNFDBmRjkz5KqvfI6hYNXGmQ0mzy8sRSq1ZvMhwcM1YArUeAv3+So
5+lCIkld9aOR6NUMzZG2M63/Zc9KcSLG5Rf8QGa8hFHzvLEH5xEcKdtgALy7xsnu
q+KrjOl83pFewSsjlc7PISeiEDOrlRO0Z0qR1Z7p1G7+x6THiIeml0FPF1Alo6bs
TtLd4eYGOsAfpRYrZYUNnFrkotgQ618BYkGyAeKBzhRYBEf2Onk7fsytn7S/rcz/
neyuve9O/qdg2C2jBv7n
=SD4v
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
