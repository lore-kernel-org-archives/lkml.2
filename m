Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767884Ab2KONuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:50:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:10828 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767828Ab2KONuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:50:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,257,1352102400"; 
   d="asc'?scan'208";a="247447686"
Message-ID: <1352987449.2221.51.camel@sauron.fi.intel.com>
Subject: Re: [RESEND PATCH] mtd: davinci: add support for parition binding
 nodes
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        dwmw2@infradead.org, hs@denx.de, nsekhar@ti.com, mikedunn@newsguy.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-keystone@list.ti.com
Date: Thu, 15 Nov 2012 15:50:49 +0200
In-Reply-To: <1351866161-15516-1-git-send-email-m-karicheri2@ti.com>
References: <1351866161-15516-1-git-send-email-m-karicheri2@ti.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-cIDqQXKT/hKZqRWFQxti"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cIDqQXKT/hKZqRWFQxti
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-11-02 at 10:22 -0400, Murali Karicheri wrote:
> Enhance the driver to support partition subnodes inside the nand
> device bindings to describe partions on the nand device.
>=20
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-cIDqQXKT/hKZqRWFQxti
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQpPM5AAoJECmIfjd9wqK0DzIQAMmgiCv4Y21upsshcR3vTlmh
3FzvJeSwFASb0pedw9FrELADnT2RZSMpuVD9fpDNxDdjGNGxGcLNFyX3jsTRCCKu
OquCi6m4U0If3abBsxsmOLXRB4vtzFGRvDx9A/krBUfEservNbT9l8ehQjaOLEru
JtIG+dgsdh9+5htUfDhV22MbLB9jQStfDOsE+nHUYDziXtEl3kiXWj1JwNtNCMIo
o69o39t2fRBew7A/d7e+iVKtoEfqgs2JvG2yiJfrYh0JKmKU+1gG9nxJV6YJMHh+
zRSCmklyxHOptgA0tDNiqEp2IlUl4inwGoXSiGilW6oZcoB/dnXxXJ844GQzphEh
D38xes9wAkiyBX8LPt2dbvJPjxbmAs68WJ6ioCRpfi8/KxRVpYXFg8TtYglSb/71
Hn1wYPAkiHk97vgA+recwwvQO9s/0tBsXVBILOPgQ2Ym0BIahBFjyKBi+2e48Wf2
I8Xpnb4ZFTCgc7WofFMneylAqm55ZHE2IM1X2smDh2yUVrRLvxSOH6VtOcO8aECE
P7YuW8vcEG/nuLalb1iDNJTK9YlV4Ao8rWBAwtvKe3s8hFa5qgC0pt1pRtFEFhgc
w/789s4ahhVr+ewqYXHkDLvV/MWE7u2rwgZ+Mc5uBNs61erbtl1B9upG9JtVaJX4
r5cmFYB5xeuvHgq3W99x
=bFi+
-----END PGP SIGNATURE-----

--=-cIDqQXKT/hKZqRWFQxti--

