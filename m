Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab2KIQkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:40:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38510 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753896Ab2KIQkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:40:13 -0500
Date: Fri, 9 Nov 2012 16:40:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2] mfd: Only unregister platform devices allocated by
 the mfd core
Message-ID: <20121109164011.GQ23807@opensource.wolfsonmicro.com>
References: <20121109161528.GA674@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cnBsrynPgIOyCJkL"
Content-Disposition: inline
In-Reply-To: <20121109161528.GA674@opensource.wolfsonmicro.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cnBsrynPgIOyCJkL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 09, 2012 at 04:15:28PM +0000, Charles Keepax wrote:
> mfd_remove_devices would iterate over all devices sharing a parent with
> an mfd device regardless of whether they were allocated by the mfd core
> or not. This especially caused problems when the device structure was
> not contained within a platform_device, because to_platform_device is
> used on each device pointer.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--cnBsrynPgIOyCJkL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQnTHkAAoJELSic+t+oim9x2EP/3EBN1rpPwSG0d1hYgAlWne7
yt7Vf1C4xdq2DFEiIKVU/eTBqMWXvlGLXk3KUr/mq7mQqAd/sgGuKA8rgazYhi7m
+IDnL5upGvoDKAAJ0oC+ktOeaTccQUj9tRu8eMM8okSEseK9YNMXEGfikFT7Gjl1
H6hLmkmevrq6oZoex/LJ00rtHmIwND2psF4S2q3Cg++NzsAzJDNVQLmjL75eWQFh
xRJ0J6SV1xeEWgDhb3fDfP7GlboTIXmWFry7GzG+UPiXCttJCUvp0Bq8Cyb/IBNe
gHxnPOpTZbM42X4HcnXcZRm7Su0ETy6H3zWaSWeYXzbAXC/9g5RJGBs0iiGVc+Ob
4gyb1FBHFu4ryklp1xhcPB4gZKMMvkMecidFUWcenitiFEStTX4ISxjVjYWhntqz
oiy+Fi+X9ELSie0LhL27uX82vdCUxgyg4yyMKV/UeIuXiZ/pakRXVVvye673ce8x
E6hyddeziN9Lo7RevX+5veQ1LWsdqpfz2oBPy6oLdTSArg/S0iXDevtXfZO0owXo
dFrA4ENdk5Vien2cfEL7Vehm9vQ52VmLOdl6P8Sui3soqiLpkPwjWDJdxKAbiWhM
tkeB9W69LeOUgjhtv/YFVS0pxI2PzQJ4EXjagoQ8wIty/IWM63Iex8BNSVUcmx5R
QBdyOfmTJKH44MOcG/Uv
=ca7Z
-----END PGP SIGNATURE-----

--cnBsrynPgIOyCJkL--
