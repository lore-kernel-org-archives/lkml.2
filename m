Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2A0Rhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:37:35 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:33657 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751977Ab2A0Rhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:37:34 -0500
Date: Fri, 27 Jan 2012 09:37:32 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-pci@vger.kernel.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] pci: Fix typo in setup-res.c
Message-ID: <20120127093732.46425cca@jbarnes-desktop>
In-Reply-To: <1327589147-2193-1-git-send-email-standby24x7@gmail.com>
References: <1327589147-2193-1-git-send-email-standby24x7@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/u6yH3_UzCphrJIJBQOnw/D6"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/u6yH3_UzCphrJIJBQOnw/D6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Jan 2012 23:45:47 +0900
Masanari Iida <standby24x7@gmail.com> wrote:

> Correct spelling "resouce" to "resource" in
> dricers/pci/setup-res.c
>=20
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/pci/setup-res.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> index b66bfdb..5c18194 100644
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -228,7 +228,7 @@ int pci_reassign_resource(struct pci_dev *dev, int re=
sno, resource_size_t addsiz
>  	int ret;
> =20
>  	if (!res->parent) {
> -		dev_info(&dev->dev, "BAR %d: can't reassign an unassigned resouce %pR "
> +		dev_info(&dev->dev, "BAR %d: can't reassign an unassigned resource %pR=
 "
>  			 "\n", resno, res);
>  		return -EINVAL;
>  	}

Applied to -next, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/u6yH3_UzCphrJIJBQOnw/D6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIuDcAAoJEIEoDkX4Qk9hMN0QAM7Q6ODzFdGWEciQuII/fAl+
rGoOm+lZb01Gq6BvbgqMM5UqcFgjJUJjXwzX4EFgLSrU0BGi4YA8obcKnvHBE/qC
DZ8TCdO964LRpFvug4A4qXgWJ7gxrCcnjYmVRrKZlqjIVFskOZbMG6RDPXCkjeIY
NNVckQWnKXMlGIeja6OYomEEuPvUspoMT+mHkgxGf9PnKU4EeO7IQY2JfIJRIvhd
kw/TboE+yDB65tE97eGsJHStQO6EIeRed+dFvHqjGKCNZMhYt63sSJ0c+rEeB3UX
Ho0L9JIZI6bufudkL0XQwcvRtMSKaKPmTixYriyhRIWVtuFODzFlFsw2w1hXAuHX
6Tp7sqiufeRSWNx5d2y458qPtD7FhCGy1UALiBUhc8WWPza1oyDML2IfZ5SGVbhO
PZciw/vTCZwjViblybBb8qLTNwd+eq7p4CEURXWOuTStIfrMQEtEsiTYSfBmriMk
hdcata23myyEuclSfCFYZELHZbAECq3ObSbn/BDMzODSeMKTioX0PzEN3gW2z8AO
WopOxMWdNetTtz0XNHZzgTE066Uq7bxeqgvFh31/vss5kNRcJWJhbePiGqBi9Kun
sqMCWS/vMHbwEsfrnEOE5zOv0F7XiRnJEEuxGj0no7pBGw0GWO7Ratcuz6xuXF5i
3WH8zpV6ivecRNzCYerQ
=//Hy
-----END PGP SIGNATURE-----

--Sig_/u6yH3_UzCphrJIJBQOnw/D6--
