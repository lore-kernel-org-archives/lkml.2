Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab2EUOQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:16:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116Ab2EUOQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:16:25 -0400
Date: Mon, 21 May 2012 16:16:19 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bharat Nihalani <bnihalani@nvidia.com>,
        Vandana Salve <vsalve@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iommu/tegra: gart: Remove unnecessary cleanup with
 devm_*()
Message-ID: <20120521141619.GB21513@avionic-0098.mockup.avionic-design.de>
References: <1337019127-6863-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <1337019127-6863-1-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:PZwoKzURZPHYJoOzPd4Gp9SGfGfnqhwRnj3YXas1oCf
 I8A31S6VvD3rl5GYOyeTKNdZorjJGtBNMgsOzXHj36Y/9OTCyk
 vm6zkn9H1gfluxZRvNlwyWQxVyV5VAsj4Km0dGZELmFhC+4EI6
 CT1YMzgr6mA5yxCnWy16sVc0sBcgPcbDxEfgSpRqgavo40wV/J
 51HY72qNbcrtmyzJdgrk0EM7mboMgDyRqefOaivWlQHA4jMhfa
 Xlo4AQcWHezznvSmgCWlrtG3eT7ZJlDsYxSm/nzU8v0dBvfv6u
 dojxxcLIbFSFZq2LPVe0DJ2WlwGGCkhO3gqFUOBTF43G/AK5tO
 jm/hd/uH2lS3ca1xyTYqGHImrh63h67plzy6JC7P6tGXoISCwC
 OECxbypIA7nHVDK0hgrqeedW2nbvkCPoBA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Hiroshi DOYU wrote:
> Remove unnecessary cleanup procedures with devm_*().
>=20
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> ---
>  drivers/iommu/tegra-gart.c |   22 +++-------------------
>  1 files changed, 3 insertions(+), 19 deletions(-)
>=20

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk+6TjMACgkQZ+BJyKLjJp+4CACfbDPNm04hXdSTQy1Xnpc+RlSN
ULQAoIiBJwfbh8g88+dapELylyzz/wQB
=/pYT
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
