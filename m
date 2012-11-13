Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab2KMJAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:00:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51852 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646Ab2KMJAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:00:20 -0500
Date: Tue, 13 Nov 2012 18:00:09 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 2/3] regulator: threat regulators with constant volatage
 as fixed
Message-ID: <20121113090007.GS18224@opensource.wolfsonmicro.com>
References: <1352796533-12350-1-git-send-email-m.szyprowski@samsung.com>
 <1352796533-12350-3-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EguBBKnZWdUQS9Kz"
Content-Disposition: inline
In-Reply-To: <1352796533-12350-3-git-send-email-m.szyprowski@samsung.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EguBBKnZWdUQS9Kz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 13, 2012 at 09:48:52AM +0100, Marek Szyprowski wrote:

> Some drivers has additional logic for fixed regulators. Let regulator core
> to threat regulators which cannot change their voltage due to applied

YM "treat".

> +	if (rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE)
> +		return rdev->desc->n_voltages ? : -EINVAL;

Please don't perpetuate the use of ? : as it's not a triumph of
legibility (even worse than the regular ternery operator).  I realise
that the original code did this but there's no need to carry on doing
the same thing.

--EguBBKnZWdUQS9Kz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQogwJAAoJELSic+t+oim94HEQAIu86j5Dpf5M02rgDhw4OSeK
yOtjgQVQF5uGKrXYihUwa2MyZQjNOro6ulWi7mrPZ27gdYjDSipm1nFkloau36kq
sFujzi8w6jxAC+C5NkQoUsV1ruSvSSSPy94SYg8OJNhBwvI/yGWufJLezFWS7Knf
zARqcUGSLTCto64fDODEQjko8enO8hbs5tLmqQySeajGV1fPV72wY9os+5sssyw+
ADGeoGIhGSpQDWpsj2aIE7eVwiSlMZMU5JXRr4b32K8ONn3Ay7rQKz8a9vC0GQNh
/IWMOzDMPPOy2ScTSVadtiuQNR5M5390qp7XZcN7SpqXWG1eDdvkjulX9EQTQhtM
iHkLM9B6Gh5UciBRoS+GRQfeLQdQv4uYkZ9sY1Yise4MatgB2hKuH67MRx2xFvjM
YLRhZUA5hj+QsgAT3EFASEJKemzbK65E5FFZhS8G/y/i+x+BNdTh4v42j5oMamHb
yTMxZdgVAoLhT+LiTE7yjqd2vr78an2uIdA3e7RoXlWa7PGgkI4IXYAjtMj2KjAN
XSN5voIogN977zO7MLEp7iAepDmfKi3+bL/RNIJSBcI614Q5E2WVm0lQ6l0epU+z
B8Z3wUOdTx95D7JwtOmlaL280Q80RPce0np3jfEpovNfo+sOeQOgCElP6uXhU6cy
t66/51biOIdC4vk3wi1G
=YIYY
-----END PGP SIGNATURE-----

--EguBBKnZWdUQS9Kz--
