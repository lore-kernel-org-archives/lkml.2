Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab2KGOUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:20:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49043 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432Ab2KGOUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:20:14 -0500
Date: Wed, 7 Nov 2012 15:20:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Qing Xu <qingx@marvell.com>
Cc: lrg@ti.com, sameo@linux.intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v4 5/7] mfd: max8925: support dt for regulator
Message-ID: <20121107142007.GB20844@opensource.wolfsonmicro.com>
References: <1352282993-26449-1-git-send-email-qingx@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <1352282993-26449-1-git-send-email-qingx@marvell.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 07, 2012 at 06:09:53PM +0800, Qing Xu wrote:
> From: Qing Xu <qingx@marvell.com>
>=20
> Signed-off-by: Qing Xu <qingx@marvell.com>

Applied, thanks.

> +max8925 regulator device register is still handled by mfd_add_devices, n=
ot by
> +of_xxx, so, it is not necessary to add compatible name. Also, those reg
> +offset and id info is stored in mfd_cell(see max8925-core.c), as a result
> +there is not private properties in dts.

> +node's name should match with the definition in max8925_regulator_matches
> +(see max8925-regulator.c)

Please submit a followup which removes all the Linux-specific references
and just enumerates the supported regulators.  Please do also use a
subject line appropriate for the subsystem - this is for the regulator
driver so it should be regulator:

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQmm4MAAoJELSic+t+oim92OsP/AprjJEzDPZwSjm8VNna7DRH
PwNHbFMeo5nMIOACZglZTwHNBAtLa/vT5FG19/I4/gtXPGrtRSBwqPKZfnjf79bl
lcWxRSGqp32SPEEd4nDSW4UKQBer+0K4lUUGIpIZbTJwxZSlLgDoX/ULxdO+vDZb
g+DdEd/Fik/J5/zLC8r/jnRvB9x45JCNVn3WBizgLIJizUFT4zbML4ICzEEJh8eK
v3bP+r5y0dhvzIvTMS1QEBeWXtLwagbsf0eCujYNnYHC574mAHCuYxnBqX0S2X2N
KKGGRui7ztW1aCCzhN8RooSxt7kiIf8rqB3N5WUj4CFz2aPX/jIlEi8krZKeMyM0
b5dyhRx76H29blFIEYjdS5Du2XQOaE7AsInTb8Q1EomUhpk5jacCyQyyHuCZ3/09
GFooMBNeMJAgiFIRFtfjtp8miwYpYp8FFktKsZJFlxgi/eRlcd6GJoxnuNNt60Ue
6GVdTn3NsIQNvXDuDELp+KTZGyG2togU6Ly2YDBDXk3KBciqyk6CkGmVI5GfDxvx
E2vQ7xilRQrz3RDFiU1mo6vB78KashYNIR926miP9IGAprrh96WV3twBexhyF/LN
fXe6HUJ6i9TZF79Eo8dzil/yATx0cWWfmCo+D/UekoDLfKXCk6gMRDaeh+H0gA6x
IR1pSdri7Piery3bmAeM
=b/xp
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
