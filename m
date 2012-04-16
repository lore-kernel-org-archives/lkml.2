Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab2DPSz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:55:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58792 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189Ab2DPSz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:55:27 -0400
Date: Mon, 16 Apr 2012 19:55:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2] regulator: core: Add checking set_mode callback in
 regulator_set_optimum_mode
Message-ID: <20120416185520.GJ3219@opensource.wolfsonmicro.com>
References: <1334573063.2673.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8jNwmpfkpox/fiJK"
Content-Disposition: inline
In-Reply-To: <1334573063.2673.2.camel@phoenix>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8jNwmpfkpox/fiJK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 16, 2012 at 06:44:23PM +0800, Axel Lin wrote:
> regulator_set_optimum_mode needs set_mode to properly work.
> Add checking for set_mode callback in case it may be not implemented.

Applied, thanks.

--8jNwmpfkpox/fiJK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPjGsOAAoJEBus8iNuMP3d3Z4P/REto1Nxf5kefBXKBni0ufPu
yuXW5mKxy+CQ3pV6CSE+xmF4ICLbWZq1IY/DdOs8uB7bLmK4UjHLEIaPaafGAPnl
q6cCVojO8cPxiHPFD6K5EY7LYhlUQmO6N9ENC1TA9522n8o/gW4XiW9Z0z5srTQy
naqxKBqZjUxVu4LX1x9SoYajAmPmdBrZyVY5IOgO3fTzxxyVjcIwhCvjHKDis3TS
jElm+netFxZCx6C67+fA1zgemkEzk78MkFAD/Ogz7SKW415o6KKKm69YOttcU0w1
fr41LxuWS9zkkd0Fmo5DYsNEc+Gcg6gf9uyNM+lamvj9f8uNoiFz1NyV7zoa9x3U
DHKozrHk8/rKSyxsI/vgyaayb4x842X7zFcY2qOA+pvsOWhVwkIhv/KoHpb3Mz4i
4GjunNeTckmnH4lWHpFbxEegWQgfnjk0PkO0+IGaEc1+6npkMG5kJyI16QvCqeK7
o8zhJUOv/6yOuxGMW6lI0wo9G0qCFc5ro5i/1iZJ4dRO7fH9a52KGZFmtU4idBFt
XUugWkDMpEQtfT08o6PzAvBbw+UxHIs/q1nW+ICKCHxq5ERPNZtaxMlEOFQP0iwe
0cMtfVmQwFUjoN1NOoRtlbbYp9Q9SuH/18x83cU+gw1mOz+qRvwUs2F5mzNIhBCu
BByZAhIAisoDAsQ8ucgr
=q9d3
-----END PGP SIGNATURE-----

--8jNwmpfkpox/fiJK--
