Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761718Ab2FVImd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 04:42:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53679 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761684Ab2FVImc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 04:42:32 -0400
Date: Fri, 22 Jun 2012 09:42:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, Laxman Dewangan <ldewangan@nvidia.com>,
        lee.jones@linaro.org, lrg@ti.com,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by
 regulator-compatible
Message-ID: <20120622084228.GD4037@opensource.wolfsonmicro.com>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
 <1340194987-23654-3-git-send-email-ldewangan@nvidia.com>
 <201206201924.09618.arnd@arndb.de>
 <20120620194609.GA4037@opensource.wolfsonmicro.com>
 <20120622061314.GA15627@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3cI6DWK3Xt33P8nt"
Content-Disposition: inline
In-Reply-To: <20120622061314.GA15627@avionic-0098.adnet.avionic-design.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3cI6DWK3Xt33P8nt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 22, 2012 at 08:13:14AM +0200, Thierry Reding wrote:
> On Wed, Jun 20, 2012 at 08:46:10PM +0100, Mark Brown wrote:

> > As well as being able to refer to the object from within the device tree
> > we also need to be able to tell what the object represents - we have a
> > bunch of regulators in an array under a node for a PMIC and we want to
> > know which regulator on the physical device each array entry corresponds
> > to.  Previously this was being done by parsing the phandle name but that
> > means we can't have more than one device with the same set of names.

> I thought the reason was that matching the node names up with the
> regulator names was considered bad practice. As Stephen already noticed,
> the matching is done by node name, not phandle. Correct me if I'm wrong,
> but you can have more than one device with the children have the same
> names.

We're talking about consumers here, not the regulator driver finding its
own regulators.

--3cI6DWK3Xt33P8nt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP5C+sAAoJEBus8iNuMP3dzpUP+wT8+2K8fV7TVtX95qPlg6/T
6JiMUUe9DPmSQa/iLcIENHDQ3RJq0P9Byvot18CBezYmFJw0V6ixS09YVruRB01i
r/KA9oUms2Qf3GVfGIAayjgeUUTdjek/8ZUT5jD36TU+BG+JRD9cDJNgKmR76Xqd
cBommSSku1bi+Y/2rzP/2RCl+npDY5tpXi4t7mFe551ontEXYWC4U2dY7wdDH/K0
xRvqt20G31hnwQkMpMInC2l2KKGI3InvLjp//rkAOTXvKI5hB43Bb6Myk0cNrpH/
G6DGyGxpSxd+uZPN9wRV8vA7L/cejS/2hin1dFAHt3/av6luGtDjnUGbnUnIo4sE
12KfLEagCfczgyZSrVdK9aYhRk8FIcQ9eQducU8ZMVg1D8al8Zp6YMmkGIp1TAYC
iNokv4nDWF+4fxsLz7EO63GwrjLHPgvrbVu+NI8FF/krOIYx+yEQVnB/xMdMHwao
W6CEotFlmUhfvI33NGXyIGLOsmsY3xvmFvyGe9/Fys8Jp5E8W1yXi7t8iNDLZooK
W/zBzHKRUjh/y9ITA9ZA9FyIy07DqMkbpqpq/Yt0Pr3/xUkmQP7kA+iy7sCrmsw7
3Y5Q/HlWO3RK25Q7U+2u3pmA9YDwSoC0yhaoUgwJJ3WndJcqWhb7qdteLDMak7qi
aaAtpGrR2qlS9tZdwmF+
=zkqS
-----END PGP SIGNATURE-----

--3cI6DWK3Xt33P8nt--
