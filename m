Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab2HSTVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 15:21:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54612 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2HSTVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 15:21:23 -0400
Message-ID: <1345404079.1930.7.camel@kyv>
Subject: Re: [PATCH 1/8] arm: sam9_l9260_defconfig: adjust UBI bad
 eraseblocks limit
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Sun, 19 Aug 2012 22:21:19 +0300
In-Reply-To: <1345214124-5478-2-git-send-email-richard.genoud@gmail.com>
References: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
	 <1345214124-5478-2-git-send-email-richard.genoud@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-VL0NCch6ImXOAysAHznM"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VL0NCch6ImXOAysAHznM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-17 at 16:35 +0200, Richard Genoud wrote:
> diff --git a/arch/arm/configs/sam9_l9260_defconfig b/arch/arm/configs/sam=
9_l9260_defconfig
> index da276f9..d11fea5 100644
> --- a/arch/arm/configs/sam9_l9260_defconfig
> +++ b/arch/arm/configs/sam9_l9260_defconfig
> @@ -39,7 +39,7 @@ CONFIG_MTD_NAND=3Dy
>  CONFIG_MTD_NAND_ATMEL=3Dy
>  CONFIG_MTD_NAND_PLATFORM=3Dy
>  CONFIG_MTD_UBI=3Dy
> -CONFIG_MTD_UBI_BEB_LIMIT=3D3
> +CONFIG_MTD_UBI_BEB_LIMIT=3D30

I'll just remove this from from the defconfig and make it use the
default, which is more sensible for this device, as your research
showed.

--=20
Best Regards,
Artem Bityutskiy

--=-VL0NCch6ImXOAysAHznM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQMTyvAAoJECmIfjd9wqK0BEkQANGc6+lvSGLa31wTC1KVAxlM
sjHi1FbLS8Lq9CV3yem191phT4OwlsxguW02xSzClcaxa8wkwg+4qgxQ6vGOCiBR
AJqFJMN8v5HAhdinZYV6HdLO8LwPR/bS18NiFE2pLxgtQ7rG4IIF9h+TxpNStaHw
veNy/K8gMfL5xSqGzbio5C0d5c8xiuS4au/vEpNU/mqm+Mns34tfRS968t+NDXB3
08Q25CT/DQgR44G/6IULqHe5vFc+q28KgRTN6JMcO7xBLH6f7f/7o9wQQSRVHPEL
TUFQI/iQpFRsiNK+Fzk8CK9RL25yYx9t/6yMPvKMNFm96CJu+q4MY6hR3QbC1F5W
IJnwLiiuTyoEbOE0c2EI9T+CgjM10MuZ8lCXz/pZ7MkeNAZ/VOePuRFaH0QC77S9
vFkLL8d7IxNPafhRPqL1feC2dPOnCIm6ESqF7rsiTcowzL/mnh/+zQQA5wiKM6Aj
yiqJfbGv8/V6YJl4db9YM5yc08AQES1x9j151mmRSUxQ1x54+5rwBW67A5OvoxL1
R5ycah6zo78NziaLzxAoX4nAUyUsJumBq/m3Q2/EgHCr9E7Yw14a4Fd1Gn+C11J1
bv351AagOsV6NymvoKNkqNp05F8tWi5ASbeT4/dTWDWGj5zrQ+8A7BRq2U9JDpU7
wSyismwQDG+Lvr3n+e89
=z3X5
-----END PGP SIGNATURE-----

--=-VL0NCch6ImXOAysAHznM--

