Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab2EHSkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:40:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47017 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756669Ab2EHSkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:40:52 -0400
Date: Tue, 8 May 2012 19:40:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] twl-regulator: make TWL4030_ALLOW_UNSUPPORTED more
 configurable.
Message-ID: <20120508184048.GM15893@opensource.wolfsonmicro.com>
References: <20120501204259.27026.40156.stgit@notabene.brown>
 <20120501204450.27026.40239.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwX5Nmi7feudBrEr"
Content-Disposition: inline
In-Reply-To: <20120501204450.27026.40239.stgit@notabene.brown>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wwX5Nmi7feudBrEr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 02, 2012 at 06:44:50AM +1000, NeilBrown wrote:
> The regulators in the twl4030 can provide some voltage settings
> that are not offically supported.
> These settings are disabled by default, but can be enabled with

This doesn't apply against current code, please submit against current
development versions.

--wwX5Nmi7feudBrEr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqWhzAAoJEBus8iNuMP3df5sP/ioVgDnjc6OdqrvmdTTEaghJ
29e1MGo1Pdd/pmxBBfS7vS7cm7GADyBJxIi2FsEf7hECDKJyfT1cKvHuNRewXsvK
8A3byIju4e3dUW/UXOgFeInYtaHEvjotFY2yhYYnxYXskayjGg0HLzkfdFQoldr7
3WuRRSaJCZwN0QB7aNB8F9kemkEARBzwIgiDHjyfEn33jbhEjv6bjJaCr3r1mPCG
HVOaOJd7ys/ZCh1HDAjSVTmzqNyZwHTmGRzPRn1rnfO63l/0wFld3l28sElMzHrx
QYWYXgI/DhU8A9EgNxG4JuB30Kjwq0WhudRKIWhUFEuCYXpTf7XYfvPcioSkjbTK
roKuNQq76rnqJICvtGq/mLpIB9TkfLfGsh/Ai6aILjKu9C1gJDtysXLHS8HlO4UX
Ex7jbzk9BOEtttHcMQft9t10XOgpTzqCqyd9AXWcKmTDiTQj3hV+p0UjNlx7NUZ0
ASmQOpKsM7KPzi25MQG23D54/O0JmkL37Ls9eMDkljLxj3XUWhO6BBEdFAKJRWTl
Mc0moJjz3hMHfzAxV6XyfW8R8lpIVazZOCNf8c0FEbIWjIDUt9BcsVtjF+G5s6/n
ngFAgeTmdFIbeBvSbnYVBERymYgHqSfc8AotySodVxiYJ9Zjk7uJJMjYaGYIXs1V
8B3akeY8Fm2ijKjLaskp
=Rspf
-----END PGP SIGNATURE-----

--wwX5Nmi7feudBrEr--
