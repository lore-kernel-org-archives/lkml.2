Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2CMXWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:22:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52741 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877Ab2CMXWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:22:12 -0400
Date: Tue, 13 Mar 2012 23:22:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, axel.lin@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 1/2] regulator: tps65910: Provide settling time for
 enabling rails.
Message-ID: <20120313232209.GW3177@opensource.wolfsonmicro.com>
References: <1331618721-26326-1-git-send-email-ldewangan@nvidia.com>
 <1331618721-26326-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SidV/bKy1CyabPX8"
Content-Disposition: inline
In-Reply-To: <1331618721-26326-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SidV/bKy1CyabPX8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 13, 2012 at 11:35:20AM +0530, Laxman Dewangan wrote:
> There is settling time for each rails when it is switched to
> ON. Implementing enable time for returning proper settling time
> of regulator rails when it is enabled.
> Filling the on-time for each rail as per tps65910/tps65911
> datasheets.

Applied, thanks.

--SidV/bKy1CyabPX8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPX9abAAoJEBus8iNuMP3dc9oP+wYLtIiWhumJpGqpbvmSHnQS
Irkqszci0spWQHsCnSfXqOySqekUuj51ykcUYLvp/BAiFKdTB8DBsco2cIdnLtur
HE8ioke9v4HeuIFCtcDgmgslc0lPJnPwGRP0lRGSno5gd1fWArke7hPrzhplp3Y+
BgYWo48UrqW99/f7HUBQ/IHf28mwrz2eKWrqo1Dd8H2FYfqr7zIBXvuf1G3buS0o
tXFlPDp6Zas9Ggqhprv1yS+CE9P82iqDVb4bnxZIZtyGAHRSclACaKUYb3bx4Ftl
d6n/VQ6hATU1/6QpDcNef+ETyMkhG3+scC8vgA46hSLa+vsVjaZYEY/MoiycCkS+
O3nofMrWvoMj1VSLL9KciZbn0/zSH/7/1JYEdRptt0SktPiqxyIAMqxdR0+6eok0
yNLDor2uDf9CPfTZ6H+ujjHF5bGbYiBdzURCzVFiF+eX+ZsP5LpHeI8xkHIIqVae
/V0dLiICvUvh/em59CyUzgqC2XJkvSvzCqVuznmlTfOsZLmT2POt82j9RnvNuoJW
0YdtbysZ1DNFCz/FcxMhvzb5d49u98MlKSgbYnrDQnEn46jmva+8wvSmQP0N/tPg
cKoJ735wbyAM0A8hJ5LfWCvXCvy1F80IGEx/5LkodaNMe8LtjGts7h9F3zsHgD3E
Ye/B3VqhnRWYiFamUrIM
=r6oY
-----END PGP SIGNATURE-----

--SidV/bKy1CyabPX8--
