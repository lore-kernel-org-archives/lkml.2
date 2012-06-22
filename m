Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761724Ab2FVIkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 04:40:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57426 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761702Ab2FVIkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 04:40:21 -0400
Date: Fri, 22 Jun 2012 08:13:14 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, Laxman Dewangan <ldewangan@nvidia.com>,
        lee.jones@linaro.org, lrg@ti.com,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by
 regulator-compatible
Message-ID: <20120622061314.GA15627@avionic-0098.adnet.avionic-design.de>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
 <1340194987-23654-3-git-send-email-ldewangan@nvidia.com>
 <201206201924.09618.arnd@arndb.de>
 <20120620194609.GA4037@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20120620194609.GA4037@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:b8vue29znnqC4gEUR1ohR92PSDVTD2zVqZ2NEKy1+L7
 lZB+Xd4jrtK0vE9uo2wXYh02qCofkKBDNBxuhrh9sCA6p4Pcrf
 Np3FdBqnCASLHqgjk6reQD0F12kYwcoUIsnIffIKx4H2o6+n7A
 KZFMA1Wjng2LWL/dMEKfRP/FtTTBRV9/GBSFw7k5MfKNcNXhWo
 zlVqE+Zr9RBpodn2YLQPXqF4873CJiEMX1lHuaVGx6sRs2+YLt
 orAVAwfUSviF808lNWIvMm5/c+RClz9bTy7v5sF5h7munCxFxo
 RT9r8Wl0OmbTv54MEcFeALWBydW5xIlotgoASoD7UPY4WsrTp2
 1i3FyY+jyzJEuOb1hJG1ElkLnInMGQ4RaeOuI1ZdukQQx9YGwF
 Are6SV6XvuGTMSTsKc1Ye3R43Gzs4LNoTE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 20, 2012 at 08:46:10PM +0100, Mark Brown wrote:
> On Wed, Jun 20, 2012 at 07:24:09PM +0000, Arnd Bergmann wrote:
>=20
> > 1. What is it that the new property can express that cannot already
> > be expressed by using the phandle.
>=20
> As well as being able to refer to the object from within the device tree
> we also need to be able to tell what the object represents - we have a
> bunch of regulators in an array under a node for a PMIC and we want to
> know which regulator on the physical device each array entry corresponds
> to.  Previously this was being done by parsing the phandle name but that
> means we can't have more than one device with the same set of names.

I thought the reason was that matching the node names up with the
regulator names was considered bad practice. As Stephen already noticed,
the matching is done by node name, not phandle. Correct me if I'm wrong,
but you can have more than one device with the children have the same
names.

Thierry

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP5Az6AAoJEN0jrNd/PrOheHkQAIaIK+A24GJcH4rPatPpVx57
L/SipiL1qo8qoL8ulMjsxaCibXzRlN6GVsvQDWea1Dm4AYxEDvbwklC7pU6dTzT5
vGkTod1OfHvn0ba2XDD96QodYV9tC/SGyjXgucGOyfq6OJNsCtfGtGqQv7OF8K/U
JEZtSkusj3bc0PZmv371hvtUoJLlPXSrtQYk1btL+OPfygFKox16Nndb3NFpvaIo
joMAgg/Y7TABRoABAyp3CUlKDQ9pmx1CgCmtIYSA+eE/KRQVdecQqRtV2jv8I9zt
gqYxs5wnUF/ylLjIt8VyqLD2AyHu82YjJCeWmdofVMCp53ZYmd9MEGERPUFimp8o
ZISadrZ3Nt4txpo+P172ldAPvfCpKYNnHnwnGLbTJUAz9V4loUHVKSZjyKLvpMO4
ezcsegAgeR0RsfVd2ky5/4nOtnyQOuAAIRtzhxWqlvxhb6aNRZ+kjyTjKtuGPCEC
QcNPfo/39g2/pZLrAj9AExScvYFQ4WNuhGRZ9vxD9fJXgxx6iP0R71CYK8DGFmyK
IbAcRLDleToMd68H2nrg9+6GfUCpH9kZEWue+m8iVFSqmGQqbrNfD02lGha1xQMx
aVUINOMUZGkpYuzn50+qzVPwI01djA+zby72L9AqpA3RvzUcrTifyoQpnBir+ir+
WD4xjsx8H0qo8rYmsYmt
=nm1n
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
