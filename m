Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab2CQWGb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 18:06:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40194 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932067Ab2CQWG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 18:06:29 -0400
Date: Sat, 17 Mar 2012 22:06:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regmap: Add support for device with 24 data bits.
Message-ID: <20120317220626.GJ3315@opensource.wolfsonmicro.com>
References: <1331860303-9483-1-git-send-email-marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NgG1H2o5aFKkgPy/"
Content-Disposition: inline
In-Reply-To: <1331860303-9483-1-git-send-email-marc@cpdesign.com.au>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NgG1H2o5aFKkgPy/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 16, 2012 at 12:11:42PM +1100, Marc Reilly wrote:
> Add support for devices with 24 data bits.

Applied both, thanks.  I'm not sure if I'll send them for 3.4 or not,
obviously we're very close to the merge window opening (I'm actually
surprised it isn't open already), but since there's no external
interface changes it shouldn't create merge issues for the MFD.

--NgG1H2o5aFKkgPy/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPZQrZAAoJEBus8iNuMP3d8U4P/0qh5XaehgntG51YjfBuP4cJ
ujpF+DsT7jhZJBQGz1VrQx99PSv1KYmtYZQg7y/FLtoVWvxFw0Npku132J23/O0R
/iFPSNATwTiUM6tXC+vGRP32/Mkf71I/yzpa5DZkTe/P55H4c0/KgQ/7ALactnLC
EiH3Ri7KnB58Zwxxi8kZusoKr6FQX9ALV++udP3scPyiHgVwxTGYUMIN6jHBmOzM
W4J1aqq6c+NUTj0lxJN7l69/xJ2rMsI1E+9/k312fsX6UG8/ZhFCp4N9ubdTFk20
j5vYCKijkv+1q3kjOwTWYTj7D8oaHJkpQAgkN8CBmgzY4xleFqM7DoPwftWaNnp6
zGT4BddDREbcXnNMGT/n3ORAUV8emX4yw+upU3E9NcbnXOSX/IA4F+GIJbcg4iUL
A290H1xzkXpfdZgpn0ntev1KbzpluokbbzLZ6EJf0FPYKybLkHU1o4CPEv7PkTmc
U46p/kKwHDoqz8l4mb0fd9n6NbU68FJZqg5QDydbRUuD34kjwWc3xmLvFq+hwErz
foQ06IftlyCt7wYsNr2yyEJ4iLrudQi0BZ7e6jdjDbB74nfwsgAgmy7Rm8TdtUw8
uy/AiMsmmyWcOvscAtD7Wc2tURda017KqeHAiBC28l+Aqa+3hy9nr3Go9KDEQKBN
HxjGbHIjqM4pzDCdST5m
=umX4
-----END PGP SIGNATURE-----

--NgG1H2o5aFKkgPy/--
