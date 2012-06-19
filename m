Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab2FSLJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:09:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33437 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376Ab2FSLJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:09:25 -0400
Date: Tue, 19 Jun 2012 12:09:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, sbkim01@gmail.com
Subject: Re: [PATCH-Resend] regulator: s5m8767a: Support AP watchdog reset
 operation
Message-ID: <20120619110924.GH3974@opensource.wolfsonmicro.com>
References: <065701cd4cec$3252ea60$96f8bf20$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b2u6xDyV6U2OU5E0"
Content-Disposition: inline
In-Reply-To: <065701cd4cec$3252ea60$96f8bf20$@com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b2u6xDyV6U2OU5E0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 09:49:20AM +0900, Sangbeom Kim wrote:
> The S5M8767A can't know status of ap reset.
> So, After AP watchdog reset, AP can't boot normally.

Applied, thanks.

--b2u6xDyV6U2OU5E0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4F3aAAoJEBus8iNuMP3dcscP/2mhZ91grB29d3dsecX3WLpE
uaJjt3OIutvWOYRpAXO1hwqb3VgMa16CiKeC5QEJ1Y+HBIZNqeJCmbF/sjE5L0yU
zDi2kmm2ORCyYp1WCsI5X4gBbSQWmJ7sanu8tQFOk767SCxpB49Mlh3Gr9lPfi6H
YBSvSHzAgnOuuNlX4RxqsljJx+KzadvdTzH1eLY8UtIFOJuhvPKS9yk5J0zESbBO
THuh9xufdmGL8Wah+Q+tGKaLtP8O/i16ib7oVSw6lY3vcCPSHYei8fN1LrYK7AoN
MuKRskmSm836cw6FdwuKA+Qc65OyeZWq2usKrBzQzvRpfokXebCcFxzagv2XnnzZ
u2wgGp2ChUEXJTT9iPCPaFTatV13oDxExCgF8Om54xUz4V7z87/B7SL3v8rK1o5h
WLwber9jyoqb2DJRtyuhLuei5HmKGpi4oC8srWPBNhsUlOZgPH2qR6D0/MAHfYB4
A3xGgHd/SBR3pDYPpvFVfF0ZSRnq+XjcD0QDsOLtXmHItH6Z111ekGn6uu+0HEED
/MYoyUeRDO2CLuE0bFhKA4s9sr/w3gkzTSSUqQFZaw97TmbpHCC4RC516mpyNakl
6uOCmi1dqRUMevxAV4/vXD5ZBLdJdzpLXSzvHxGgDvhT4WhqpmcT7QwcL80w+nJH
KgbFb3z9+PzUTEzxN9Ik
=ZBz9
-----END PGP SIGNATURE-----

--b2u6xDyV6U2OU5E0--
