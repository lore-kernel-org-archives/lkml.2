Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab2EUOtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:49:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49563 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757173Ab2EUOtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:49:39 -0400
Date: Mon, 21 May 2012 15:49:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: core: Call set_voltage_time_sel() only
 when the regulator is on
Message-ID: <20120521144937.GD4063@opensource.wolfsonmicro.com>
References: <1337564272.4772.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6WlEvdN9Dv0WHSBl"
Content-Disposition: inline
In-Reply-To: <1337564272.4772.2.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 21, 2012 at 09:37:52AM +0800, Axel Lin wrote:
> If the regulator is not on, it won't take time setting new voltage.
> So only call set_voltage_time_sel() to get the necessary delay when
> the regulator is on.

Applied both, thanks.

--6WlEvdN9Dv0WHSBl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPulX3AAoJEBus8iNuMP3dCJ0QAJuBfxhBmn6ZVrfWR4zfXr8a
XbI+l1PDmzFOdouLu4rBJu4+rn/IVbYOOrMoHbmVq4Uqo3UwSxhZeAsZ7uUka1V7
iLlmBstHX3jbBBCxTlDmoT32dnrUy9XEvUvmO3vT27Q9okBJDBZOA04cLePvZ217
xp1HJLlGl7QD7sISmsm3aakWr+uME01wBf5qtGFT3Td2Abb4GrUIChVgrrLoiCG7
evjzl96SRFJWmtXbwkY3aSG04kN1HC41kpSh0ICE4MJoTnSEeoffkxO3GCWJDmi4
tsjXPfzcFHlq58AvPxhpXwmHN4LDZfZHjn/41m92IibG8mmlHd/WCtjVRNxXRnV/
KlJ3nTdnjZqV2RpalBVcKRdt+FGx4erGZJ2Emlp09c42+GmWFjf1klC0PkcGyG6q
hp7CelUaxhNHsHPcDrUn/x/OO0HQfhxlIgBSM+bK0svBCo9lDXY9ZQf6BKzlvLtI
ox8wwS/f/g1AKVykMQEZZ0sQEyeUFWQcPH5utkQY8B4QqbT64RlhoHuzW2fyU+jt
G2ugfiGHmtuTTTfpjW5gCh9NKiY6y7zytrxqCAAPvPBdEkewi5VsQNQitHGIajk2
IGaKy/pq6C02brWbDF2TC33hcIV6gguc/JiqjKzcTH+srW2bAaPvBFk9j6ghHE0q
x7yQByVlPOOrNElurQ6G
=g8n/
-----END PGP SIGNATURE-----

--6WlEvdN9Dv0WHSBl--
