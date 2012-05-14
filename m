Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab2ENWeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:34:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64606 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab2ENWeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:34:08 -0400
Message-ID: <4FB18850.8090704@gmail.com>
Date: Tue, 15 May 2012 00:33:52 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix minixfs size check
References: <4FAFBBC7.9020101@gmail.com> <20120514221948.GV5353@quack.suse.cz>
In-Reply-To: <20120514221948.GV5353@quack.suse.cz>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig6090094148AF6DB53ADA9E9D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6090094148AF6DB53ADA9E9D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 15.05.2012 00:19, Jan Kara wrote:

> On Sun 13-05-12 15:48:55, Vladimir '=CF=86-coder/phcoder' Serbinenko wr=
ote:
>> minixfs file size check is buggy and it doesn't allow creating a block=
 which
>> can't be fully filled
>   Umm, I'm not really minix expert but who'd set s_max_size to somethin=
g
> which is not a multiple of block size? This looks rather artifical prob=
lem
> to me...
>=20

The usual and natural limit comes from interpreting 32-bit size field as
signed or unsigned. So it's either 2G - 1 or 4G - 1. Neither of which is
a multiple of block size.
--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig6090094148AF6DB53ADA9E9D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+xiFoACgkQNak7dOguQgng6gD/TsKeks/ncOwvFSrYPi3jtOdW
l+ogoa539pHPSHqHQloA/Arn4PM8X5H23cKy9RLAnppkvywLA9JbgcsPVhg3iBi6
=pQJG
-----END PGP SIGNATURE-----

--------------enig6090094148AF6DB53ADA9E9D--
