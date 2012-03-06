Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab2CFTJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:09:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60674 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289Ab2CFTJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:09:23 -0500
Date: Tue, 6 Mar 2012 20:09:12 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Mike Rapoport <mike@compulab.co.il>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/2] arm/tegra: add timeout to PCIe PLL lock
 detection loop
Message-ID: <20120306190912.GA13882@avionic-0098.mockup.avionic-design.de>
References: <1331023544-6439-1-git-send-email-mad_soft@inbox.ru>
 <1331023544-6439-3-git-send-email-mad_soft@inbox.ru>
 <4F56424A.3020305@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <4F56424A.3020305@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:lnerr/B1lT6og16vwWfZf2uIVc+4P49fEsPh53mbfte
 CSxRwUsGcdd7YBgbazU0FfW9868Lana9OloE1dKWCC8F59iXUk
 VroiDVYY6kGdjKRfgk36Gpfz+sCrMjGkds1FEagBuHtHkLKNwg
 qx4A0Iz1yGH3LG6yxd+BK6QvjaRgN6cQemArnprwy1SRgcLw33
 zE6AV1Z0bij1mYLjfSM1H7a5tow1sJNaOuJBGMVmq1zx5pbf+U
 B/EgV5itwNZmWWARhVMGy20PEkscIPeeSKhSKMQZaC3OHlDY1I
 fp0sNBruVZd6NBoJqAfBob8j9rAekCloyto36HmSXChDtJuizI
 AAR1v4onB5d8PetR2vJr4rj//ESerWb2oLYY9YPt8MtsACxxD1
 uZaWG7b6mIbE0wicTndGJ/5G0miZJYiDCc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Stephen Warren wrote:
> On 03/06/2012 01:45 AM, Dmitry Artamonow wrote:
> > Tegra PCIe driver waits for PLL to lock using busy loop.
> > If PLL fails to lock for some reason, this leads to silent lockup
> > while booting (as PCIe code is not modular).
> >=20
> > Fix by adding timeout, so if PLL doesn't lock in a couple
> > of seconds, just PCIe driver fails and machine continues to boot.
> >=20
> > Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
>=20
> That seems reasonable. So once the mdelay discussion is resolved,
>=20
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
>=20
> Any idea why the PLL doesn't lock sometimes?

I've seen this happen when the 1.05V regulator (GPIO#2 of the PMU on Harmon=
y)
isn't enabled.

Thierry

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9WYNgACgkQZ+BJyKLjJp+IHgCffb+elfVXEdHsy1qNudzI/8PG
h8UAn2Jn/coRHAtmXh9YG+K4voKDQFar
=6aCj
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
