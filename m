Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab2CTQES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:04:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57488 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754397Ab2CTQEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:04:16 -0400
Date: Tue, 20 Mar 2012 16:04:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT] regulator: Convert ab8500 to set_voltage_sel
Message-ID: <20120320160410.GJ3445@opensource.wolfsonmicro.com>
References: <1332208268.10843.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/D3X8sky0X3AmG5"
Content-Disposition: inline
In-Reply-To: <1332208268.10843.1.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/D3X8sky0X3AmG5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 20, 2012 at 09:51:08AM +0800, Axel Lin wrote:
> Convert ab8500 to set_voltage_sel and then we can remove
> ab8500_get_best_voltage_index function.

Applied, thanks.

--W/D3X8sky0X3AmG5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPaKptAAoJEBus8iNuMP3d11sP/R1KLq6E6nSZZDlXOJgZAYET
HDZskz2/tqxIJbRA8h5s9ExOGxjfp+N3TcvYCy3X2jGqvAITNoMPGmdRjPc1fzOO
GtGUjpnLS4SvDilIKCn2aw0dLVURBeIOgCLHi5EAvA9D/A/QV7nzx5pIGh8yddrw
srsMgc312Hd96HSAiMvq9f1pQK5ugNzvQmcTD4a61L7QrTjF5O8Zx2eCsW6bqWOf
sjfgSVmu2RH/4vY5ZrDG0sLPE0s7a+tGUSYuAzmnjlZFt3cffzly0oyjAVThNcYp
Ja2fpeyuhkUXrWkYZL7q+OjcMZSlCOEiIv+nHOKUV8DBHd0+WwM0AbBXltz0J2lt
NI+AYwe2SLFEC8NMi+yjtJsZ6J3wT+M6258rK/VhJg8tVfdIPw8vcIxYW7xmvz88
PZaOFZQtWYD1zdYMWqqDpdgHz3Y6bxudjQO7q6SqobwTau4BZI/WtFrFkNdowjNu
CZ5gtnFyEuOtV5AdSWOsEEli0DNX0uj3YPlI+c97vlPkLiRulJ/e/LUvNSoDO2Q9
cEyCaP2WOwXrP65VHEBFsblaIjnD7o1WHlXzCugH7CiI7gHsFMIqdu5eJ2srTMlq
rLRF9FnCyrDj8op6JGh+LIAqJxuXhqLtRsWJNdomh6f9Ij5oY5u2zVVdNXocWJl0
FxTfjnbW1xuHKtw1LgY/
=63rN
-----END PGP SIGNATURE-----

--W/D3X8sky0X3AmG5--
