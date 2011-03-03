Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab1CCBhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:37:38 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57233 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab1CCBhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:37:36 -0500
Date: Thu, 3 Mar 2011 12:37:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20110303123729.f416608a.sfr@canb.auug.org.au>
In-Reply-To: <20110228120501.eb6840e0.sfr@canb.auug.org.au>
References: <20110228120501.eb6840e0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Mar_2011_12_37_29_+1100_g4Jm/aLZJgxd9u_m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Mar_2011_12_37_29_+1100_g4Jm/aLZJgxd9u_m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Mon, 28 Feb 2011 12:05:01 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the v4l-dvb tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> drivers/video/matrox/matroxfb_base.c: In function 'matroxfb_ioctl':
> drivers/video/matrox/matroxfb_base.c:1155: error: 'VIDIOC_S_CTRL_OLD' und=
eclared (first use in this function)
>=20
> Caused by commit 0ff69fe7cebb65856eba7feb3fd76fb4ba365bf8 ("[media] v4l:
> removal of old, obsolete ioctls"). grep is your friend ...
>=20
> I have used the v4l-dvb tree from next-20110225 for today.

I am still getting this ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Mar_2011_12_37_29_+1100_g4Jm/aLZJgxd9u_m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNbvDZAAoJEDMEi1NhKgbsCm0IAI3xUxWy8i9cjSr24perEf36
mumNInj+Jc9uhax3A+yzuF7r6/kVVXyZF5lw/b5wCz18mDej8B59PEFFIGkjKTGc
+lzKit7QRfDfzzujf7QHdKhMjbdew8egcRLuCjHbjd4iZ6W8NPH8YFlvZka5C5VH
OWlMkHQ/AL3S1S3W93UUHwLQoWTocj+nPRPBfnALrCinLdoGaAyQEmBTB4YEObrs
yp4z/2zUnMVrEF+A7mfVGJiQabxDc8UfmAR0tic5Pv0TzEOcnPZAgc45IZJCwlOU
LSlBSaSrQpdFHxZ289w3+SeHL4sRr4XmTa0lGAWW/3YmmvNKBKK8Qo8UTifE/aQ=
=xxPo
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Mar_2011_12_37_29_+1100_g4Jm/aLZJgxd9u_m--
