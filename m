Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab2HQKnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:43:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59114 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733Ab2HQKm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:42:56 -0400
Date: Fri, 17 Aug 2012 12:42:39 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bill Huang <bilhuang@nvidia.com>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, broonie@opensource.wolfsonmicro.com,
        ldewangan@nvidia.com, swarren@wwwdotorg.org, xxie@nvidia.com,
        lrg@slimlogic.co.uk, jhovold@gmail.com, kyle.manna@fuel7.com,
        rklein@nvidia.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: dt: tps65910: add power off control
Message-ID: <20120817104239.GB27633@avionic-0098.mockup.avionic-design.de>
References: <1345194989-11614-1-git-send-email-bilhuang@nvidia.com>
 <1345194989-11614-3-git-send-email-bilhuang@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <1345194989-11614-3-git-send-email-bilhuang@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:2vcnctdz86kmzbtIZRFiuaJaQG+rvKf1ZZJ8rpyBaVL
 0yfeDeMhs+nZHkLGV8Hl+Zly52gYQTRTc/gnvVGIQtFgLosHOh
 r33GIaXorVZ6d1O+7rN/bzjOvEufGR5oIYp/Detl1UrbtSfEJq
 8Vyzqpziyd+hKf3ePtYheIa4Z3ZxXhtBAHL4Aeov/OavR9DkX1
 YCEE6rg8ESeMPdoqT2o8VjG0byE7lsDTUh12pgvieIWFXWCYnw
 SIi56oe813InOGAz6QMgm6+kbqqTzxPiOGKlmSPg52jMAHu+2V
 V+5bD1+7LY+U1J3uSsE4KsTc+BceIHtI60nCZlDH3jYj8cXOEt
 ESkUVMDWwX4DIqRyqnxBKlD0wuipSlRKYkWINTtDdrAhIioiIq
 hkHXQAXgb+01RJ2bkKuWQVZ9hc3xJ9pbJUlzpKsSrn2vUyfYz9
 6pW5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 17, 2012 at 02:16:29AM -0700, Bill Huang wrote:
> Add DT property "ti,system-power-controller" telling whether or not this
> pmic is in charge of controlling the system power, so the power off
> routine can be hooked up to system call "pm_power_off".
>=20
> Based on the work by:
> Dan Willemsen <dwillemsen@nvidia.com>
>=20
> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> ---
>  Documentation/devicetree/bindings/mfd/tps65910.txt |    4 +++
>  drivers/mfd/tps65910.c                             |   22 ++++++++++++++=
++++++
>  include/linux/mfd/tps65910.h                       |    3 ++
>  3 files changed, 29 insertions(+), 0 deletions(-)

The same comments as for the tps6586x driver apply here as well.

Thierry

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQLiAfAAoJEN0jrNd/PrOhSxUP/27inzoTXZrLGBCY4IbIpCvm
4uSytMuF2jTg4tjfdyL8oQiZrOmn+tL2P4NmfWtPdPsitCKNN8WfifaWwDKgfRNf
uYsXqqkTJj3taGf0XUckEjRqFNN4vsEw9/xJPAifFaPe64csr+RjbG2Pv/+p/X5A
Tq51vakF8ResilT6uLXS+SvRdl1cmkmWYWGwgrrXdkE5DzPMd6LbEvEMMxziVJQS
r8Q4RtUjjXTX0nwKGobihid2QMwzPTpv7C0zzwQoLkcR0OGSwuatGsc13uLNePyc
tY+UHiJhv34vu15GU5VpIisy5mFxLGtLzzo5pgdp4E8AfeUgHbIqOHo2OYajgjok
G4qA2oLtY7w2Xhn5X3L9GImHKhdbq9JgWvvg567aRnOP070d+WrAcXtWDBwjY0ZC
CGX3l9+KxncJqMvv8I2aqkXj/2mmq4iSoIaCWsDdCxGAt/A++WDJHFQOkvO3O1ON
YZBD4HnBhiInZcGhxe6tukS8A2wcK9iWemNYaTi4xk4oAR3iSKO9BFSq9F6sXapl
lftQ1LtK8fPFWoH63vAEkHEGri2V9qtmOFDtf5cOdIdkHsALmq+BscKXMPISanC1
I6Vux1gS/Exl810JijzvNuuzUa9QsEK8NbTlDzRfGSb0q9ISfmJ/Rj41N6bcRkIe
UNxl4DRwV3V9/aL2XeaY
=J3+f
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
