Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab2KKI3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 03:29:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:50491 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab2KKI3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 03:29:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,756,1344236400"; 
   d="asc'?scan'208";a="216060757"
Date: Sun, 11 Nov 2012 03:23:04 -0500
From: Chen Gong <gong.chen@linux.intel.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Jon Masters <jonathan@jonmasters.org>, Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH update 0/3] HW-latency: hardware latency test 0.10
Message-ID: <20121111082304.GA27037@gchen.bj.intel.com>
Mail-Followup-To: Luming Yu <luming.yu@gmail.com>, arnd@arndb.de,
	linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
	Jon Masters <jcm@redhat.com>
References: <1352602102-2390-1-git-send-email-luming.yu@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <1352602102-2390-1-git-send-email-luming.yu@gmail.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 10, 2012 at 09:48:19PM -0500, Luming Yu wrote:
> Date:	Sat, 10 Nov 2012 21:48:19 -0500
> From: Luming Yu <luming.yu@gmail.com>
> To: arnd@arndb.de, linux-kernel@vger.kernel.org
> Cc: Luming Yu <luming.yu@gmail.com>, Jon Masters <jonathan@jonmasters.org=
>,
>  Jon Masters <jcm@redhat.com>
> Subject: [PATCH update 0/3] HW-latency: hardware latency test 0.10
> X-Mailer: git-send-email 1.7.12.1
>=20
> Update the previous patch series to ACK all comments I've recevied so far
> for the tool: e.g. 1.Acked Jon Masters in source code as many code are fr=
om
> jcm, thanks very much Jon. 2. squashed all changes against new file I add=
ed into
> one. 3. Make it useful on non-x86.
>=20
> Please review and commit to misc tree. I will update the patch series if =
anyone
> has anymore comments.
>=20
> Thanks very much!!!
> =20
> Luming Yu (3):
>   HW-latency: hardware latency test 0.10
>   x86: Delete too many "Fast TSC .." in dmesg from HW_latency cyclic
>     sampling
>   fs: Fix crash caused by write to dummy debugfs interface like
>     HW_latency exposed
>=20
>  arch/x86/kernel/tsc.c          |   2 +-
>  drivers/misc/Kconfig           |   6 +
>  drivers/misc/Makefile          |   1 +
>  drivers/misc/hw_latency_test.c | 939 +++++++++++++++++++++++++++++++++++=
++++++
>  fs/libfs.c                     |   2 +-
>  5 files changed, 948 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/misc/hw_latency_test.c
>=20
> --=20
> 1.7.12.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
Hi, Luming

Would you please send the first patch to LKML, too?

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQn2BoAAoJEI01n1+kOSLH/yMP/2vaLYw/BlGbeT+6XKBhPCWc
rBRx2394zzIPUmyGd8Nkv3cU8/cJ6yPbDqcBMY8Wbe6R/5TeuaS/NyT9tCbhInzx
7ZrrJv4Xrf65KuXxkyjPyoSUp20Nos3dj0kmSsXBrPTzYO5LsQgIGyJbphfpDZ5L
dIVmG5ht48oSB8XzbONZoCBW+QAH9fN1KBgeT0+K616xtIcYCrTGHJpLvaQx6Etd
dmwNq+BhHi0W61YkXGGj+DsESB5heeMxxymLp17qTCaotvSPYZCnQXmsj6UfWetJ
Y0gUcveP05jphySvOaQKI5ov8sL9po8+lv+ECp17wpRzfCc3USChZ/ehoW9YRiGj
COVXjG6Xtzo3gjhKgWGBaLcdhI2r/zuQk2dhosVh/lLEBz2jUM5omQBEW1UY9Gcm
D083dW6+cE5EkQqjU3lLjvGfgS92ckmhBn41vOx1vYgTMJF2PaAxSVO6jgWzSBad
sZ2P5f+ZvMPZIMMVNk4w99ESW3/duEquC7wPOmkqsNOWsaj4/PpbamGQYRTd3y3Z
+GrTYS1p3Jg8dVngmSEPRuqPzZC596ma753py1AhKgYc5PhegJi9+Ri6pkKnMYCw
9RrM2pxYGihXCbbGzQr1PozNhfWDAtJ2L/uQWqaAlfkTds8Kg0QPMVrrRfsYIwhD
/anzJjN7YYNtqtXa29NY
=9b+a
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
