Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab0CQFAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 01:00:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41637 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab0CQFAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 01:00:06 -0400
Date: Wed, 17 Mar 2010 15:59:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rupjyoti Sarmah" <rsarmah@amcc.com>
Cc: <linux-ide@vger.kernel.org>, "Jeff Garzik" <jgarzik@pobox.com>,
       Rupjyoti Sarmah <rupjyoti.sarmah@gmail.com>, linuxppc-dev@ozlabs.org,
       Rupjyoti Sarmah <rupjyoti.sarmah@appliedmicro.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 460EX on-chip SATA driver<kernel 2.6.33> < resubmission
 : 01>
Message-Id: <20100317155959.208eea21.sfr@canb.auug.org.au>
In-Reply-To: <AC311A8E81420D4EBC1F26E6479848FE065B7F30@SDCEXCHANGE01.ad.amcc.com>
References: <1268646854-27387-1-git-send-email-rsarmah@appliedmicro.com>
	<AC311A8E81420D4EBC1F26E6479848FE065B7F30@SDCEXCHANGE01.ad.amcc.com>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Mar_2010_15_59_59_+1100_x6xtbWF6Ja6n4J16"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Mar_2010_15_59_59_+1100_x6xtbWF6Ja6n4J16
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Just a couple of quick points ...

On Tue, 16 Mar 2010 21:23:16 -0700 "Rupjyoti Sarmah" <rsarmah@amcc.com> wro=
te:
>
> This patch enables the on-chip DWC SATA controller of the AppliedMicro
> processor 460EX.
>=20
> Signed-off-by: Rupjyoti Sarmah <rsarmah@appliedmicro.com> ,Mark Miesfeld
> <mmiesfeld@appliedmicro.com>,
> Prodyut Hazarika <phazarika@appliedmicro.com>

Please put one Signed-off-by line per person.

> ---
>  arch/powerpc/boot/dts/canyonlands.dts |    8 +
>  drivers/ata/Kconfig                   |    9 +
>  drivers/ata/Makefile                  |    1 +
>  drivers/ata/sata_dwc.c                | 1965
> +++++++++++++++++++++++++++++++++
>  4 files changed, 1983 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/ata/sata_dwc.c

This patch has been word wrapped by your mailer (or something along the
way).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Mar_2010_15_59_59_+1100_x6xtbWF6Ja6n4J16
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkugYc8ACgkQjjKRsyhoI8zZJQCfZJSGnsbt4kh9bMNqgMk2m+wB
IwAAn0mM+SEn8+ALw6LQIjSK8BbR2KMr
=hvS3
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Mar_2010_15_59_59_+1100_x6xtbWF6Ja6n4J16--
