Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161419Ab2GLRS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:18:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51178 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161288Ab2GLRS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:18:27 -0400
Date: Thu, 12 Jul 2012 18:18:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix a typo in regulator_mode_to_status() core
 function.
Message-ID: <20120712171800.GL7256@opensource.wolfsonmicro.com>
References: <20120711142606.GK3938@opensource.wolfsonmicro.com>
 <201207111221.q6BCLW8L014872@sw-eng-lt-dc-vm2>
 <20120711132655.GG3938@opensource.wolfsonmicro.com>
 <201207111421.q6BELFoF006060@sw-eng-lt-dc-vm2>
 <201207111513.q6BFDR1x016181@sw-eng-lt-dc-vm2>
 <20120711174257.GN3938@opensource.wolfsonmicro.com>
 <201207121052.q6CAq3Ix004450@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MzdA25v054BPvyZa"
Content-Disposition: inline
In-Reply-To: <201207121052.q6CAq3Ix004450@sw-eng-lt-dc-vm2>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MzdA25v054BPvyZa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 12, 2012 at 11:50:38AM +0100, Krystian Garbaciak wrote:
> Case REGULATOR_STATUS_STANDBY -> REGULATOR_MODE_STANDBY.
>=20
> Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>

This doesn't apply against -next (or the topic/core branch).  Please
check what's going on there.

--MzdA25v054BPvyZa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/wa/AAoJEBus8iNuMP3dZFEQAIyOE45gUIhgxAq6AkNhpdK3
4eTBXT1MMwZ9kL+HJaWk8icZVNOvSKmMknch3ZoVV/uzUDqjTxpO8ThQHm5+MSBx
6LF0lkssdUTG2lydUoiP/FHBxM95Ebnat75rb4Jk7zE3dCUbTG12VCx8TCcVIOcl
2/rEsBIf0r3Bb11kwIb/TZKBjpHBMXLEW0EI9lRuUTIdNtMLphh4uSdrXL9phw47
nZuJc7fiVvOh49LWqoY3WD8HnjXIblACw6A6gt/qLlpfkFayrGWniXCsriT+CcRj
HPJ9MgqRKsSqVdT+nK25UK48oFKEGVsMd8tVlhrVt4Dz74QhjXXP8YPybcWGOKcQ
TZww0P1QN9e0NnpI6Wv4rwrVWS/58YjgsJSN8kup5LxEP6pB33yd2/LxPwSB6/HE
Q17QqtsGNw5vT1CAniSD8c/ftS/lufsM1rQXmEv+cnkPCysCnvw8dd7+Djoaea5m
BI0+5y6aQJjPDNG3nZIGc0S8v5BrZZVOjWLQBr8dXYMFNWAwYIe0ahiXwB2opZXF
5Xam5uE7GMAtFnYEE+1pdYclPuuso6t1GSJZKFWoAqpHxFw7GvpgyE31Gv249Fqd
ik5/76CAY1kYtUAVDh5b4pFdYNesGJRTGnWpzJZHpcwhK2PKiLxtCBYbcjcbWG2J
z8rSc8tJXGTVom5zVYGE
=1B8n
-----END PGP SIGNATURE-----

--MzdA25v054BPvyZa--
