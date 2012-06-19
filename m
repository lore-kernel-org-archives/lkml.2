Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab2FSJwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 05:52:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39334 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120Ab2FSJwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 05:52:06 -0400
Date: Tue, 19 Jun 2012 10:52:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: Re: [PATCH] regmap: Fix work_buf switching for page update during
 virtual range access.
Message-ID: <20120619095201.GC3974@opensource.wolfsonmicro.com>
References: <201206181207.q5IC7Hbm029241@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="POjlveFHrWq2ZO+N"
Content-Disposition: inline
In-Reply-To: <201206181207.q5IC7Hbm029241@sw-eng-lt-dc-vm2>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--POjlveFHrWq2ZO+N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 01:04:29PM +0100, Krystian Garbaciak wrote:
> After page update, orginal work_buf has to be restored regardless of
> the result.

Applied, thanks.

--POjlveFHrWq2ZO+N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4EsmAAoJEBus8iNuMP3dJmIQAJr11BPI2ad4Z9byhRxjSzZk
AegPTsZ+UlpxfDwKRXLyTk3CXJ+nOCL01ilwVgmJnWYj9WxVkKIAIFnYT9z+iNEL
C9vF+/ir1kfuONw3fjEfik1T0ET2cnyvTZuwFLuKVkC7DiI43GervUf965Y80Cj/
NeyZBidcUUDzh3fpB7qgh0jjQos+ijnzj678QsqSsQzP64EUW97krBBg7qMmxKaD
V26R9WzO5Xe4EBDxFM62+Q6dO8UMLrL14E32xvytOvaRevoUYWEvGOL/wrrFw5p3
JgULJvREyuNFYQVyG2M/KRlm332yRKv57G0i6zC60Uqhq+fDHApRbCPl2yA8Th3O
3tZYRJRftqGJM82aZM5wDnrzoWyCzlnqgzpmQ30A0CTMrDoqDy+hst0gmhtootXY
+eSBN7969NFJJ0YPPkjhXo/lT2iISupydU7siLnam0ki73uDeQpmt9eWURI/Z5Mt
mEWwQvotoq3OShFwh93ZzNAhVTA6+9mxkyj8cJTSiFLBuJVVFSv0V9mIc/mHzrYa
gbRoplUcrDsequ2JzhoFPoc92tCpUI6XGqnBLJvkG65yefBiTPgwulr406lDcIF/
kR74EorSItOBjmThmYocaGEh7+OBoFqWGfp5qrBTjfNJIEzH1Ae1aLPyJgpZLg4X
VXk/SKGagwSN78zRTnZ6
=+1J0
-----END PGP SIGNATURE-----

--POjlveFHrWq2ZO+N--
