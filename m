Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab2GOUu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 16:50:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40535 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab2GOUux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 16:50:53 -0400
Date: Sun, 15 Jul 2012 21:50:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT][PATCH 1/2] regulator: max8997: Properly handle
 gpio_request failure
Message-ID: <20120715205049.GC4041@opensource.wolfsonmicro.com>
References: <1341500817.14503.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
In-Reply-To: <1341500817.14503.1.camel@phoenix>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 11:06:57PM +0800, Axel Lin wrote:
> Convert to devm_gpio_request to save a few error handling code.

Applied both, thanks.

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQAy0dAAoJEBus8iNuMP3dKQYQAJfijBsYf6BN36IqG3k5bEDx
81OQ49ODnY7X+N613j5cqweG8kaEz28zjVw5CM3W5bX5fJZCWzMoe0Rb7ud75eWy
xLo7g+SDKvdC2xFV23moK472jFC8/Bjkp4sdm5DifaGNQeNmiO/6FJ9SOmxbWH5+
SPW0UEqYLi1eH/AVpCcDrtEK97G7LZylwi8a/F1a1upbBus8qatbsxlgJVoTJJOm
KrifBsG+1KEyXo3xZGbUWjeZtdOufA9W6VuKaC6sOEHHVpYRP7gtOuJkrW6sjtNR
FJMfhLuSppUB8AaThR6GFkU5lmkDrEF3lLrObOcjksZy+7s9ejDmE0+gZd6I5Hc1
TY5WqvNwStxRufWhrJAIG8b94YPchsGdEbjU6TimavQAzlGYp81MVccKQKoeVWFC
hcbfd/KmH5nI1fXkyrJ511r06qE5PLnello+ke6m/65yBnQyyZVYRjdqL0QunZgi
wk78Pqy/eSOExsH83l7vIrb2c/nmiwM0H+Np95m8NLcy4NYf0TDQzCcsyp9bp5Ir
jb77arfZJK1YftsQMBrDWrxfwsL4OttoEMZAMNGHeXIdPTjnCI/SzRzXK0yxWF75
w+feL2ijBBr/EiXCb9hrXXSQ/UBObkdEBgFtG07gYkXTrUrxrYkmpRYKCDjECGz1
ul4Krej+Lilm1zJrypt1
=lrlT
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
