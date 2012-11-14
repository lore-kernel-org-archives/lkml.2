Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab2KNGT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:19:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47424 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587Ab2KNGT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:19:28 -0500
Date: Wed, 14 Nov 2012 15:19:14 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: AnilKumar Ch <anilkumar@ti.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] regulator: tps65910: fix BUG_ON() shown with vrtc
 regulator
Message-ID: <20121114061913.GB7407@opensource.wolfsonmicro.com>
References: <1352872479-25462-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z6Eq5LdranGa6ru8"
Content-Disposition: inline
In-Reply-To: <1352872479-25462-1-git-send-email-anilkumar@ti.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z6Eq5LdranGa6ru8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 11:24:39AM +0530, AnilKumar Ch wrote:
> Fix BUG_ON() error if tps65910 VRTC regulator is used with out
> rdev->desc->volt_table data. Recent changes in regulator core driver
> which add support for "regulator_list_voltage_table" have BUG_ON() if
> regulator descriptor do not have voltage table information. This patch
> adds the voltage table information to fix the issue.

This is already applied...  got dropped from -next for a day for some
reason but it's there.  When resending please do say why.

--z6Eq5LdranGa6ru8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQozbeAAoJELSic+t+oim9AUoP/ie3BdqrXB90dCgKg3KGEQWX
ComPTPoFQwRVl3o7Le70gEUPqgIqlMdZDZIbR7FKoGiRuN8no6Ao1yfOiDyNYkon
751g0lQkdKCllWnZz4HOUelod/ETdyBmN3vNy96kd9Gxu40BQ9fqkLBPc6BBlgFf
mte+QqdimEVd7mZ7jbzexRc8vbxXpqmx8epoCVtBJBeDVPK9833f6t7Wg9fUBpea
wl7LD+qtjb0sgK9Mo2AsTxyiOlC0UbyezRLSTzdoiYsNOmFVPpqC7I4WnoFRRV8k
DCgLZ/7Bp6OicSUOej2SVY4mJqim/o9pKAyc4AC1YiqqlEsZGIZKfhUG3M1+ijB2
Ag6wF4A8mRdA8SViWDLgocFq/ftG3WO1AQV2DQ8FoB99ejfwPzDa9B7/6YazTci5
pWvAqqzxjfzDRr1KzT5fQojaEEgwOVBKZkBXYxYDxc4VcM8vKELiEcYVPjIDtJ92
5F7PgTv3Eoo7R0nXDapqoxZPSojdg+EAsxHmJWUSYqSd0Y8jtBL0cUY9seIqmHru
c+1f2Q8LuQf+yjWrMQIYPgMvIe3W2ACpR5D0zCV9n//5CMs73U22nuuRtLa6lUKK
Jb+U+Ego53vxlwzZ9qNmiWMJDmGUgME0Qbjvd5Bnh16IlCiKVPk3wTcPshdvWjLI
TAEj8H64gb5Q3kEm4Ru2
=WqTn
-----END PGP SIGNATURE-----

--z6Eq5LdranGa6ru8--
