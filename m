Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab2K3M1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 07:27:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:16539 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab2K3M1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 07:27:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="asc'?scan'208";a="227126757"
Message-ID: <1354278498.30168.117.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2 0/3] mtd: nand: OMAP: ELM error correction support
 for BCH ecc
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Date: Fri, 30 Nov 2012 14:28:18 +0200
In-Reply-To: <518397C60809E147AF5323E0420B992E3E9EE329@DBDE01.ent.ti.com>
References: <1351667307-447-1-git-send-email-avinashphilip@ti.com>
	 <1352978534.2221.33.camel@sauron.fi.intel.com>
	 <518397C60809E147AF5323E0420B992E3E9EC70D@DBDE01.ent.ti.com>
	 <1353581032.2701.34.camel@sauron.fi.intel.com>
	 <518397C60809E147AF5323E0420B992E3E9EE329@DBDE01.ent.ti.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-8jPZi022NpBpQM/WRPcg"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8jPZi022NpBpQM/WRPcg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-11-22 at 14:37 +0000, Philip, Avinash wrote:
> Idea here is to make faster scanning of erased page without bit flips.
> For omap nand driver ecc reported by hardware is non-zero and non
> 0xff.
> So comparing with the standard vector for erased page and skipping
> error
> correction for erased page without bit flips.

So you mean that when you read a page, and you see there are bit-flips,
you start correcting them. But if you notice that the page is actually
an erased page, you optimize this case by not running the correction
machinery, but just filling the buffer with 0xFFs. Right?
>=20
--=20
Best Regards,
Artem Bityutskiy

--=-8jPZi022NpBpQM/WRPcg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQuKZjAAoJECmIfjd9wqK04BAQAMdj8aqZXwDw2xG4e/W70z9B
ag4zzfd3z9S3hxZ4qLA8HxlVsVL6Vm3uDqiV3HCyZZV1H8MvOJx/IQ2eialHNXHL
vtkisS5hHV0dNSVmgsrUKeNxFsyZBbECZYCZYQfNre6ce9+PIviiL8OtUI9oMceY
lQQy4KhD0Wm/NCuxWjk3GeJYHlwEkwRJAQakoRLw0ReZuPqBR2SkcqSUvpyInniG
X4oSrXSw0y8N7UhwU+S/w/0Kw3iSceU1WkncJ1E8Az1/fE1emjRANcq9pN1jfqmE
gjgRRblyIR+uJiyDkFpFnPcpqmVfcTiQN7AuwW9+fHZf79OzD+YkASHbV+qklPPt
U/ybpQiHylQFyHEEf39MwvkInDIbxf1ac6vEqyfl7k6WMSbQvWoPy2Wcm0P0YINb
XtO6cRkzHXy8v4GZ3rWlzOI49RLD0WB3Un0ycv/gZ6EgvTGYJjMggd6qLElVMmqK
EwRcqLeRBLRffjulxyN7JPic20AlwoT865pXK/wn92zrK2BopDDugLSZbSU9d6Vu
EUEc660E9Wfr0vKP9GERHQQGHyU5kwKg7hpqxYpYxmEJbduumeAbiP/xOENelyrm
nAswYI03M1WHOFluClKAEkr8pF2h5CYK83+2RoidHVrE9TPXwK2lVKdxafifrJ4W
AAKb9vaRCoWSG3Q+N54K
=A5ob
-----END PGP SIGNATURE-----

--=-8jPZi022NpBpQM/WRPcg--

