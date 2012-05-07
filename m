Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab2EGLwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:52:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45780 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754612Ab2EGLwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:52:14 -0400
Date: Mon, 7 May 2012 12:52:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: da9052: fix bug in device tree iteration loop
Message-ID: <20120507115207.GA17002@opensource.wolfsonmicro.com>
References: <1336377443-5926-1-git-send-email-paulliu@debian.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <1336377443-5926-1-git-send-email-paulliu@debian.org>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 07, 2012 at 03:57:23PM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>
>=20
> The driver of da9052 is buggy due to the iteration loop of device tree.
> This patch fix the loop condition to make the driver work with device tre=
e.

Applied, thanks.  I am wondering how this code was ever tested...

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPp7dcAAoJEBus8iNuMP3dWF0P/1XCAV8ySZgr04xyetJSlKgZ
xvg9Wu00LtUaZcAJUyA4/T//sB0ssijGnYTWEdejssQr/h6d0bM8XbRY8u0Lg1KO
jevC6FLzBdp6zogdwSBHXn7IoZKoyPEXKjFq/9JsWR3a0EEFFiwtp20Mkih4TjrU
3NjXBMPqarjCClRJY/fyzzC9OKpblON7PeGnuTYy2y2UqcvkEOA7ebYfp2iJr1vb
5KgdKhI1pVwbu9wkYQeiOQdrbv0cv+4GnQC3HczOxg75qWRHJOvSl0rRKlPrj45t
RmRPA6wZGLd4/fi37MQGaro+xYrs7F9XzEcw5oMCMnd4QTUG6i6F5f8wgxo/0fSA
HHkngT2x4Ud0fbpj0QsGXTRlGhwb0LjahL5QiEAV2njJkAMGp/PXHReHkFM1k6hJ
EteFu+ANCIJal9s9/sXGa91pJ+4GdzOQkj1JQvCEpR1aD203ZGnl59/FFuL1FCb6
b1SZ86wAiSEEtY/FoQ5ReFXj9qna9NYl18j/22mfoZ0jH7zwhCQG60+VWDIJut3j
lDn7Lkonh21LtNKcC5CmF/Wx8DJhGqapYENOcj4nt+hqwrE5BLifa/fQokxFkZ97
nWx7PTMPIc9HS7Q7hwfRYrbGQfDDKucBnqf1pLkZyR4/nFCsDGTAtb7mihxq07Bf
M1eFjxC1a4m1dhvEf9T9
=YU9B
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
