Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2IZJtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 05:49:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:17878 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab2IZJtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 05:49:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,489,1344236400"; 
   d="asc'?scan'208";a="213461968"
Message-ID: <1348652962.24309.53.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd/nand/docg4: Add missing HAS_IOMEM dependency
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Peter Huewe <peterhuewe@gmx.de>
Cc: David Woodhouse <dwmw2@infradead.org>, Huang Shijie <b32955@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>, Shubhrajyoti D <shubhrajyoti@ti.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 26 Sep 2012 12:49:22 +0300
In-Reply-To: <1347662469-1604-1-git-send-email-peterhuewe@gmx.de>
References: <1347662469-1604-1-git-send-email-peterhuewe@gmx.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-OojqlFTNNvdfLLprShSg"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OojqlFTNNvdfLLprShSg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-09-15 at 00:41 +0200, Peter Huewe wrote:
> While building an allyesconfig for UML I received this error message(s):
>  drivers/mtd/nand/docg4.c: In function 'probe_docg4':
>  drivers/mtd/nand/docg4.c:1272:2: error: implicit declaration of function
>  'ioremap' [-Werror=3Dimplicit-function-declaration]
>  drivers/mtd/nand/docg4.c:1272:10: warning: assignment makes pointer from
>  integer without a cast [enabled by default]
>  drivers/mtd/nand/docg4.c:1327:2: error: implicit declaration of function
>  'iounmap' [-Werror=3Dimplicit-function-declaration]

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-OojqlFTNNvdfLLprShSg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQYs+iAAoJECmIfjd9wqK0mMMP/RIBCiw915b0dXx77dkfE2vB
Kvfzm5jSb4BwnBjFohaAqJVi/YrA+56loFkzAKBCTh/BIiA8GAhPo99nkbr63hb5
ayJ/Cv3sw45CA3Ny6Wou8xhSailEhRc1z1zr8xWSXSxia7RryhR6ayic0wUl8jGI
ksIebbWJ9nspw4/+Zr0AQmamLse21y7eaqAQJMRcrWcw6mxVAJA0eQ6HK5B8Ebw8
38WkYWmi8UecnGBdBGzgphjEpXmhG1DoTE7hGYfepLJ6m8Hq50SbOqDRAiD8FhUg
WEMIKTVxeXoj2g89wWAaf+Q9NprHdaPSwDN5q07CVMVYPD0mq0WHfZE+N2Qumaop
vXRLUjF07EJBRgy4GIgput7k/owESOweq3GwFEcr1QXjb86T04XHwcisKwRbNNk2
Xo/qmgX9nYj3kBree08rOy7Ua7/iX+UTHknSRbZ8ngjZsk/Wx/6lwmtUiDTQMJmJ
CLktwYROVh5YLcLlK+Xc+U55W9zByFcf50nnqxSVMXuNEN3eeZhjlbSn0C18G+Vt
WeawzkBpnvCSYTCPhQk87AuybYEAfGqaxF74/UPHsu9LGtpdkLscHWqFC6mAePyy
ONjJlYdN25+RgYXkEN2uWOwRmf/BHfu+IffNr7KK7WyAmB3FldClPLk2PuOfniC9
JqA9nbhFHRGPxeaM8qfD
=4Gag
-----END PGP SIGNATURE-----

--=-OojqlFTNNvdfLLprShSg--

