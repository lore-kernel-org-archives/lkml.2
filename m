Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab3AHLMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:12:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55919 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755776Ab3AHLMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:12:46 -0500
Date: Tue, 8 Jan 2013 11:12:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: s5m8767: Remove max_vol parameter from
 s5m8767_convert_voltage_to_sel
Message-ID: <20130108111244.GO4544@opensource.wolfsonmicro.com>
References: <1356745130.8271.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCFQJunhLz1tFGpX"
Content-Disposition: inline
In-Reply-To: <1356745130.8271.1.camel@phoenix>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lCFQJunhLz1tFGpX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 29, 2012 at 09:38:50AM +0800, Axel Lin wrote:
> It looks pointless to pass max_vol to s5m8767_convert_voltage_to_sel().
> Compare selected voltage to desc->max is enough to ensure selected voltage
> is in supported range.

This doesn't apply against -rc2, can you please regenerate?

--lCFQJunhLz1tFGpX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ6/8mAAoJELSic+t+oim9600P/02At1RnFGpU/DwrjG39eU7l
DmRyPmYpf+ZnyBq/S21vNBG4bO3FBkbIBIMfRtg4g8KSuVhowZglZhLEEvDbLcJd
L4vlLoDbV1hiWE516JD5L+xquxlSrUL9s44EeF1hg5l+CzxdeiXshm12dRihwzKn
AMQjLWdlZWWaHX+e9phBX0CANb6liNrn4dWWjlHiJBZmCNQqjDusUh8pqI9jhnKV
UfstV7CiojuvtEBNCpmfLN2ihvFgRft846Nn/OFzDFJcfryTgKbVlPSs77SH8Y/1
2CzN84CwdX8rXefS80zmbmvdrKGUXqgVUu8a8RiaG6gudEa14TlueekbcpmgJx0s
j363ttyu+XJufsBea3Nai45Rj/1eq1CUZTxPLgrTU+q6YaGDz3bFqG5zDV9y6IBd
7I89nmJmWPNdlPYLuA7ee7+kFJebcCJAycTxdULxA7rQxUKN06h9UUb2BtQr77Cl
5NNX9tzLlmwYPU8inriN/BVViGtVGJVSJdiCTx5qmTiu72Vivb3pxgx/XlFJtTIk
ok+gdP5byfESgq1dZqXKXZ35M1foITyPa/5bmESnHTVPo3Um09yCpSg7qXJeg0rn
riOFZXNcCktuHTI0h4DsTqlL1RGrJnJn3tzexqb6d8hsYUoaEDrvmWKvESpObdtK
0DOxrYIUtu9Nq0BasLaO
=7J3f
-----END PGP SIGNATURE-----

--lCFQJunhLz1tFGpX--
