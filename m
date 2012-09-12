Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab2ILNx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:53:56 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:38144 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387Ab2ILNxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:53:54 -0400
Date: Wed, 12 Sep 2012 16:49:21 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: balbi@ti.com, Venu Byravarasu <vbyravarasu@nvidia.com>,
        linux-kernel@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] usb: move phy driver from mach-tegra to drivers/usb
Message-ID: <20120912134919.GR5732@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1346851223-29180-1-git-send-email-vbyravarasu@nvidia.com>
 <504F681E.4070402@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SWsnvgFfkTS2ATo5"
Content-Disposition: inline
In-Reply-To: <504F681E.4070402@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SWsnvgFfkTS2ATo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 11, 2012 at 10:34:38AM -0600, Stephen Warren wrote:
> On 09/05/2012 07:20 AM, Venu Byravarasu wrote:
> > As part of this patch:
> > 	1. Moved existing tegra phy driver to drivers/USB directory.
> > 	2. Added standard USB phy driver APIs to tegra phy driver.
> >=20
> > Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
>=20
> Felipe,
>=20
> I see this patch hasn't been applied yet. Can I ask that it be deferred
> to 3.8 rather than being applied for 3.7. The reason is that in 3.7, I
> want to add a new include of the header that this patch moves, and
> without merging the Tegra and USB PHY trees together, the two patches
> together would cause a build break. Now, it's a little late to merge the
> branches, since I need to send my pull requests in about 3 days, so they
> hit arm-soc by 3.6-rc6.

According to git I've applied this on September 5th:

http://git.kernel.org/?p=3Dlinux/kernel/git/balbi/usb.git;a=3Dcommit;h=3D1b=
a8216f0bc02af6ba70d1108d60eb1b064395e4

--=20
balbi

--SWsnvgFfkTS2ATo5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQUJLfAAoJEIaOsuA1yqRERgsP/3LuZeHco5judyy01tabcIqB
2fLTQTasdYJnMuaKgBC96Ql0iFzOivemXFcL2k8g9if6qrfiYyfmrV0eRjS7TOgT
UJvmRLZBBDVcZydIxP6b8FqAp+fTrkBSlS+cRrLBjyIA0OwzlQMwBpW5CMdf51qr
B2xlLoFKadvPmX7LrU/xcK93uaU5psQgt8q40APZlb5prT2Ip1PPwW3wb0cO2bbZ
YufAqjcnpsXh/ZYNa4q5UM2V+HKm4vYWzm+EBwu4ZEXtdzfqAWIR17qJSv1WBa2U
kFRIeLjM7zyxJmYxbmaVKky26UWkn0CA+T1AxTHc9JJf5EL3lG8uQFDQKv+GdrCK
Rg/uviOXIXv1e74GKFMLSMshMQ5SooetbEd6jTP7tErfB0Vs27vxQ4z99c7+2lzY
JE9Jg25dMIx1qOwGSKhgVvzRu71scTJucXClRE3CjgZMpmQk6ktwS4sxIEEqmDwI
vyyCMietjkhqcotiN7dDsYl0wBk+NPIKOmAdHFIndUmL6dQPt9leERENtuT9KV9d
JIcqxkQ9c6ND79Zrr18gFxEk1yBSojdMDpsdF/YIeKitRzMV7Ng/DJEx/ESnOAoo
SyVlRHpdVjMcccCl07jMDGLKz0JVETm1/gqnxVR4ZGKykYDxeeIDUP0cG5i018lH
mh52xM6sOI6yBzhcz40x
=3Xn+
-----END PGP SIGNATURE-----

--SWsnvgFfkTS2ATo5--
