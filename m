Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab2EREgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 00:36:38 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39738 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab2EREgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 00:36:36 -0400
Message-ID: <4FB5D1C8.7020305@gmail.com>
Date: Fri, 18 May 2012 06:36:24 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Add Apple NLS
References: <4FAFBE24.7000307@gmail.com> <20120517154707.c3dc2795.akpm@linux-foundation.org>
In-Reply-To: <20120517154707.c3dc2795.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig34E89E0B16D09D629B833091"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig34E89E0B16D09D629B833091
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

> Thanks, this looks useful.

>=20

You're welcome. Thank you for putting it in your tree.


>=20
> Also, I note that the unicode files have
>=20
> 	MODULE_LICENSE("Dual BSD/GPL");
>=20
> Where did this come from?  Is this a thing you decided upon or is it
> unicode.org's license requirement?
>=20

In this case I've taken the precedental approach rather than looking thro=
ugh
licensing files. Other NLS files have a notice that they are based on uni=
code.org
table, so I've supposed that the license requirements were already checke=
d for them
and the code was reviewed and tested for a long time, so I've picked anot=
her nls_*.c
file and only replaced the actual tables using a simple python script. So=
 actually I
don't hold any copyright on this one. All copyright goes to original nls_=
*.c and to
Unicode consortium.

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig34E89E0B16D09D629B833091
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+10cgACgkQNak7dOguQgmYCwD/c4YXYA63zzV1YhhmkajDLlUi
gYd7PqZetqpQa5TID/gA/RhOWVRB5/2YXxlI/pNTWujFJ7N4OZ7jgRpa7C08wzrC
=sX/i
-----END PGP SIGNATURE-----

--------------enig34E89E0B16D09D629B833091--
