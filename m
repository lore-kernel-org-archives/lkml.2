Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab2BFLTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 06:19:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36802 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873Ab2BFLTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 06:19:06 -0500
Date: Mon, 6 Feb 2012 11:19:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/07] ONKEY: OnKey module for DA9052/53 PMIC v1
Message-ID: <20120206111903.GE3070@opensource.wolfsonmicro.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED1FDDA5AA@KCHJEXMB02.kpit.com>
 <1328515337.30549.22.camel@dhruva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MIdTMoZhcV1D07fI"
Content-Disposition: inline
In-Reply-To: <1328515337.30549.22.camel@dhruva>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MIdTMoZhcV1D07fI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 06, 2012 at 01:32:17PM +0530, Ashish Jangam wrote:

> Do you meant to have something like below
> if(..) {
> } else {
> 	ret =  ret &  DA9052_EVENTB_ENONKEY;
> 	input_report_key(.., ret);
> 	...
> 	schedule_delayed_work(..);
> }
> /*
> if(ret)
> 	schedule_delayed_work(..);
> */
> but this turns out to be a for ever loop.

No, clearly that  would be silly.

--MIdTMoZhcV1D07fI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPL7chAAoJEBus8iNuMP3dNZYP/AlUvvRsmlgNTtof98oGf4YK
Zcb2qWKygxJxoUm+PO4cspHb0aoc24nMo38KRMYSzhATBtOYWm/z9fk+ax2eU0V8
+ZsKeS7hv6NAIdxFsGpyZ1bFLSbqqabt9aXSjRUdHuGOnUaWtnwWijf5b5cVyrzm
fVNSEdYmEML/UIvFdhswiVLZzth0UUvz22I39zuvzncs1tbR9uDU8cjhKHooyvMl
i/nULTNiW9JjUk97I40K/O4m1jHdv2p0AGrf10QedH/xH0iClaIeyJ2VolucuNJr
T0mj6gOJhZv8LHNJ5q7CH8siCngLCL6drGsINudwzlpi8ikalT5dT1Jyzgalm8Dj
m/fJ3+BYxEvzbm1cLAkdnteD69QHhdqn4/L2lh21F6PW6Z0JAnRG92GkrE/2rYE7
yjnJs4K9kkK0W2gm0Q9E/23MAEAEw5Ru02MtSwbVn0V61efe7dh8A585S72uMj7t
7nta+PKc1D9JkxirSYl+zcWnDj7qZD+ld71bZX0q8VNq+9lQetJjJcXuT2ztpL6b
s+oOxTWLmfmDLbmgd5Jn8aGgtg1m3Hfks6Ay9aC9S7ioBFlrTmhxJTCj6hB4xqht
JHnhsJJI1NxkUOOAIwmAjOJx/ppgmDFBhq5QkP7GBnarS++8PhUz7aYkIhFCWQgY
yXDIapNH4zRvibf5nJIL
=5Hz8
-----END PGP SIGNATURE-----

--MIdTMoZhcV1D07fI--
