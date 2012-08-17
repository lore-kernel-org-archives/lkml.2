Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab2HQJdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:33:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:2106 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab2HQJdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:33:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,783,1336374000"; 
   d="asc'?scan'208";a="187660183"
Message-ID: <1345196262.27859.30.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] ubiattach: introduce max_beb_per1024 in UBI_IOCATT
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 17 Aug 2012 12:37:42 +0300
In-Reply-To: <1341937423-16516-6-git-send-email-richard.genoud@gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	 <1341937423-16516-6-git-send-email-richard.genoud@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-rM2FBBLafw8dMzWtlKAM"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rM2FBBLafw8dMzWtlKAM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-10 at 18:23 +0200, Richard Genoud wrote:
> The ioctl UBI_IOCATT has been extended with max_beb_per1024 parameter.
>=20
> This parameter is used for adjusting the "maximum expected number of
> bad blocks per 1024 blocks" for each mtd device.
> The number of physical erase blocks (PEB) that UBI will reserve for bad
> block handling is now:
> whole_flash_chipset__PEB_number * max_beb_per1024 / 1024

Could you please split this on 2 patches:

1. Update teh ubi-user.h file by syncing with the kernel. Do make
headers_install and just copy it to mtd-utils.
2. Do the change.

--=20
Best Regards,
Artem Bityutskiy

--=-rM2FBBLafw8dMzWtlKAM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLhDmAAoJECmIfjd9wqK0KDIQAIJUBol8qlDGyZ1gva4a4FDe
HpSLgc0ZgXwEQkqCvdvoRPRMZVmtUYE1VYXGcPCOPI8bZOMB3yvC5f0nou4QHde7
7VF0NZjlnfPLuFALNrzoI+KuUHqmjoVjbcO97NucxhkI5SP6l/WILThDFa0q+4F/
xtNlIX4CfxyiGP9S46U8aM/5hR1YAsC1mLEFB+HTG6JqyKNHrLHc/GkoxaYMXGWC
+DMiaCA21Zxn8PtgmCgaxqDCc8FqByByf+DaqUvR8VlW3YTgPwRu3DN3qPIY6SFr
yW/5nfCRMtkGfLoxUWm6e2GcpYxq1u8iKXke88EEWTE/Ccsp16DO1m4pqk195pf5
AIVuUTGcFZGtxXUCMtfyPQLRDDzh8MwCql21jEPv17KuQk7c39P/rC3m6oQFX+SV
4LsALsfQBLQ26Cd/KIiHK5mFuZisxdvq3i1dqd2oAQatEFTI8A2oHHjdJQHdmwKF
Dk8uaF++iHgNGlq66gfE+w4+rhtE/1hewjtR+32QbPw6KScGxZicyCoQsVhBLRg1
wW9OMadKLccIL8DWiBC1iZ/7Lir+fDSeUVKg3FU2EQBcU1PMFxhH1eNOVz41pAJL
RmbsxIRwsRnFuKahaUz4xri0WoWWPYqxWRDhhMWBj3r12A+QCiZUJzKg4getfsLi
LJx27zf3G5bcg+2csnLo
=Mu0O
-----END PGP SIGNATURE-----

--=-rM2FBBLafw8dMzWtlKAM--

