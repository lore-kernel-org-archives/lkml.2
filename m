Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2LNEzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 23:55:31 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52827 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab2LNEz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 23:55:29 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b7-50cab140d2b9
Message-id: <1355460921.16178.21.camel@kjgkr>
Subject: Re: [PATCH v2] f2fs: fix up f2fs_get_parent issue to retrieve correct
 parent inode number
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Fri, 14 Dec 2012 13:55:21 +0900
In-reply-to: <1355409851-6389-1-git-send-email-linkinjeon@gmail.com>
References: <1355409851-6389-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-MRrfI8yc+qzD8WurtLEr"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zka7DxlMBBhs3s1ns2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGU8apjLXLBSsWLq7jmsDYxvpLsYOTgkBEwkzs507mLk
	BDLFJC7cW8/WxcjFISSwjFHi2LaN7BAJE4ltm/4yQSSmM0oc+nYLynnNKDHhyVkmkCpeAV2J
	JwcWMILYwgIpEk1tPxhBNrAJaEts3m8AEhYSUJR4u/8uK0hYREBNYsKzVJAxzAK7gJYdXcIC
	UsMioCrR1/4MbCSngIvEhz9NbBC9zhI31lwBi/MLiEqcbP0EtopZoEpi6q3NUIcqSexu72SH
	OEdQ4sfke1AzBSS+TT7EAvGwrMSmA8wQ5ffYJR5sEoewJSUOrrjBMoFRfBaSqbOQTIKIa0q0
	bv/NDmFrSyxb+JoZwraVWLfuPVSNjcSmqwsYIWx5ie1v5zAvYGRfxSiaWpBcUJyUnmuoV5yY
	W1yal66XnJ+7iRESkVI7GFc2WBxiFOBgVOLh/Sh0KkCINbGsuDL3EKMK0JxHG1ZfYJRiycvP
	S1US4bVrAkrzpiRWVqUW5ccXleakFh9iTAZ6dCKzlGhyPjCJ5JXEGxobm5iZmJqYW5qam5Im
	rCTO2+yREiAkkJ5YkpqdmlqQWgSzhYmDU6qBUT60rjH/zTKJuxoPDCvVVxec77skfojz2OKp
	OfdV+6MNe/LMEnwM+eSZW2c2b01fe1lBur76jd3m2FUqegu3v+vNNnG62SrGcKJ3r53stf3F
	udp3r3eqL5pbJHXH40vTd8nYK3K7W2f9U76y+uONTvYvVmUdd470rbron2F+VY9v2Qz2axvX
	KLEUZyQaajEXFScCAJlnEoUYAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jQV37jacCDA6+srbYs/cki8XlXXPY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMeNQwl7lgpWLF
	1N1zWBsY30h3MXJySAiYSGzb9JcJwhaTuHBvPVsXIxeHkMB0RolD324xQTivGSUmPDkLVsUr
	oCvx5MACRhBbWCBFoqntB5DNwcEmoC2xeb8BSFhIQFHi7f67rCBhEQE1iQnPUkHGMAvsYpQ4
	dnQJC0gNi4CqRF/7M7CRnAIuEh/+NLFB9DpL3FhzBSzOLyAqcbL1E9gqZoEqiam3NrNDHKok
	sbu9kx3iHEGJH5PvsUxgFJyFpGwWkhREXFOidftvdghbW2LZwtfMELatxLp176FqbCQ2XV3A
	CGHLS2x/O4d5ASP7KkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgmH8mtYNxZYPFIUYBDkYl
	Ht6PQqcChFgTy4orcw8xqgDNebRh9QVGKZa8/LxUJRFeuyagNG9KYmVValF+fFFpTmrxIcZk
	YGhMZJYSTc4Hpqm8knhDYxMzI0sjMwsjE3Nz0oSVxHmbPVIChATSE0tSs1NTC1KLYLYwcXBK
	NTB2eHT5zTr4bIGlpeQh1isrdYweThJUj8q6s4SRzW+m+9Iv7fnifM8a4y3KN/3081t/j7k6
	+sKWEx+sbp1TnLqjZJuR4DzBpuIu15UOB+/fkby7Usok4ZHjtMBzK7ieZJzzNHro82PLDNYv
	U55OdLE27/vpbVFkUhyxldPz4vo/V+9+zZMpvZKjxFKckWioxVxUnAgAiv9Va0kDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MRrfI8yc+qzD8WurtLEr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

> diff --git a/fs/f2fs/hash.c b/fs/f2fs/hash.c
> index a60f042..5e48bac 100644
> --- a/fs/f2fs/hash.c
> +++ b/fs/f2fs/hash.c
> @@ -76,6 +76,10 @@ f2fs_hash_t f2fs_dentry_hash(const char *name, int len=
)
>  	const char *p;
>  	__u32 in[8], buf[4];
> =20
> +	if ((len <=3D 2) && (name[0] =3D=3D '.') &&
> +		(name[1] =3D=3D '.' || name[1] =3D=3D '\0'))
> +		return 0;

If len =3D=3D 1, we should avoid referencing name[1].
Likewise VFS does, I rewrote that like below.

	if (name[0] =3D=3D '.') {
		switch (len) {
		case 1:
			return 0;
		case 2:
			if (name[1] =3D=3D '.')
				return 0;
		}
	}

So, how about this patch?

=46rom 391d584afadfb177584a3a3e4a7ec97e1a674457 Mon Sep 17 00:00:00 2001
From: Namjae Jeon <namjae.jeon@samsung.com>
Date: Thu, 13 Dec 2012 23:44:11 +0900
Subject: [PATCH] f2fs: fix up f2fs_get_parent issue to retrieve correct
parent
 inode number

Test Case:
[NFS Client]
ls -lR .

[NFS Server]
while [ 1 ]
do
echo 3 > /proc/sys/vm/drop_caches
done

Error on NFS Client: "No such file or directory"

When cache is dropped at the server, it results in lookup failure at the
NFS client due to non-connection with the parent. The default path is it
initiates a lookup by calculating the hash value for the name, even
though
the hash values stored on the disk for "." and ".." is maintained as
zero,
which results in failure from find_in_block due to not matching HASH
values.
Fix up, by using the correct hashing values for these entries.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c  |  4 ++--
 fs/f2fs/hash.c | 10 ++++++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index b4e24f3..e1f66df 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -540,13 +540,13 @@ int f2fs_make_empty(struct inode *inode, struct
inode *parent)
=20
 	de =3D &dentry_blk->dentry[0];
 	de->name_len =3D cpu_to_le16(1);
-	de->hash_code =3D 0;
+	de->hash_code =3D f2fs_dentry_hash(".", 1);
 	de->ino =3D cpu_to_le32(inode->i_ino);
 	memcpy(dentry_blk->filename[0], ".", 1);
 	set_de_type(de, inode);
=20
 	de =3D &dentry_blk->dentry[1];
-	de->hash_code =3D 0;
+	de->hash_code =3D f2fs_dentry_hash("..", 2);
 	de->name_len =3D cpu_to_le16(2);
 	de->ino =3D cpu_to_le32(parent->i_ino);
 	memcpy(dentry_blk->filename[1], "..", 2);
diff --git a/fs/f2fs/hash.c b/fs/f2fs/hash.c
index a60f042..9d7a7c6 100644
--- a/fs/f2fs/hash.c
+++ b/fs/f2fs/hash.c
@@ -76,6 +76,16 @@ f2fs_hash_t f2fs_dentry_hash(const char *name, int
len)
 	const char *p;
 	__u32 in[8], buf[4];
=20
+	if (name[0] =3D=3D '.') {
+		switch (len) {
+		case 1:
+			return 0;
+		case 2:
+			if (name[1] =3D=3D '.')
+				return 0;
+		}
+	}
+
 	/* Initialize the default seed for the hash checksum functions */
 	buf[0] =3D 0x67452301;
 	buf[1] =3D 0xefcdab89;
--=20
1.8.0.1.250.gb7973fb

--=20
Jaegeuk Kim
Samsung

--=-MRrfI8yc+qzD8WurtLEr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQyrE5AAoJEEAUqH6CSFDSD1AP/2glo+T9RdWpgbhyQcP3Nc/F
/oWN4SRtNFvHgOmRgyVvGTeMVtEIL5HZk1Hc+0NWvfIBHkGQPSvpt3mHeYbFaS28
vV/0xihI5IgV8KR2S/mIZVy55GaqZ89qkATvkxSkscn+0o7LeSd2uS88H0LG5D7a
Yt4H5su0TUz5uVbL+SiE5Lb/XvSFn9DB5AQn3/ObbNihEHuHeJJ8CoPO4Bz9YMuk
MwdWQqSBEvRRLzz1b0rGSrMzBVlhYidNsrUJwoCgdM6SYEK0BS6SNLOMDoMUJ7j5
TnJMppHgE3lhYcrmJt914iXiU+ynjc9VEKVtnhnzVDVccE082B4h6WmYbqDWEylc
wkBr1q7+vNVXIRPdlPaupfp/kAmEnfxWwQj359X3KMgmCtsw7xQbtUFSBwrCt4GS
6c+0CydgEuRE3hqT23+8rpM5XTSgc7SAEzznTQuKo8mOM12cHHV9gWngnvOjcvfU
fK+QkMV3d1VBrGOOd0Ok0bBng/Fq6B38/AHfo6MiKHrcJoTM+TaZD3gVrgg/IKto
D6M6i7f6M6ahCz6cPU8PYSdgKFbzZERMNApYVzogcfxTn44B9gV0izmtlOnB+k/R
MUBaJh3shF3PTNDBQ8orZrGK6YTppp28cxUqioCLzdu0Z8GXOQLfYNdPfTULJ9vI
61btVtKqtpBKsOAN1v9p
=q8lX
-----END PGP SIGNATURE-----

--=-MRrfI8yc+qzD8WurtLEr--

