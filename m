Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab2LLAeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:34:16 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36462 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab2LLAdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:33:53 -0500
X-AuditID: cbfee61b-b7f616d00000319b-cc-50c7d0eaa5cc
Message-id: <1355272421.24219.11.camel@kjgkr>
Subject: Re: [PATCH] f2fs: fix up f2fs_get_parent issue to retrieve correct
 parent inode number
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Wed, 12 Dec 2012 09:33:41 +0900
In-reply-to: <1355238625-6581-1-git-send-email-linkinjeon@gmail.com>
References: <1355238625-6581-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-i+SNgcpIbpjHOhCAbn88"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+Zge6rC8cDDFbeM7PYs/cki8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MpYMu0aS8EBxYp/8/UbGJfKdDFycEgImEhMOSPbxcgJ
	ZIpJXLi3nq2LkYtDSGAZo0T7zJPsMDV7PyhCxBcxSsw5vo4VwnnNKHF9/WNmkG5eAV2JtmMf
	2UFsYYFEiSszLrCCNLMJaEts3m8AEhYSUJR4u/8uWFhEQE1iwrNUkDHMArsYJY4dXcICUsMi
	oCqx9P0DsL2cAi4SL5qkIFqdJZYcOsMIYvMLiEqcbP0EZjMLVEl8mTiRGeJ+JYnd7Z3sENcI
	SvyYfA9qpIDEt8mHWCBekZXYdIAZZK2EwCN2iY6tb9kheiUlDq64wTKBUXwWkrGzkIyCiGtK
	tG7/zQ5ha0ssW/iaGcK2lVi37j1UjY3EpqsLGCFseYntb+cwL2BkX8UomlqQXFCclJ5rpFec
	mFtcmpeul5yfu4kREo3SOxhXNVgcYhTgYFTi4dXQOhYgxJpYVlyZe4hRBWjOow2rLzBKseTl
	56UqifCu3Ho8QIg3JbGyKrUoP76oNCe1+BBjMtCnE5mlRJPzgQkkryTe0NjYxMzE1MTc0tTc
	lDRhJXHeZo+UACGB9MSS1OzU1ILUIpgtTBycUg2MKs7fzjUf//x18+etNR+XLDqxft+veasa
	vdWuzDNvZTW5u/K2do3sjh2dfFs5i6O+Ru2rCYyXiFQIrFObZSNy6/Wr4/86fZTlZtxdsvFU
	5b7Qw1bvP4kc/dzWIPfbb9GKmFuM95kyU5k8r2ou6La8JPvUSISzTFZ4wdUtrDYVtVa2ul4i
	q4SElViKMxINtZiLihMBgPdu+BYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd1XF44HGCxfrm+xZ+9JFovLu+aw
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsWTaNZaCA4oV
	/+brNzAuleli5OCQEDCR2PtBsYuRE8gUk7hwbz1bFyMXh5DAIkaJOcfXsUI4rxklrq9/zAxS
	xSugK9F27CM7iC0skChxZcYFVpBBbALaEpv3G4CEhQQUJd7uvwsWFhFQk5jwLBVkDLPALkaJ
	Y0eXsIDUsAioSix9/4AdpIZTwEXiRZMURKuzxJJDZxhBbH4BUYmTrZ/AbGaBKokvEycyQ9yp
	JLG7vZMd4hpBiR+T77FMYBSchaRsFpIURFxTonX7b3YIW1ti2cLXzBC2rcS6de+hamwkNl1d
	wAhhy0tsfzuHeQEj+ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Gh/Jr2DcVWDxSFGAQ5G
	JR5eDa1jAUKsiWXFlbmHGFWA5jzasPoCoxRLXn5eqpII78qtxwOEeFMSK6tSi/Lji0pzUosP
	MSYDA2Mis5Rocj4wQeWVxBsam5gZWRqZWRiZmJuTJqwkztvskRIgJJCeWJKanZpakFoEs4WJ
	g1OqgdHaefHHXx/Wb9v+8XuRlVX66cWSBUvS5xxT1FmoXbsuVis0/UrBvYzCQ0Jtcinffoo/
	flmof/f2xFW3n1ZvdbTX6l/uMcnSRT9OpOwN+wU/x0mHViet1es8Zq3OFcPdkP+BZ+6LSS5i
	arv5r52tsd7CW5ho0XeAe3bzggNphxVjzXzVNL4bBCqxFGckGmoxFxUnAgBi+aOHRgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i+SNgcpIbpjHOhCAbn88
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2012-12-12 (=EC=88=98), 00:10 +0900, Namjae Jeon:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>=20
> Test Case:
> [NFS Client]
> ls -lR .
>=20
> [NFS Server]
> while [ 1 ]
> do
> echo 3 > /proc/sys/vm/drop_caches
> done
>=20
> Error on NFS Client: "No such file or directory"
>=20
> When cache is dropped at the server, it results in lookup failure at the
> NFS client due to non-connection with the parent. The default path is it
> initiates a lookup by calculating the hash value for the name, even thoug=
h
> the hash values stored on the disk for "." and ".." is maintained as zero=
,
> which results in failure from find_in_block due to not matching HASH valu=
es.
> Fix up, by using the correct hashing values for these entries and
> then initiating lookup request.
>=20
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/f2fs/dir.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index b4e24f3..6cf39db 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -184,7 +184,7 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode *=
dir,
>  	int namelen =3D child->len;
>  	unsigned long npages =3D dir_blocks(dir);
>  	struct f2fs_dir_entry *de =3D NULL;
> -	f2fs_hash_t name_hash;
> +	f2fs_hash_t name_hash =3D 0;
>  	unsigned int max_depth;
>  	unsigned int level;
> =20
> @@ -193,7 +193,8 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode *=
dir,
> =20
>  	*res_page =3D NULL;
> =20
> -	name_hash =3D f2fs_dentry_hash(name, namelen);
> +	if (strcmp(name, ".") && (strcmp(name, "..")))
> +		name_hash =3D f2fs_dentry_hash(name, namelen);

Got it.
For code consistency, could you rewrite the patch like below?
Thanks,

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
index a60f042..30ca4a2 100644
--- a/fs/f2fs/hash.c
+++ b/fs/f2fs/hash.c
@@ -76,6 +76,10 @@ f2fs_hash_t f2fs_dentry_hash(const char *name, int
len)
 	const char *p;
 	__u32 in[8], buf[4];
=20
+	/* dot and dotdot dentries should have zero-value hash code */
+	if (!memcmp(name, ".", 1) || !memcmp(name, "..", 2))
+		return 0;
+
 	/* Initialize the default seed for the hash checksum functions */
 	buf[0] =3D 0x67452301;
 	buf[1] =3D 0xefcdab89;
--=20
1.8.0.1.250.gb7973fb



--=20
Jaegeuk Kim
Samsung

--=-i+SNgcpIbpjHOhCAbn88
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQx9DlAAoJEEAUqH6CSFDScMAQAIXE/2ZybHf+ShqwN5WQ6+/b
oIOi+D48LEhpY6/mgGZ18rbgT6gVL1CgLW6IUZpx6K0sXnFeRgVnuuNG6x5NPCKV
wMdWmISut/L73aHxeGEdDU4XAb+rTU5cSL/usesNbi5ffSGobVDfhlnhdA3helbr
7UsHa/dpgY0A3UZgJ1DDSaFCUYoTGOtf9rVG8N20gPFLczxmE5QpsVjs8C42MK3P
2PwscxQmfqgAGW8ss65UKT+HU9wWtDUoT7m8NQM4+hN9TL5Png1+kbZFlGiHJNuJ
cx28TRoRm1Lqgqk564KhiwjdyG647aW8xjmINZmeFPp8vIsm9/3YGZabDrMKxO2u
kW4Zglz2LtuCexpEjevyQ08CeOrKICEQwQ/babYLre9+8kjKiTWBvgq1cUHUi+fr
tLCWKeklLT6Y/oi3C4nDpbNfEm/zjvXFZMXk3BPtaU93oLaGyxSa7aOByEyTyR8f
f09A5W6d/A58A7riBFzg0dmYidXb4i3eVwBo7ZJBS6EVwZMravjlCtzy+uLi1cgN
PjvzsxF23vicFXBlnJei16ppbvsQkhdUTM+t9xqD/IzB2vV8E3r4hrhjb8lLQX0f
MJagtXeZ+v5Mz0COdheF26Qw4mzk4L6FlJOlPsCO2vjgIuna249mP+OdnIFF4uYk
Kt88hofdvndvJEKVrj+Q
=+pGv
-----END PGP SIGNATURE-----

--=-i+SNgcpIbpjHOhCAbn88--

