Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab2HXL7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 07:59:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:19350 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab2HXL7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 07:59:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,304,1344236400"; 
   d="asc'?scan'208";a="184924703"
Message-ID: <1345809866.2848.301.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: m25p80: add support for Micron N25Q256A
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 24 Aug 2012 15:04:26 +0300
In-Reply-To: <1344972247-23583-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1344972247-23583-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-JZ1P7xzwqE3gQhyiltfN"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JZ1P7xzwqE3gQhyiltfN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-08-14 at 15:24 -0400, Vivien Didelot wrote:
> The manufacturer datasheet can be found on the Micron website,
> under the name n25q_256mb_3v_65nm.pdf:
>=20
> http://www.micron.com/search?source=3Dps&q=3Dn25q_256mb_3v_65nm
>=20
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-JZ1P7xzwqE3gQhyiltfN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQN23KAAoJECmIfjd9wqK0g40P+weDVVIBJzdXd/gwstJce1yZ
DGhDP+HYs+Pxj5eTzxydJYQ8iEM3dTl0Uy5P6Efvzu34xqGGO69LUKlnKJN92np+
khlg5wI9Q7h0I2cn8evcug4E41CsnPrrMre6Wmfz8x2j17EZHP/xHnReqm2rLA7g
H7WOcnLho8JFS/hNP/BpsJqUiqTAb2YHqDXk7V774VeMkot8SCeZK0eHk8Uy5DTn
OGzXWTdiJbbUC/y/ixHfUXlJO+H1Pi46CVhxRKYJb+qR1Ye3WUoUuKsLuwdaNuJ3
zIvoXrCCHW+k6D++JbJJcrPSnE1e4jFwx4ZFGwSGa2olvxOnB8pQqZZObPCfbrVN
ZHZ1O3WyURx3Z5Sw2BhfUIBwoPter1gC+1cTaDnaqtm8nodWiaDSbgzxCWwbhZtB
29ISfnyLYbXHqbnjObLjSLMtUOau9JANQf8M45C34t0Hm2H1HOBrwVS6KWd+A6zj
ATVbSNyPmtCB2ykMSb8RJ5NEBueIyCg/zC9QC1QghGm/pmlqYNDrq7pum+5ZM7i2
tNdRGqQ+fPtD5J9xZLWUpDNP4PJZ3q/ttvVMnxDgmkBc0Ww5dwlGJJ1neYKBel2q
urNR28vOea6qxeZGH8c7vOgc7Z0muO0AgApqoq8oI9eBiH6/J5f16DvMpK92229r
bUDr99WfwzrKwZPCYynw
=3ZyC
-----END PGP SIGNATURE-----

--=-JZ1P7xzwqE3gQhyiltfN--

