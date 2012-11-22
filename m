Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab2KVTK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:10:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:20748 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab2KVTKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:10:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,299,1352102400"; 
   d="asc'?scan'208";a="245760912"
Message-ID: <1353581032.2701.34.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2 0/3] mtd: nand: OMAP: ELM error correction support
 for BCH ecc
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: "Philip, Avinash" <avinashphilip@ti.com>, ivan.djelic@parrot.com
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>
Date: Thu, 22 Nov 2012 12:43:52 +0200
In-Reply-To: <518397C60809E147AF5323E0420B992E3E9EC70D@DBDE01.ent.ti.com>
References: <1351667307-447-1-git-send-email-avinashphilip@ti.com>
	 <1352978534.2221.33.camel@sauron.fi.intel.com>
	  <518397C60809E147AF5323E0420B992E3E9EC70D@DBDE01.ent.ti.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-2MrpRPtoMgLrBm2h1KYK"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2MrpRPtoMgLrBm2h1KYK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-11-21 at 07:01 +0000, Philip, Avinash wrote:
> > I am not sure how this dependency has to be handled for this series,
> > let me know whether you still want it to be made over l2-mtd?
>=20
> Artem,
>=20
> Is it possible for you to give ack for these patches so that these patche=
s
> can go in Tony's tree where Omap-gpmc changes are present?

I would prefer if people like Ivan could take a look at this first.

Also, I am not sure this is a good idea. Or at least we should agree on
some common strategy for bit-flips in the erased areas:

"+ * 1. If page is erased, check with standard ecc vector (ecc vector
+ * for erased page to find any bit flip). If check fails, bit flip
+ * is present in erased page. Count the bit flips in erased page and
+ * if it falls under correctable level, report page with 0xFF and
+ * update the correctable bit information."

Basically, you are working-around JFFS2 limitations.

Do you suggest we do this in all the drivers?

If we want to do this, may be we better do this in higher level, common
to all drivers?

--=20
Best Regards,
Artem Bityutskiy

--=-2MrpRPtoMgLrBm2h1KYK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQrgHoAAoJECmIfjd9wqK07ukP/36SzpGO7EdRk3F81tMxDktZ
S4UvO+qgJI9Z/sk8/ZVoO3y5tRM2PG1GktHLnhhKRYhyR4J/47szPhEyIXJKO4Z4
w4mHI3aTvCDxbVhSq0wITel68w4Ka5Ap8E+ClDcbh18kj33rSaY+v2hXbjqZbQPB
CTW7eG4YiGnST46bCxm4CggMBT54pgyxbFAhMcIYGvga8inHj5aj2GwwFzLU4lRo
MGQnIfXezvIJ0+/KJQ19rqUe4uegijIOrUQQSI6BEk0z3Hd25pO3ObO93mn+hQ1n
QXEMldOPCA4xhTl0E6In+XuKtjE+Y/ioUOejklvWpu8K63gJoAwOwI+dFn2Ddp+T
WSu9MT0D46pzns5P5wV9reTJzDBKTPNk712v2901rHcmYcu1PA77kpntd2RwkYkV
UXFomLKU6eBCBoQpUz5f74cDDebG4JNGsyuEAWJC5Kg9SqOZTvEDs7v/clIJK1K0
8AkNQjqtudjHx2U9UrDVsabz8mcwTtFuQaEN4igFrlvyHve9YddgtP+NclzMO476
L4spCJwbwoDvBkb5P/uP+1cbjfTsDdBp0Rknl7pc+QYXA8OiFO9+xyMII0+0aOSO
9wX5Gw+iISFMDBZcrsTpn7wDmO8MJGqHFp7W7Cv9iPaLVQhNtOCe8PhZ4SH3QLGI
WodD7fIYlznWzHacA87B
=+xcw
-----END PGP SIGNATURE-----

--=-2MrpRPtoMgLrBm2h1KYK--

