Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab2JCMNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:13:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:10541 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab2JCMNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:13:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,527,1344236400"; 
   d="asc'?scan'208";a="229979556"
Message-ID: <1349266385.20373.0.camel@sauron.fi.intel.com>
Subject: Re: UBI: Fastmap request for inclusion (v19)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: Heinz.Egger@linutronix.de, tglx@linutronix.de,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tim.bird@am.sony.com
Date: Wed, 03 Oct 2012 15:13:05 +0300
In-Reply-To: <1349262302.2017.141.camel@sauron.fi.intel.com>
References: <1348674710-102885-1-git-send-email-richard@nod.at>
	 <1349252745.2017.120.camel@sauron.fi.intel.com>
	 <20121003103625.0bbff63c@spider.haslach.nod.at>
	 <1349262302.2017.141.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-15egdv+XWJ6LdN4cG6vm"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-15egdv+XWJ6LdN4cG6vm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-10-03 at 14:05 +0300, Artem Bityutskiy wrote:
> ERROR: "ubi_update_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
> ERROR: "ubi_scan_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
> ERROR: "ubi_calc_fm_size" [drivers/mtd/ubi/ubi.ko] undefined!
>=20
> Please, see branch 'linux-next' in UBI to see what I actually tested.

Sorry, I did not apply your patch correctly, now it builds without
issues.

--=20
Best Regards,
Artem Bityutskiy

--=-15egdv+XWJ6LdN4cG6vm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQbCvRAAoJECmIfjd9wqK0OWkP/2DgAOLfy9n0jnqcxRICl6kG
hnMoO+bRhbAzzgZa9JF02WGNoczVuhl2EN/BZR9WsiXjWWWdle9GmsCpnGLMI4vZ
HdpsscbH8/9TS1ZZ67JCV1WVzd/pS3zJq37Wlp8vCqGNrdNWnkJ0p0rGkeKQqYRD
6Cuy01fSndOw0QpEmcO4TDAzyiE1nR96h8IW0bZivzh9NdCLoPW2J3QsxsuqtCxx
XWGR++dr/Gihcnqy6GGi8pStjzElV0GpOuX4eBruUG+TNkSRya0PLT76Y9Z4OC+y
kf7H/Sjkbhl9sWsMmkyvMgXl/O12fouQ5Emzjn0DAIRdg6lxblAoEFSoQN70JR/g
2MiTFgBBLA3zUoLS9LTOyM/LmSmBOr1xSUepGslgcoOHxK6CoYyDd8ruiSLP3jcG
Wu5QN/hsBYGMD99ypZ+ATjKuOaln+kUWafrvScTDbQTMAo0vrv1F9CQU4jseg2wy
937iMVUzyYNI/ARvOAwiMZXl4PmmHBaVD05SdDeHMk5pvWHIRCTBfPsRk0BB/AD5
ck2RFAQ/JldpnG28NZzGMsiIjyGj7BMkf6X/4Ovd4gWzMe9Q0wscw25i+Xc5nwEg
e19lNW8F16i264jR/2DlTqrRpO1H7OhDKRcrTzRsKmWQ0U9ZAFg221AwAPEdzl0O
x8Zkkny9JSjraNgjPV7t
=X0sa
-----END PGP SIGNATURE-----

--=-15egdv+XWJ6LdN4cG6vm--

