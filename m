Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1LAO7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:59:49 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:35499 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab1LAO7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:59:48 -0500
Date: Thu, 1 Dec 2011 18:00:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Re: [PATCH 1/4] staging: vt6656: channel.c: Remove dead code
Message-ID: <20111201150003.GI20466@mwanda>
References: <1322698969-19285-1-git-send-email-marcos.mage@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u/L2/WlOHZg+YGU4"
Content-Disposition: inline
In-Reply-To: <1322698969-19285-1-git-send-email-marcos.mage@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4ED79657.006D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u/L2/WlOHZg+YGU4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 01, 2011 at 12:22:49AM +0000, Marcos Paulo de Souza wrote:
> This patch remove some unneeded code. Some comments, for loop doing
> nothing, debug messages and unneeded variables was removed.
>=20

This rewrites some stuff, it's not just deleting stuff...  Yes,
you've rewritten it in a better way, but you should mention that in
the changelog.  Maybe break it up into smaller patches or something?

> @@ -463,51 +444,23 @@ void CHvInitChannelTable(void *pDeviceHandler)
> =20
>      if ((pDevice->dwDiagRefCount !=3D 0) ||
>          (pDevice->b11hEable =3D=3D TRUE)) {
> -        if (bMultiBand =3D=3D TRUE) {
> -		for (ii =3D 0; ii < CB_MAX_CHANNEL; ii++) {
> +	if (bMultiBand =3D=3D TRUE)
                                ^
Don't delete the '{' from here.  Multi-line indents get {} braces
even though it's not needed for semantic reasons.

I told you that yesterday.  :/

> +		for (ii =3D 0; ii < CB_MAX_CHANNEL; ii++)
>  			sChannelTbl[ii+1].bValid =3D TRUE;

regards,
dan carpenter


--u/L2/WlOHZg+YGU4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO15ZyAAoJEOnZkXI/YHqRrIQP/3MdbdQAi1enPFo17iaI1/mR
rEM22e8lxPkPOL8suEzogp91sV1j+LHJFv+9nfW3sApSrHbI7M0Fc/DroiE2E9R9
NMLui3EpvbUb7HUBJoy8cfIk4wtFBF3YnxSIdi3xMK9vTwceMjmR+JbCwsoJIGSk
vr7q7aFMm7zjO5OVsTJvSGRsRoqGn3ucTWdY2aMirFpEdjsNnvUIR+qyG813pKfm
bS4SmmZDb2zO76N2WsB7Je/kTLrxnqN0AWZpAI8+QJI6O6/YbOJlOTa9Xh8vgwOz
kttZlSSA1xcvn6aQEbVxpmVeFf2GuIRrRim4e87J4koSDCKl6Bhx1iUcNR54DifH
M7b3A90jqoanoLJWH+CMQSdiWbBMEpoDzUe2hUyTTvMQErbGhfiypGFXG8bBZ2zU
vckaO5fmTqKHnBVqFPtRBLZNyzPvzd4Uc6hLFvDqwXmSGvGr9U4BmzVZWC8qInK/
D5URAoYjzIgE5Pr3ZyeC92xLt2E5PFkErzJpkijUrDLFpYfoDTSrtNq8sslMFJ7/
FQFTwrK83115Bp+A+CZbEIEDaEjYsNvpeJqbXzvJ5oBbGR5PJgoEtphehGciAh/4
sNMHOy0BwE/1g37/VGk3qxyXfuhbWxek+kWDQrVwuUrVRoIbV8nGbqqqcPkrM5y0
LbNdPDUgF3/Nh82Nbn+8
=WVax
-----END PGP SIGNATURE-----

--u/L2/WlOHZg+YGU4--
