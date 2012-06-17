Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2FQT6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 15:58:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40135 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab2FQT6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 15:58:12 -0400
Date: Sun, 17 Jun 2012 20:58:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: tps65023: Fix mask for LDOs output voltage
 select control
Message-ID: <20120617195810.GK4267@opensource.wolfsonmicro.com>
References: <1339653325.6769.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mPOSj6iWmtyhwOMz"
Content-Disposition: inline
In-Reply-To: <1339653325.6769.1.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mPOSj6iWmtyhwOMz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 14, 2012 at 01:55:25PM +0800, Axel Lin wrote:
> According to the datasheet:
> The LDO_CTRL registers are used to set the output voltage of LDO1 and LDO2.
> LDO_CTRL[7] and LDO_CTRL[3] are reserved and should always be written to 0.

Applied, thanks.

--mPOSj6iWmtyhwOMz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3jbMAAoJEBus8iNuMP3dI4IP/08ntl7bX7+HXuBh5GRJ6RhX
7s3q8z2rXlOowzrQWEY+lWe1/0cXzvTCLK58bCSCxBVWCFH1VXyQyuILmdsTRe4U
U90SUyV81Jw7WrWR1ZynxtfDSDrlq2XmYJwr+W8bscZflhvjaYqdQxad74TpaIeC
0x+ej82a9SjBcR1JDqnsR5c80cXpn3u+/6Zc6sFTYHPHIaWJtEkZjrqJtjfTqyYU
1E3kumzuTnmq5yDJvnoRcb5xqtZ2glKixMOy7O/7wNknWrUQTuJVSUsh33BQjGOL
uB5LjiEXwXIPNToykSLaM2gGJWRCmbNdKmURtTqphiLpQczJqmBRqeYKcshdrxg1
ZrIFLBoyw0e7Tj/JlMMXeN1v8h8a7byGCzBX4rmPlKWpzI5kQ9tB3cP7dIbI1tAX
mUOLRAyM8v9sf+SdshbALx62COwv5V22KYK2bviU/NjGSk5gZZeZalvxOUWdw7yB
0xCsXO0nT8AQPgpTjfCeEd9zdFPMm3ku5fj2GPUBeTZD17jcNqKRZGyRl8UXVDFY
7j0BeFDMWhY9ZFTmmdPLLxjAomJwUlrssLBSBiTQK/tk8iEQCRCRKyOV3DVUL9da
MjEc1iVAsYGv3SA3ezPZApqLCjwsJQZxgX7Tjj/PLnO4MWZUmx3hB0pDYdQzGur/
cVaVKAFS+9MUssHgwp6u
=AO+r
-----END PGP SIGNATURE-----

--mPOSj6iWmtyhwOMz--
