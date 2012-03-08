Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2CHSJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:09:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36782 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273Ab2CHSJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:09:43 -0500
Date: Thu, 8 Mar 2012 18:09:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Rename s5m8767_convert_voltage to
 s5m8767_get_proper_voltage_sel
Message-ID: <20120308180941.GX3638@opensource.wolfsonmicro.com>
References: <1331093522.3143.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qn4G1eBrv+t66M9q"
Content-Disposition: inline
In-Reply-To: <1331093522.3143.3.camel@phoenix>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qn4G1eBrv+t66M9q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 07, 2012 at 12:12:02PM +0800, Axel Lin wrote:
> This function finds the smallest voltage that falls within the specified range,
> and then returns the selector. This rename makes the intention more clear.

Sangbeom, are you OK with this change?

--Qn4G1eBrv+t66M9q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWPXeAAoJEBus8iNuMP3deokQAJk+x6pFOXnEkLWxr2TDTYy4
991wNB6WUth47KCNBuSDg3swcJpVugh1ySg/0fGnstaOndGW5VhWLJylYVQhmUul
+P2A4iRP1tfZqlp9Uh58MZxsM/y4GnLLjqHYpaUM/2G/EBqLMROODKkeAN9w5AXx
vLX6TBlZ0O0emhpz0KHO9jhALURuIyoCpYIRzH1oImDW6AfAzlejtJh0g+cGop63
VHVV3jC+Dl6zWh+k5oQGx/cQ41A/IAwtZX6AKhqetP9tmlu5VkhLuUDaeUdGoM06
sBBa+ce9lNymtDzbsWdWnvbkOMb8sftrQXWSUEmtOiYs2krsKQewzmpVfT7Uj+UK
lR8TM9IJtR5Pemuo/DeabSzlL6GxauSYWMLM8t9CnM3dD2UiWhQzVzQ789ZUvOo6
pxe6qYuqMgv+wTkEjRDDlp8hd9K7u1Y16mhZiMCY5ZLSmrhqj42uAHgssYl6j9wz
nCJnIfFliDFAXS37zqYWcl1mIphz4U9GS9E8drepOw6ChDmzJfkYDuP3bL0ziS3U
qSKw8oGIdW/jKJIempXjAkOJexEAOiwJljYD/BUdFvxSb8tz4uDIDxjOUH1ibxu8
AemRuB+GJWxbN2ZmlUmFa/Gg6lKk3KqHgH8uQkROmfRFHbDFJEcx6A7wjBAWsW7L
E1/O4fPucH9PfR+Go+Pg
=6cQc
-----END PGP SIGNATURE-----

--Qn4G1eBrv+t66M9q--
