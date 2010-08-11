Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0HKHvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:51:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59259 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab0HKHvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:51:49 -0400
Date: Wed, 11 Aug 2010 17:51:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: divya <dipraksh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        sripathik@in.ibm.com
Subject: Re: kernel version 2.6.35-git10 build failure
Message-Id: <20100811175142.0af4d271.sfr@canb.auug.org.au>
In-Reply-To: <4C624F7F.3070608@linux.vnet.ibm.com>
References: <4C624F7F.3070608@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Aug_2010_17_51_42_+1000_S.AIO6DRbm6gKF.a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Aug_2010_17_51_42_+1000_S.AIO6DRbm6gKF.a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Divya,

On Wed, 11 Aug 2010 12:51:35 +0530 divya <dipraksh@linux.vnet.ibm.com> wrot=
e:
>
> Today kernel(version 2.6.35-git10 -commitid 3d30701b58970) build fails wi=
th following error on both system x and p
>=20
>    fs/9p/vfs_inode.c: In function 'v9fs_vfs_setattr_dotl':
>    fs/9p/vfs_inode.c:1267: error: implicit declaration of function 'inode=
_setattr'

This is known about and a fix is pending.  Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_Aug_2010_17_51_42_+1000_S.AIO6DRbm6gKF.a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMYlaOAAoJEDMEi1NhKgbs/xoH/RYnIu1WnZBUrmVNMKeTk6VA
gwRrx8eIGrlOBNa4Bd2/YZyBV5WKx3zvp5iH9a+/I+llFUlmmvQAxW0I0A7k2n5e
3tCiSvpBWICjHCm0pbnXWBZL/o6otL7SPI/7UwHrSpa6G9qR7LxZJ0Pmg7LGHlwD
tJy6IthuBMD3NkG0v6+zFM4669a3pUvqo0ehfLUv/mDQZYFh8z7uqTCA1QcTnTAk
lc6oMZQKI9G9T9Kk11cZJNS+1DlGfWPryKFMg9D6RtVcMqB1X5lh0pKPpBrrOvrC
pw2pLnVDGkxSM5BRo179MpNZydyGw1ZGL5nMWquOPpy2jtCIyxIPOyALp+5lKAA=
=iJGy
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Aug_2010_17_51_42_+1000_S.AIO6DRbm6gKF.a--
