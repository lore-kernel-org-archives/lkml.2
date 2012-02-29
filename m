Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2B2MBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:01:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:43694 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab2B2MBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:01:31 -0500
Content-Type: multipart/mixed; boundary="===============0046569571=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="130921205"
From: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
To: Huang Shijie <b32955@freescale.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "LW@KARO-electronics.de" <LW@KARO-electronics.de>
Subject: Re: [PATCH v6 0/2] patch set about the MXS-DMA
Thread-Topic: [PATCH v6 0/2] patch set about the MXS-DMA
Thread-Index: AQHM7HJtTKOcAdp5s0SJ9Za/ontjD5ZTRnyAgABXUB+AAD1xAA==
Date: Wed, 29 Feb 2012 12:00:24 +0000
Message-ID: <1330516974.3545.104.camel@sauron.fi.intel.com>
References: <1329373053-19494-1-git-send-email-b32955@freescale.com>
		 <4F4D9725.3090100@freescale.com>
	 <1330502098.3545.78.camel@sauron.fi.intel.com>
	 <4F4DE0E5.8070808@freescale.com>
In-Reply-To: <4F4DE0E5.8070808@freescale.com>
Reply-To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Accept-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.160]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0046569571==
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-dxy0Ud0PxkI2+rsV+EdK"

--=-dxy0Ud0PxkI2+rsV+EdK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-02-29 at 16:25 +0800, Huang Shijie wrote:
> Hi Artem:
> > On Wed, 2012-02-29 at 11:10 +0800, Huang Shijie wrote:
> >> Hi:
> >>
> >> ping.
> > Is this patch-set independent or requires something like gpma patches?
> >
> This patch set is independent, and it does not depend upon any other=20
> patches.

Pushed both to l2-mtd.git tree, thanks. I am worried that it touches
other subsystems like dma, sound, and mmc and there are no acks for
those. Would be nice to get them somehow.

--=20
Best Regards,
Artem Bityutskiy

--=-dxy0Ud0PxkI2+rsV+EdK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPThPuAAoJECmIfjd9wqK0YPEQAIdtSC183iSAHeQZIz2m5DXo
VmXvG3iRD39a2vn+IfxVq/Q+PD7F56ybyjnB/E7c8WFQjuY8MHSXW7YjAYfStAsT
U8GjmhMVdmyekv5+rUCSsxXkdKjqqpenywaEvxi7yUH7dFvOLJr1J0ELb4WBcwPp
rfYNpTfpkAKFmvvyG9YPxgmvMSvSXz/Q3vkAd73/0HsUB9FQQPVMXWfxwocstCrN
G4owMtElCgEFKdMKIqqGyD0vk8JRH46ZV290MSESg1JgNtVLSBCOQ0voQpK3xHf5
EZYEsdgGXboHEyrLrykNGhuIqDr84eTnRmo6XoJ+WXJAHa+MomFSDUmyMKTXMMr3
wAwaHKpR41nNBjeCyxg4cyjU2/9n5eBDSJi2RP7EMSIlhdDPTWMih6faolpyqnd6
nawlJA00dU5jjOU1/czvQxzzYYTIrBCxPA/WUpBkBRRoogR7I3rLb0eU5j15cwVZ
HMoYJmVPiMs4XhoumbfgGUXy05qFPtk9E4Pxuw2r9oMjzVR1nEQHZExij2itt6wW
ydiF1YEFaqVHG4EdEGjx8h6BQ7Kp+9JQbLUKxYFqeFX3MaXlH7LtZQ8RM1JBDa8K
+izh4qIdFz5f16XFEkvrHiJwob/m9RzdB+Uygv9oB5mMidJwPKC9j50lzIlusTjs
EStXeQuYRxHvB4KT8Px/
=dHvR
-----END PGP SIGNATURE-----

--=-dxy0Ud0PxkI2+rsV+EdK--
--===============0046569571==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki =

Business Identity Code: 0357606 - 4 =

Domiciled in Helsinki =


This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--===============0046569571==--
