Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab2KPArg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 19:47:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51504 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083Ab2KPArf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 19:47:35 -0500
Date: Fri, 16 Nov 2012 09:47:28 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] regulator: da9055: Fix checking wrong value in
 da9055_gpio_init
Message-ID: <20121116004727.GF4387@opensource.wolfsonmicro.com>
References: <1352997314.10636.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sDKAb4OeUBrWWL6P"
Content-Disposition: inline
In-Reply-To: <1352997314.10636.3.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sDKAb4OeUBrWWL6P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 16, 2012 at 12:35:14AM +0800, Axel Lin wrote:
> Check pdata->gpio_rsel && pdata->gpio_rsel[id] for the case GPI pin is muxed
> with regulator to select the regulator register set A/B for voltage ramping.

Applied, thanks.  Can revert if it's not a good fix.

--sDKAb4OeUBrWWL6P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQpY0VAAoJELSic+t+oim935QP/1sAdUI+W7BH3vhpL3bHiTHY
4bd+fS1lFBEQoV19R70YM8zbN7UJtbTZZ264eESFmkOyJR5jGcp9DIWkip9VntUe
fIqFhnnEFU/yXyJPq3aB4/Rpd+/LeYQSM+NCXZDKhvEB6GSkuzLF/3FuPj4TKpce
hqv77tqVBnCzbyE2MCEDGICa8Scax5RQ6GYn+TBEBqH3YZC6Dq121ol8dbQFjuQ6
b4R+V7BbZ3BVv9dYk0zJ7dB60V4SbA/Nx0lQanwRv34iUxeNmB1jOCQORbB7M0Ck
atC9AWiyJZqtHtcsaCcSsoV8+JNezs8HiebU8cJy92AiwsQ6eUI8s7G8UrzgnIID
dFrAlxRuwzj1UlDBfPGeyCE3jy67O/2e9iN72GIfDo/zKo2OmlYnQjomLgtmjHkK
xqLxrMMPO/qdSdKqQu1lVXft3IbGs3/njdRevegVphzJYlgkbD69Ua8cKKIdhzzu
8l7SWGHDqbbinSxLLEyoIQrrrNyBcjA6UXx/4BCpdgpeFB127JiTUCcTzfGGD4hq
ye/sXgzETEdIjdggA+5bK30ZN3b1he0b3E9LJ1kYl3JnV+xRe2ZDRYsmgGK7d9YH
fBFFNXI42GqYnPts8WYdozqp0Rn5tQUUccSIYapc/M/Sa9OTcr/4HAYr++rbZDW6
AoYBCBheb9VQGSiNMp5l
=xVKp
-----END PGP SIGNATURE-----

--sDKAb4OeUBrWWL6P--
