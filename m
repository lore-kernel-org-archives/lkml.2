Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966470Ab2EOW4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 18:56:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62984 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965990Ab2EOW4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 18:56:01 -0400
Message-ID: <4FB2DEF4.7030701@gmail.com>
Date: Wed, 16 May 2012 00:55:48 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, jfs-discussion@lists.sourceforge.net,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
CC: Steve French <sfrench@samba.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Dave Kleikamp <shaggy@kernel.org>,
        Petr Vandrovec <petr@vandrovec.name>,
        Anton Altaparmakov <anton@tuxera.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 0/8] Support non-BMP characters on UTF-16 filesystems
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigEFAD0476C980FF20EDC98AF3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEFAD0476C980FF20EDC98AF3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello, when conducting some automated filesystem tests, I've discovered
that some filesystems are unable to cope with non-BMP characters. While
most usual characters are in BMP, I still think that supporting then is
important. Perhaps, the single most important reason to support them is
that they come up in some personal names. The series has 2 patches to
prepare the ground by changing NLS functions uni2char and char2uni to
work on full unicode_t and another patch for UTF-16 conversion functions.=

Remaining 6 patches are for specific filesystems.The filesystems I haven'=
t
fixed are ncpfs and cifs since I don't have the relevant test environment=

but it should be easy for someone with one to extend it for them as well.=

I've used mainly 2 following characters for test:
=F0=AF=A6=99 Some rare CJK symbol, no idea what it means, picked it up at=
 random.
=F0=9F=98=81 An emoticon.

I send this explanation and first 2 patches to all concerned parties. Res=
t
is sent to LKML, linux-fsdevel and relevant filesystem maintaintainer/lis=
t only
--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enigEFAD0476C980FF20EDC98AF3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+y3vUACgkQNak7dOguQgkzTAD/VPVRlFLsYJ71/tJxUpEzREtd
+mrxUsU81NRp4WdoVy0A/38nbsTU5m3sGosxnC8vwyEEAx2jmG/wCEiiKB4z1zQU
=h+9z
-----END PGP SIGNATURE-----

--------------enigEFAD0476C980FF20EDC98AF3--
