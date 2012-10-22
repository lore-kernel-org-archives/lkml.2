Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab2JVNaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:30:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60879 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753708Ab2JVNaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:30:07 -0400
Date: Mon, 22 Oct 2012 14:30:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 1/2] ASoC: Ux500: Fixup use of clocks
Message-ID: <20121022133003.GF4477@opensource.wolfsonmicro.com>
References: <1350909125-20189-1-git-send-email-ulf.hansson@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TD8GDToEDw0WLGOL"
Content-Disposition: inline
In-Reply-To: <1350909125-20189-1-git-send-email-ulf.hansson@stericsson.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TD8GDToEDw0WLGOL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 22, 2012 at 02:32:04PM +0200, Ulf Hansson wrote:
> From: Ulf Hansson <ulf.hansson@linaro.org>
>=20
> Make sure clocks are being prepared and unprepared as well
> as enabled and disabled.

Applied, thanks.

--TD8GDToEDw0WLGOL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhUoLAAoJELSic+t+oim9hNgQAIf7W1jEvUtmxfv38h1lqH+C
RZMA0c0TJlJMup9bAiaaxPZlJahkIHqWFi1zp847HCsqzX6z+seUJ/z/B0mO52Ei
81DUfjkytft3P3TP9Wov8hNChngvqAKhG3fU5hcGwykDAYSkPYVkVWA3RFeZ0Vls
Fr9cajkDqipIzcv1O1JShsVQD62ZS2DZ8X+Q19OruZFKZ9rCKZeeA9zaFqqTReGr
OPZaZw1PGXwoclRQnq+KtSstIo3J6YrNYCT6aOvUVVVGeGusWqP3GCsOjF1ZKBY2
jfy2ZSPvG7WmoDcxQw+bCOF+eU0Ns1E+lKyxYMt5uIibB8cSR7PpunuRFOVCch3k
yNKESDKmBobGsOrA9loAKZixLXbZNtmZ27TRLWtGw8HqL517fXbnErwzYr/H6T07
jZ+C1zY9iyW2/jfns7SHh7dssyZm2FyiShCUeOCrbX/zhViNC0Kcx3vEeuDFD24V
KnFZcPfSJAvPHLarJbLOqp5JnNFv4jXSnWhUV5yliTBslFKdtMEB41S8INasRX9v
+5BdRIhTwCHmkipgqEBeDzdGetKa3NukPN9dwWuZXyeo1GpOzz5CAPIZVntDk8uV
mN2TLzoSwDVMt0aEf+weRnxmiMBVJFdZf48k/1wyCT+52XahOlYy5g+7OUgXcEll
cOUBYj3yz5dz4TB2+Eic
=Jxaq
-----END PGP SIGNATURE-----

--TD8GDToEDw0WLGOL--
