Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2HSTc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 15:32:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61527 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab2HSTcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 15:32:23 -0400
Message-ID: <1345404739.1930.11.camel@kyv>
Subject: Re: [PATCH 3/8] UBI: introduce MTD_PARAM_MAX_COUNT
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Date: Sun, 19 Aug 2012 22:32:19 +0300
In-Reply-To: <1345214124-5478-4-git-send-email-richard.genoud@gmail.com>
References: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
	 <1345214124-5478-4-git-send-email-richard.genoud@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-OPBDJgJ4dqd1gvIpuX9g"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OPBDJgJ4dqd1gvIpuX9g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-17 at 16:35 +0200, Richard Genoud wrote:
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>  drivers/mtd/ubi/build.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
> index 82d11e1..1f45f51 100644
> --- a/drivers/mtd/ubi/build.c
> +++ b/drivers/mtd/ubi/build.c
> @@ -46,6 +46,9 @@
>  /* Maximum length of the 'mtd=3D' parameter */
>  #define MTD_PARAM_LEN_MAX 64
> =20
> +/* Maximum number of comma-separated items in ht 'mtd=3D' parameter */
> +#define MTD_PARAM_MAX_COUNT 2

Fixed the spelling of "the" and pushed to linux-ubi.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-OPBDJgJ4dqd1gvIpuX9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQMT9DAAoJECmIfjd9wqK0hEMP/0B9uk59UZBerFIVJNQhJlbl
SUqzw7EV9i+IAS98fPKks3slJiZum6hJXWv/VM36uurBbYFGBI/DTztVLgpSdfxA
rVL8Dh+OlyHF0gjOrY4Y0itgABPsepSRNbVoBjjsgiIoS66ezneNfjMy8wNyG7C7
QZq00Va8K19bwNNiHz4Zgjws/26rqgui0RFgOVTQ0GLrODJ4u/DvqpS9KAVM/jat
EEb7Y46LlcizL92xloqws1M2ZpyhWamXWnUPV0l+DRabh2nTpM8nGguurgOBE9ob
pG/gYTLQ5rcObOOwChp/HkVIm3ZPYULYaOuJXyakq9Puj6LBc5Ob/Eum1aEkK7zx
RILrKX+93YUbBur66Yj1PdPZ00jtxOcTH3i6d2KfA5iIFqwCblCsQBqLQbKhoPu9
ajSbtPlrgScQl0YwUsZi76/BZ1gEpiJMdmEOpiQUyf5QqfLT9RpdouyWuwkNioyf
Qnxe/SdOfJB29f2qb1RBn2JrUOe6iZKYW1xs+vXVZbhaPaKyrLJi95gVkwAvwShd
5KZHy5yD7DU6LB9ZcyIVn53d3O/RklZ3aD5t/lXe+PnDRoYgsK+9UdULj8aUQtr8
OU+Cr2zsd+tJtUoMHiK1+L9IodutG4Dto3/tiSUxwKcCOr0kNLUCVhAWs/LgySH/
z1LWulcm8PGcnhFDPudL
=V0Iq
-----END PGP SIGNATURE-----

--=-OPBDJgJ4dqd1gvIpuX9g--

