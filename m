Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694Ab2B2Xyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:54:39 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49783 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522Ab2B2Xyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:54:35 -0500
Date: Thu, 1 Mar 2012 10:54:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: bad commit in the regmap tree
Message-Id: <20120301105425.ef188f8724204c55ec805929@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Mar_2012_10_54_25_+1100_8rT4aQgG.FD8qx8u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Mar_2012_10_54_25_+1100_8rT4aQgG.FD8qx8u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

I noticed that commit 0308333a9987 ("regmap: Add stub for
regcache_sync_region()") is the same as its parent commit 868d3fdeaae9
("regmap: Add stub for regcache_sync_region()").  So the function
regcache_sync_region() has been added to include/linux/regmap.h twice
(the context is not sufficient to stop the patch applying twice).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__1_Mar_2012_10_54_25_+1100_8rT4aQgG.FD8qx8u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTrqxAAoJEECxmPOUX5FEpXgP/RjSLO+Xp187kULQc0B5s2rf
NUdv1g88BW6UxswfGqCxfUWGl4TakUCi92RMC026XPhtKWzSZztv5rmXHQoIZRTh
d63HaBnsb/mXItpCspc4twVYnuEejIP3G+KgUwDnQc5itG4mmKr/dmirbt3DMCQS
qGgYsflHCRd61bcv5D2wryu++nw3uV8cWipTG3KHA3frHkg++3/odkOKpeMv2e7R
lI9i64oUluhxTsqjttIT1vNDwL+ohX1hzhmDJLZw+rqZmX9g1vxtNja1KxLIPksO
mOw4Na0/B+9QbDtxM2cMQXvzwRQ8cjQj0YtCxwP0b786L7DD6jLDkl8HBqwh+aYt
jgagBe90Lwc7wlVXcyQYa9LVwKKCOkNJj7zob/8veaw3P4mMc1csjfVRT59Dz/2Y
miwFkng6jqblHc9xdc5PwuXcher7xxZN4Xb4vwjV8Ksg0c34iJB+DNiEWMU8wIyy
F8w/UltvOzKHHxFChf0oSyT7HVcN0XrByEWL308wQ8CBE1A/PiW/C/0VVRa8FOqM
+o91Bv3Q+Y1tz6BEQwx7zoRWnt3K7baYqBoHOetjw4c5BPL56oYYDmmAqneiFcq3
9lFJH3+iQFVKAyNkkb0LLeOWL0KMbTxvjT3KMMmrTR2N1ar8dKroEeuDrA+3vAYR
4wDdOEZXQ4HCRZdvyBW4
=GZXq
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Mar_2012_10_54_25_+1100_8rT4aQgG.FD8qx8u--
