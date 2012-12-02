Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2LBW4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 17:56:43 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11164 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab2LBW4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 17:56:41 -0500
X-AuditID: cbfee61b-b7f616d00000319b-20-50bbdca76e91
Message-id: <1354488971.18849.8.camel@kjgkr>
Subject: Re: [PATCH 1/6] f2fs: fix the compiler warning for uninitialized use
 of variable
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net
Date: Mon, 03 Dec 2012 07:56:11 +0900
In-reply-to: <1354326912-6656-1-git-send-email-linkinjeon@gmail.com>
References: <1354326912-6656-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-c8ekLThtiR3leZS2u5F5"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zse7yO7sDDJYvVrbYs/cki8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mp41neVteCEREXP7gtsDYzzRbsYOTkkBEwk3n+dxQph
	i0lcuLeerYuRi0NIYBmjxI/NH9lgihY/fssIYgsJLGKUOLJKFqLoNaPE5HmH2EESvAI6Eqsn
	7wErEhaIlmj8N525i5GDg01AW2LzfgOIXkWJt/vvsoKERQTUJCY8SwUZwyywg1Fixf2vYGNY
	BFQlzv68BjaGU8BF4vrVPSwQvc4S0zp/gdn8AqISJ1s/gdUwC1RJPJ4yDepOJYnd7Z1Q5whK
	/Jh8jwVipoDEt8mHWED2SgjISmw6wAyyV0LgFrvEp7c/WSB6JSUOrrjBMoFRfBaSsbOQjIKI
	a0q0bv/NDmFrSyxb+JoZwraVWLfuPVSNjcSmqwsYIWx5ie1v5zAvYGRfxSiaWpBcUJyUnmuk
	V5yYW1yal66XnJ+7iRESk9I7GFc1WBxiFOBgVOLhTVi8K0CINbGsuDL3EKMK0JxHG1ZfYJRi
	ycvPS1US4V1csTtAiDclsbIqtSg/vqg0J7X4EGMy0KcTmaVEk/OBaSSvJN7Q2NjEzMTUxNzS
	1NyUNGElcd5mj5QAIYH0xJLU7NTUgtQimC1MHJxSDYyG65rVVW89PMUb93OTgP67s20nc57c
	Ou4QfaBONKJuhcdKsVvnv/U172yKOv/CalP2xGv2O/5XVb85XXUtItkoS+vqyeMT9mhqtF3i
	LLfXe99yIMzAMnt2RqrpgpkP2C6K+ljV2IXotPvlh7q+Tpt0JGiRc3bgC8apExk+GT4Kurrl
	p21wzXUlluKMREMt5qLiRAACsw1YGQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd3ld3YHGDSvkbXYs/cki8XlXXPY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMeNZ3lbXghERF
	z+4LbA2M80W7GDk5JARMJBY/fssIYYtJXLi3ng3EFhJYxChxZJVsFyMXkP2aUWLyvEPsIAle
	AR2J1ZP3gDUIC0RLNP6bztzFyMHBJqAtsXm/AUSvosTb/XdZQcIiAmoSE56lgoxhFtjBKLHi
	/lewMSwCqhJnf14DG8Mp4CJx/eoeFoheZ4lpnb/AbH4BUYmTrZ/AapgFqiQeT5nGBnGnksTu
	9k6ocwQlfky+xzKBUXAWkrJZSFIQcU2J1u2/2SFsbYllC18zQ9i2EuvWvYeqsZHYdHUBI4Qt
	L7H97RzmBYzsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCI/6Z9A7GVQ0WhxgFOBiVeHgT
	Fu8KEGJNLCuuzD3EqAI059GG1RcYpVjy8vNSlUR4F1fsDhDiTUmsrEotyo8vKs1JLT7EmAwM
	jYnMUqLJ+cAklVcSb2hsYmZkaWRmYWRibk6asJI4b7NHSoCQQHpiSWp2ampBahHMFiYOTqkG
	RjNX+1t2rpZRaomJUY91b269eTj6lrWpYI2h8pZZb+1bkuZtu6RcVsnR4D1Byk2pDCijf6jh
	Ic/lal/z3gmzou1yFm0qT/t6LFC43S3SwnqO/d7f5dUXPzssP3k8imU2xzlmFZ4jz+Ybhsjm
	L/8W5MDdIdEUoLjZZPkHtx8XMvl28WzMEFdiKc5INNRiLipOBAA0JGegSAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-c8ekLThtiR3leZS2u5F5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please, add CC: linux-f2fs-devel@lists.sourceforge.net

Thank you for contribution to f2fs.
Looks good, and I'll merge them.
Thanks,

2012-12-01 (=ED=86=A0), 10:55 +0900, Namjae Jeon:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>=20
> When CONFIG_CC_OPTIMIZE_FOR_SIZE is enabled in the kernel, -Os optimisati=
on
> flag is passed to gcc for compilation, and somehow while trying to optimi=
ze
> the code, compiler is might not able to see the initialisation of variabl=
e
> ne struct variable inside the get_node_info() function and results into
> following warning:
>=20
> fs/f2fs/node.c: In function 'get_node_info':
> fs/f2fs/node.c:175:3: warning: 'ne.block_addr' may be used uninitialized =
in
> this function [-Wuninitialized]
> fs/f2fs/node.c:265:24: note: 'ne.block_addr' was declared here
> fs/f2fs/node.c:176:3: warning: 'ne.ino' may be used uninitialized in this
> function [-Wuninitialized]
> fs/f2fs/node.c:265:24: note: 'ne.ino' was declared here
> fs/f2fs/node.c:177:3: warning: 'ne.version' may be used uninitialized in
> this function [-Wuninitialized]
> fs/f2fs/node.c:265:24: note: 'ne.version' was declared here
>=20
> Hence, lets initialise the ne struct variable to zero, which will remove
> this warning and also doing this does not seems to making any impact on t=
he
> code behavior.
>=20
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
> ---
>  fs/f2fs/node.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 25d3036..1987036 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -266,6 +266,7 @@ void get_node_info(struct f2fs_sb_info *sbi, nid_t ni=
d, struct node_info *ni)
>  	struct nat_entry *e;
>  	int i;
> =20
> +	memset(&ne, 0, sizeof(struct f2fs_nat_entry));
>  	ni->nid =3D nid;
> =20
>  	/* Check nat cache */

--=20
Jaegeuk Kim
Samsung

--=-c8ekLThtiR3leZS2u5F5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQu9yLAAoJEEAUqH6CSFDSVCsP/1hPjaFBKftLivru6LOJWfEr
usCqo43mcHuijZ8tebhSvcwm0zHYWcD7qWMMEJq9F69Y8ziSSHW6SufembH36Rpx
uaFG1T5RogcxSoBII0RcECo5wgtMYYszRj72niQEnsKU2tMlKmLcpmZMJ1lCoHSW
NC4cMGsG945qMSIVtMEDdCLz3mRnYvoZ1a1fD9+MgSx0/JMIgoy38grPKqqVNGQO
Gugf6knvV4unvkIpIdM++CjTR2xo/Wn4GnK8YBt8F9W5IY2UGivwDz7aYAjW4eKX
7Cub/zinSizCxnGNIi/yZYmMw0cPjJqw5gpAQVFnCnie6udjvsbmDSqj5V5kLMyn
KlVECZhzPivqnVxC0rH39PU6XgKJAWOO51IjCKimJJ3SUy+xxB4DYFDD3BqxCX+l
eyyVFswkGJek41B+DSgyvYS93rWeyRUaHq/XeACvxxpY/TjlknXoW62kz6ic9Hfw
NUwmnOLaoHoJwbG8VeZxLBAamOWzy02Q/4f18EKHtHAX+XwMSOyhwH7KudaOp3/K
9tHvdx589MQgxpc7RsfndjsPaZKTkYm2XoMB+BCG0L8QlvuJbEg+Kk9n1gfK29tm
De7UvdI5yzvo9XJlzjiaGk0/6VUN0nceuG4H6jRScz80U88AwcyTwfWOlP/0Uwt8
8EP9gyiFh7BcMuSzWqeo
=Sq7G
-----END PGP SIGNATURE-----

--=-c8ekLThtiR3leZS2u5F5--

