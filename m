Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2KINcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:32:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36569 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880Ab2KINcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:32:08 -0500
Date: Fri, 9 Nov 2012 13:32:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Only unregister platform devices allocated by the
 mfd core
Message-ID: <20121109133205.GF23807@opensource.wolfsonmicro.com>
References: <20121108172300.GA21812@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xkXJwpr35CY/Lc3I"
Content-Disposition: inline
In-Reply-To: <20121108172300.GA21812@opensource.wolfsonmicro.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xkXJwpr35CY/Lc3I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 08, 2012 at 05:23:00PM +0000, Charles Keepax wrote:

> +static struct device_type mfd_dev_type = {
> +	.name	= "MFD_DEVICE",
> +};

This seems non-idiomatic, other device types all have lower case names
(which are much more common in Unixish systems in general).

--xkXJwpr35CY/Lc3I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQnQXNAAoJELSic+t+oim91WYP/18bzh5GpBeD8dC7gqwbfH2y
SpXxt8NtiNvOp5hUAxrwct3Mz2Cn80MBYe6CfUvjbNGhzq0a0YkqGFGZmUOqfiKe
rhuYoXL+5sMNyZa7nQKQbv1IAtiUUTIog3ay3XrTE9KBa5AhZkd/glg6/XV5nE+M
y/vOVR4T+TC58RoCu3Aur5KyVwPdmG1RjjzbYRn/IkBH3zN6g8NqupXMlMbsAbcl
XdLF408saXnjIq7bW3e8YuyKmmBSKkwMI52HgAB5w4q+uumc2AJB371+JPLhCKHt
vOQ6B03GZqhRsYz7gu1jnEKsV85YTv0/deIcCWa+JKHp12pmfwMfFfDfVDz3s1As
jbQ6VuZt/rN6UMrOhwjwezqg8WtK7Q5W9JPf6FvGp/IlAY0rXOmC424Hqc/qyDP+
LvTQyneUotT/KHVL87MBueB+wKn7kKd04dEU7uPmU5zZyRTN0fYA+3rVne/L5CB2
/U4AMN9Ip7awpaiUJMZatqhDratmf28O7evMaM01luDyyQhvEevEwtk55gShnzbg
SEcVz/t1DDvLfLBoiew0fmDt7Tv2q2nl1nsNwad4UEIygeJ1Swc6n+ZHgk3ckxuU
fVGtGNMY9uhjWPhKY8dazdPhO+CuKO1AwAsibQe+pRy/ZY3g0IkbrbZsbOiPsRMg
CeFCrIr4n/w6dkYbIxN+
=+icS
-----END PGP SIGNATURE-----

--xkXJwpr35CY/Lc3I--
