Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2JCHU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 03:20:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:16843 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab2JCHU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 03:20:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,527,1344236400"; 
   d="asc'?scan'208";a="229332503"
Message-ID: <1349248843.2017.108.camel@sauron.fi.intel.com>
Subject: Re: linux-next: build failure after merge of the ubi tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Date: Wed, 03 Oct 2012 10:20:43 +0300
In-Reply-To: <20121003122735.692388e2f68dd85e43052c70@canb.auug.org.au>
References: <20121003122735.692388e2f68dd85e43052c70@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-CZWmydX3VkSKW6OazrId"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CZWmydX3VkSKW6OazrId
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-10-03 at 12:27 +1000, Stephen Rothwell wrote:
> Hi Artem,
>=20
> After merging the ubi tree, today's linux-next build (x86_64 allmodconfig=
)
> failed like this:
>=20
> ERROR: "ubi_update_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
> ERROR: "ubi_scan_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
> ERROR: "ubi_calc_fm_size" [drivers/mtd/ubi/ubi.ko] undefined!

I've added Richard's fastmap work there. I'll look at these failures.

And yes, using the previous ubi tree is a good decision, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-CZWmydX3VkSKW6OazrId
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQa+dLAAoJECmIfjd9wqK0avQP/iczdYXdI7PEuMczynpwYJGA
sdYeCz9I3bB9qd/sKUP2NKpeY82dFuZeM7FXDnsfrN+ElH0RG2zYg3eFC6H1YNeU
Njffqtxla33R8qXl89fuHp1XDMcw+Ue3A2cdxabSbBAmkxibx0VPQm64sR+0qxUg
JMueEig+mWBrCCc96UEGb7DvpccWIcIZZQaGt8bta86jjKgddmVQK6dx0w4ZXbIJ
hX7n8X4bR/lAwviMn0wxSZhRtRb7INAeTmBLbTaarxQjF7icViqNp4WbubChaqbH
VlouSTGwx4NZwth3o4/0Yo6UNVyP0WsFCSQBHXTohhkaFbp5Mvny7jHNrn3G6PKW
el+BwVgW3QMltbQL3GFRVfhx2GwlUQNREUH5SBuTweU2fnHo5IU78GaDtAJdXor3
X3ry+nIzGVxb7zuHr3V/q/RmMLgDtfUykjjTjrgAHlUhr+lay5hAqMmkxV5067OC
Qn4h4dyT/JxqWUHI/qN2AOy+T106KKSH5gkmGSfmcUZochqqZOZUtjcYyfQxYn1Y
YBldVqALUQ6kDFX59pPGdHpbTJIZYhWpGPV7bTppf9stfHLy/E4L0qujw3XIA/4h
ddTxHamXYup9SQdq9aq+aITA/s/0lg+Z7OjyCnBINMOSxnsTKHVYho8Pw+5dRMkW
DgVmCO1lPQpOKSDCiA61
=lau1
-----END PGP SIGNATURE-----

--=-CZWmydX3VkSKW6OazrId--

