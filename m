Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab2DJJOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:14:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54146 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284Ab2DJJOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:14:20 -0400
Date: Tue, 10 Apr 2012 10:14:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RESEND 1/3] regulator: max8997: Use simple equation to
 get selector
Message-ID: <20120410091417.GB7499@opensource.wolfsonmicro.com>
References: <1334038803.15859.14.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <1334038803.15859.14.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 10, 2012 at 02:20:03PM +0800, Axel Lin wrote:
> It's more efficient to get the best selector by simple equation.

Applied all, thanks.

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPg/niAAoJEBus8iNuMP3dUxMQAJyBZ3zTHGCh3u7BPasB01L7
5RDXmwFVMqSdJplW1yEw8iskSm1RIJdsDxfF944l/rzHUPJLYwLyLb3JMaPlenEH
OSF8WbEG6GPExfXWbuf+J0NuqFQp3mPadZ5jtTJ6ZVjbdMu/W/rhtxHb+pgeeig4
ZNmw6MZTqwovXSUhYZW1PKkn0CFe5BuU0mtS/5e98n9+O+JgdKGdP5bkg0YCC58X
zfWrbvgse3NVzDMUHhwJRv5WsjLuOiYy0RJCCMJI57Dv66Q9n8hzODaSrBuDrZB2
xNI08kiH+70DwVHLw+Mv270qu/lV27ZduDGiBxN6gSUBWzqUKDMzsUsmG/PW7SSG
CDdFVI7WNqWezKMXFtzpU37Bj5z92J0gFTUPsxVOkCjMmQTiBqsq03J+UPm3fpcL
el0KRPNk9r0UpjTGCVXU9oqPeoyGtCYoDpfKhv9nYqyPqZrG3PHwN08x8WD9B4Ub
EteJ1tVjhxW6X6/2TxWlN+tnz0ItYrEG98Xj+y4NBmvmznRuJyroGYTJTNDh6lNd
pFtZNLdrcfRSvAnxYNKyk2dz8X6MUE1Gy2nzigOy2M0RK/DSoyEEioCJo+8/GDps
6vdcMBe0I+VrRr4KFA9EoZIGJe7ynJ/8esEg9NqfqjWmULR+oK4H057KgXm/GoFv
6H4J2kHcW1M2ZAXl0WmZ
=DSjr
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
