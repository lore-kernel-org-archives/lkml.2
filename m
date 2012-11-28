Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab2K1J3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 04:29:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41405 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753637Ab2K1J32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 04:29:28 -0500
Date: Wed, 28 Nov 2012 09:29:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mukund Navada <navada@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] regmap: Add support for continously numbered pages
 across regmap range
Message-ID: <20121128092924.GJ32691@opensource.wolfsonmicro.com>
References: <n>
 <1354094577-14967-1-git-send-email-navada@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LG0Ll82vYr46+VA1"
Content-Disposition: inline
In-Reply-To: <1354094577-14967-1-git-send-email-navada@ti.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LG0Ll82vYr46+VA1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 28, 2012 at 02:52:57PM +0530, Mukund Navada wrote:
>   Page number in some devices increases across regmap ranges since the
> selector register to choose the page remains the same. So in order to
> write correct page number, the start_page_num is stored in
> regmap_range_cfg.

I'm sorry but I can't understand what this is supposed to do.  The
current paging code expects pages to be numbered continuously with no
gaps.  Can you please clarify?

--LG0Ll82vYr46+VA1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtdluAAoJELSic+t+oim9BQUQAJ5mO+jSqLg+otNLdL77suwI
nwzsOVbB7xBE/RDI2GkkEz88kJTkSmxyd91mJZpOsss7kSSDNo6jneYzyLsyDZPw
DU0Fd/YTDI7jcck1RJSy8z1A9a/vaOEeNXi04ivIpQ/IS1fOwY1i80IP6iUohUmJ
N7qNJrncZFxbWm49vJA6rayMuEK2CzEvOncs53ZbiK+LLDBqIy3FFYkpLQL4R2Uc
582aU9cWopeDXL6nHTFJK2YNOuecz/5OTmQThRG0SsXYyLC+Y+5cbEZTG/FaNyAw
sYrftD5eFFco8Ts4bgWMFWWX8ubn9+nW8neAmPH03yecYsYX2G3k+/WX4m0nybMt
Tg1X/x91PtaJedz0JiEZ76oNbHYmyzQhpH8NDbpW7+Yj0XRhpdf064CiOHGIH7kJ
SCEevuKpHrMNUt1bwB4SzjH9LiXTFBHHVnbMUZFGJFzvdbkEDD50F3U+3mqnXuNo
6LcMIZjdTZQWqpPsUigvlzQ88KE6O66wvpgW0MtdFfWDEsVhrrYu4oMqZvbA0XJi
eu//k194i1Tfc2mPdb+CmVJDCujZRPzLDvm/pBbhK7mPBKL9AbJ4elmfa0AD46eJ
HppLI/+TJ9Mokl+CDcgRMaQg9G5gAfL/jrU8vWDt6gYjgJAFVErj7N0B5Gqcd8la
MoUfq3cZfSlFsUMPYseK
=Q7jQ
-----END PGP SIGNATURE-----

--LG0Ll82vYr46+VA1--
