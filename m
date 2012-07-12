Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab2GLRVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:21:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54834 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755362Ab2GLRVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:21:40 -0400
Date: Thu, 12 Jul 2012 18:21:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: da9052: initialize of_node param for
 regulator register
Message-ID: <20120712172138.GO7256@opensource.wolfsonmicro.com>
References: <1342103005.2857.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XbHSybK3LHOYQtWI"
Content-Disposition: inline
In-Reply-To: <1342103005.2857.1.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XbHSybK3LHOYQtWI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 12, 2012 at 10:23:25PM +0800, Axel Lin wrote:
> Initialize config.of_node for regulator before registering.
> This is needed for DT based regulator support.

Applied, thanks.

--XbHSybK3LHOYQtWI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/webAAoJEBus8iNuMP3dp1wP/RoPXH5HjqqwrY/qCYCDkhXg
Ie86zMTY8yzUM1XVje0zgWNFjHv5Z3612A6ebOp1UyE+X4VXx9MsnXngHzix9OrG
tz4aJjwGOoSv6hnGMtVjDxyrLAckYPVFb+E1QFWTpqbLUuAxwv7l0os04T42kb7f
m5eG6PdWoAarNEUIwyxCHMF9pOe9ANqoPm48BwNXJRf1hxRn6nCrYAS73aJchcK5
HUQOUh/lcVyQnqbFoWHTctjGKkyJm3vTR0ZFR88ZMAjRgDcz932C+nCkyqeG9H6N
+jXUzwk3CXXxr9onnwfSoujtbBmm4M8Sm4e2EOSv8qiZ+nQAWEf62XjIKDaTgF3q
jGOiqww0R9aqAw56x/spCvT3cyhjH5LpSegOjBeHQd01gIL+ET/vw1Ne/Pax/9hf
lXc5KhYP/CqB6Ja/+fbXFqd2YUbWi9ZZuQOr2H4+p+zXjoE5u711wxFZNruOTI4h
9ZegNHU7DxqpuUqKsJ/DmhRLFFgyKDD8oDEa2GUe7AFDT95s7Kyigc74oBpdH335
F+JEHSxO7jlrvmKnRCuUKx6ICs/BHGZMTpFpI6ttqaxQIjOwH4+LkbbD++h5SzY8
H/3L9rLZ0P3R/fcaov+0d/d5SbSVQ+HG/jEHOTAfmmxWdcSDoePS5a8o5+XG2z+q
hvim1wQiNM7dxPJ+663Q
=F89A
-----END PGP SIGNATURE-----

--XbHSybK3LHOYQtWI--
