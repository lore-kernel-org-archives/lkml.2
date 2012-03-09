Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab2CIMhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:37:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40932 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755251Ab2CIMhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:37:11 -0500
Date: Fri, 9 Mar 2012 12:37:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH v11] Regulator: Add Anatop regulator driver
Message-ID: <20120309123704.GU3273@opensource.wolfsonmicro.com>
References: <1331279829-4584-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sDhuxz86kt5qlkuV"
Content-Disposition: inline
In-Reply-To: <1331279829-4584-1-git-send-email-paul.liu@linaro.org>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sDhuxz86kt5qlkuV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 09, 2012 at 03:57:09PM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
>=20
> Anatop is an integrated regulator inside i.MX6 SoC.
> There are 3 digital regulators which controls PU, CORE (ARM), and SOC.
> And 3 analog regulators which controls 1P1, 2P5, 3P0 (USB).
> This patch adds the Anatop regulator driver.

This looks good apart from the issue Axel noted.

--sDhuxz86kt5qlkuV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWflmAAoJEBus8iNuMP3dKlUP/RDW9omuM5S4jKHTN7+6NNCf
Y/qfIOM4OjIaZaJC6UWbpvBPCsuIamABt6pp0mSDdfF3FGyhoRN/ENOhWp9wkdhq
x2dUTFpHa3mV3OiGHNW/MTKSLI7GRaPiobaD2Kc/kKZujF7k6PXfrZ99knnr4UpU
VM2+ns6EM+EI3bJRY6LiAoN7MFmTWGF8kCfNv0c5seX96X54aR/C8WQYjmZKUvoY
NyDsVK7xeg/e+4XOMBwBDy7vELmKNl3SMseFhMP4TctqhaIHIyu890mq8CXB2LYk
RZ18XjJZVEu1gjbEr/LoddZD72aMYl+YwxE4bQuLQ4evzZ5TWzYSR36Y1o0N0Yxc
aL3Kqf2yv3nXF4RMmPfZPQpqb8o80QiurDEPBfXoF3DEiXAOJNg44kvWbauxBMsk
m1YwQH7qzlEreJoqwJxag9ZbCqepBHAnzmNGf2l5V2sqqtmqakZT3gZmFjknqauE
2KlbK3n1mHSHWYNhiK9z1uSI8E//IxoIul93DV9ReaXZY1CLB9wZlxO5U5kEakYL
AVAb1Di+pe6kfwZwxo4w/6adGGM/xEL/Jw+P3hDruPnWOgoPzNoEKH6L7xfJvHDJ
n0FAyh0phjHRH9cUAltlF3dmW/Vt8l+GTQZDPzUaOsv9U2WzhZB6ZQWD5aIC1zDD
yXtkJUMaEuHv1+do+6C0
=rAA6
-----END PGP SIGNATURE-----

--sDhuxz86kt5qlkuV--
