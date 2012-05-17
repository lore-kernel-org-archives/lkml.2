Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967279Ab2EQWBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:01:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54646 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965954Ab2EQWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:01:32 -0400
Date: Thu, 17 May 2012 23:01:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: max8925: Remove check_range function and
 max_uV from struct rc5t583_regulator_info
Message-ID: <20120517220128.GM26337@opensource.wolfsonmicro.com>
References: <1337216145.5759.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RVlUGXxwBj5SDcM9"
Content-Disposition: inline
In-Reply-To: <1337216145.5759.3.camel@phoenix>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RVlUGXxwBj5SDcM9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 17, 2012 at 08:55:45AM +0800, Axel Lin wrote:
> This driver has been converted to use regulator_map_voltage_linear and
> set_voltage_sel now. regulator_map_voltage_linear will check the the voltage
> falls within specified range. The check_range() function and max_uV field are
> not used now, remove them.

Applied, thanks.

--RVlUGXxwBj5SDcM9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPtXUyAAoJEBus8iNuMP3dg38P/3px9oBjcWPu6ibuq8N30dq5
0rr5YuJKBIfXIb18m8ycLu2WbGQdhSSrqmQ6Hc0XPnsJi+yGQ75d3lHsh+tHKIWx
+VcYXzdMCxBqQViiKqgHxCQJmytjsgiMkq3c3kQlbbEVT/bjrwjlrsnj/RnQE+fV
tW3XMtQZOWcX31k60LaqkQNbNFDtyI/lR0oJz4488RubK1ldiqOSkNYrhRCbwaCE
R0vrsi9brhxu+Jvv7LhQ3rx6xFo4jNUkClIB8NtyNo5Ff47UpVOX2YmVAXELW2U8
FAwVHpIhEVvlwERQS3wvBTsJ2Fgf+xzzoiffTqhGY8AoWWNsXxD9gjCJ/BI+JJdD
cMXLj7YuWrxQnmwuzKpOoX4q5/L3c8rUSHzio5W7Xm2LEPCdGwYBEjo4sArNvrG2
nN9QUocgL5qxoTTcnieZTFbFL8ktWKw/PNrTBlFVteL3QCJ+ytcvU+3/OLWopBV+
010NLrOS5h80v6F9xc3SWKcITglIz73yeUxYveJtrp8vLmNNyfY9//XpNoQPJiXL
gfYhKY6eZekdoswguWArt/QjugJY73cXUOvWrpj0/Jgsiyj6Q7wDztV9Cg50Xo7l
wvBfJmoNPr1YrIxK6/NqKRhT0/RurtkEiRCTiderHZ8/ZzKeoLreJjr9PWbiVyob
bUTL2CPQD6yOD1BqDsgb
=E37R
-----END PGP SIGNATURE-----

--RVlUGXxwBj5SDcM9--
