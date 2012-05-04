Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2EDKJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 06:09:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:8281 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab2EDKJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 06:09:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="140041063"
Message-ID: <1336126390.4275.12.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2 4/4] fat: switch to fsinfo_inode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Date: Fri, 04 May 2012 13:13:10 +0300
In-Reply-To: <87y5pyfoe0.fsf@devron.myhome.or.jp>
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
	 <1334326795-2446-5-git-send-email-dedekind1@gmail.com>
	 <87fwc6hazv.fsf@devron.myhome.or.jp> <1334399379.2263.8.camel@koala>
	 <87bomuha77.fsf@devron.myhome.or.jp> <1334401307.2263.24.camel@koala>
	 <873986h6qa.fsf@devron.myhome.or.jp> <1334406974.2263.38.camel@koala>
	 <87y5pyfoe0.fsf@devron.myhome.or.jp>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-sTIFxmwXqJ7wE+CwARi9"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sTIFxmwXqJ7wE+CwARi9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I was having a leave, but now came back to this stuff.

On Sat, 2012-04-14 at 22:12 +0900, OGAWA Hirofumi wrote:
> If fsinfo is inode, the order can be
>=20
> 1) flush inodes
>     1a) flush fsinfo inode
>     1b) flush normal inodes
> 2) last iput(normal inodes)
>       truncate()
>            dirty fsinfo inode

3) a bit later fsinfo inode is flushed again.

Sorry, I do not still see where is the issue.

Also, how is it different form the current situation where
you have absolutely the same.

I really still do not see the issue.=20

--=20
Best Regards,
Artem Bityutskiy

--=-sTIFxmwXqJ7wE+CwARi9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPo6u2AAoJECmIfjd9wqK0feEQAJp4bxhOb0gV2swzpSE8lndC
qip7NIMoklsUKdQsBJe3FKF2D81XHNaTpoPNpmWyG6IaeoiXePeYvE1EwierWmv4
NDbH4VCsAorvz9HtHOrhTs8mgdOp3oqa4AT4FQMcLuGODSgrWX+mtMhUtON53vIP
rK5fGG2IdcWVr0iaXxUbdfl6SNOM6bocipXLA3HsDMBgMfK9V/2xkyOB05qNNxce
q/jvWGv5m0z+xSftyBDaDlVOH5GRf8MeusFtAdoq182l05YEXSbbWszhfs34wQkz
BERyeVVTfXoAoZ8JUi2uvN1fGyfVtwBiLeWQW94LYFerBjSdHnPxBsHFb8kGAKeJ
WcGrJqx57XslSYtta4Pubm8nDPMxT9eNyph646NIxNYbh1CS88xYIwgFKZjmrcki
6EA7560vtlVP5ItmZkgWB27OuK6piyy4Iy3vddIGRvgT7zKsmTYq2GWud+TRM2zn
bS34NVOGGreOzpokUO22Be8guC1VGZJ74MwmCI9DMJGqvxmZP6j7QvrLHQPre8IW
gn/GyLZvP8z6GkFB8B/bajd3lS3pI248/bOYmjBbT4q47PCMfr+5jkE+IiOBrXOS
EMQPzS8z+jzk9iG3hS7ziw++TjCiPsndjRC6nm8rZ8GAuC4me0AMG9+LCiF4EwuJ
EyNRtcneIDH9afT25OzH
=seXG
-----END PGP SIGNATURE-----

--=-sTIFxmwXqJ7wE+CwARi9--

