Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2AaLZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 06:25:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42621 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699Ab2AaLZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 06:25:24 -0500
Date: Tue, 31 Jan 2012 11:25:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regmap: Remove incorrect unreachable comment in
 regcache_set_val()
Message-ID: <20120131112522.GD18444@opensource.wolfsonmicro.com>
References: <1327981698.2975.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DiL7RhKs8rK9YGuF"
Content-Disposition: inline
In-Reply-To: <1327981698.2975.1.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 31, 2012 at 11:48:18AM +0800, Axel Lin wrote:
> regcache_set_val() returns false if cache[idx] != val.
> Thus it actually is not unreachable.

Applied, thanks.

--DiL7RhKs8rK9YGuF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJ8+bAAoJEBus8iNuMP3dRTAP/3ksqOtF4SmOGWZlZslX6sh4
eZ+mTuJIrw0rLOgzImHFZX58L73kRAZSGoRS2PU92vf+dpZ+coF4pmgoIuxdz/QX
VlGluMYVJv2VLoN4w0y0GqQw5yCIFK1qiJdc3RuMnz2clGE+LMz8vcAXhOoWEFYT
mJWxjrXarizEK5MpqD2/hqHDWOF1pr5foX232eqTAT3zcjM0bDFYyxDaQtcvvRld
dRFk8EA8Rr1ozj9KVhSBu33hd+w47bF2uI4GkKkn5Sec4E+UpSWmb+3qnfcteH4S
fuPUD5aHWOvBIhgUquSY5Ubq2PQ0B8ACvh6atgGfzXbDQHo+iJP+MaxhOcj+Jl/M
bUJfc50MCpyjN5kTq0b6sEQXdzSbLGbzqNOYE08zZtA+NI/CYexDwzv3LIQljqe/
nuaOdnzv1sgIrWEWaKuG2O/MQgFiKFquZc8reNhV8rDj1oUpGAUQDWzINimVDQqn
62THNYvEV6GyJgnsN9zY4xd2/GSCBKaAe4UiMpKEZO5vZJtsVH/QMBB0mAA/iJ7e
1Kll7oS6Bfy2JuhtYjp4UNrWIjRhcOoMUSthIm/K0DproNY8N8Lc3PrU3XqlOntl
Hb5HJevG0qfpGE9thPVq0tuXNPq3H0yt1uuHVePXZdieEoy1rxCGY652WxIKq81/
beJ6rU2iAyqzTz8S2zYc
=GxTz
-----END PGP SIGNATURE-----

--DiL7RhKs8rK9YGuF--
