Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab2K1AXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 19:23:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:22376 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2K1AXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 19:23:02 -0500
X-AuditID: cbfee61b-b7f616d00000319b-56-50b559648ad3
Message-id: <1354062153.15731.15.camel@kjgkr>
Subject: Re: [PATCH 1/1] f2fs: remove unneeded version.h header file from f2fs.h
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, chur.lee@samsung.com, patches@linaro.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 28 Nov 2012 09:22:33 +0900
In-reply-to: <1354012336-32089-1-git-send-email-sachin.kamat@linaro.org>
References: <1354012336-32089-1-git-send-email-sachin.kamat@linaro.org>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-q2SqjEyuLuAlCdxmXtZA"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+ZgW5K5NYAg2v/+C0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGhoOX2Aua+Ss+vF7E3MC4ibeLkZNDQsBE4vHVaewQtpjEhXvr
	2boYuTiEBJYxSuxc08ncxcgBVvTjmhBEfDqjxJ4nfewQTg+TxLv2+2DdvAK6Eq9b7rGC2MIC
	ARJnNv9iAWlmE9CW2LzfACQsJKAo8Xb/XbASEQEtiZfdy5lAbGaBEom38xaCjWERUJX49v8P
	WJxTwENi1ekfLBC97hJTbx9nBrH5BUQlTrZ+YoTorZJ49vQ6M8QDShK72zuhzhGU+DH5HgvE
	TAGJb5MPsUD8Iiux6QAzyPkSApfYJXZ0/mWD6JWUOLjiBssERvFZSMbOQjIKIq4p0br9NzuE
	rS2xbOFrZgjbVmLduvdQNTYSm64uYISw5SW2v53DvICRfRWjaGpBckFxUnqukV5xYm5xaV66
	XnJ+7iZGSCRK72Bc1WBxiFGAg1GJh9fBcWuAEGtiWXFl7iFGFaA5jzasvsAoxZKXn5eqJMKb
	oAmU5k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR5Hxg8sgriTc0NjYxMzE1Mbc0NTclTVhJnLfZ
	IyVASCA9sSQ1OzW1ILUIZgsTB6dUA6NE8OWNzqF/7niWb5++fLHm0XVG4ovu1Ukc5KvsmDuP
	88qxPOGOaU2N8goicQVa02sVF1lpRfbLGZ1YO2H32ksvRb6GK+zh2Pht/777fzwDVUR8a9oK
	nuQe/WJeEVO/Rtrjtp7Vf+M/s/X/HG75HvVb/vkzn3XyL+57NemdEJ+uWXVd84PAHUYlluKM
	REMt5qLiRAByWyy7FAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t9jQd2UyK0BBhv6uC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxoaDl9gLmvkrPrxexNzA
	uIm3i5GDQ0LAROLHNaEuRk4gU0ziwr31bF2MXBxCAtMZJfY86WOHcHqYJN6132cHqeIV0JV4
	3XKPFcQWFgiQOLP5FwvIIDYBbYnN+w1AwkICihJv998FKxER0JJ42b2cCcRmFiiReDtvIdgY
	FgFViW///4DFOQU8JFad/sEC0esuMfX2cWYQm19AVOJk6ydGiN4qiWdPrzNDHKoksbu9E+oc
	QYkfk++xTGAUnIWkbBaSFERcU6J1+292CFtbYtnC18wQtq3EunXvoWpsJDZdXcAIYctLbH87
	h3kBI/sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOA4fya9g3FVg8UhRgEORiUeXgfHrQFC
	rIllxZW5hxhVgOY82rD6AqMUS15+XqqSCG+CJlCaNyWxsiq1KD++qDQntfgQYzIwNCYyS4km
	5wNTU15JvKGxiZmRpZGZhZGJuTlpwkrivM0eKQFCAumJJanZqakFqUUwW5g4OKUaGEtEj8YK
	PK5UFGHzbK3oK0v7q3aM+//diI1fL56fEdwSOTNQdhrLt/mX6q82eU9yfn4sWuOY0QaNyBxm
	0QMJrN0XLzuUhhyy+1W95tveNYedOia+a2V59EcgX3kXpw3Lnx+9MQKJfi/3G55TWRQ70fLN
	0vXcB/96S62Lj45OlmG/Njsq8cT+1UosxRmJhlrMRcWJAHfLGapDAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-q2SqjEyuLuAlCdxmXtZA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Add CC: linux-f2fs-devel@lists.sourceforge.net

Thanks for contributing.

2012-11-27 (=ED=99=94), 16:02 +0530, Sachin Kamat:
> Including <linux/version.h> is not necessary.
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  fs/f2fs/f2fs.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>=20
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 7aa70b5..d3f5a70 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -14,7 +14,6 @@
>  #include <linux/types.h>
>  #include <linux/page-flags.h>
>  #include <linux/buffer_head.h>
> -#include <linux/version.h>
>  #include <linux/slab.h>
>  #include <linux/crc32.h>
>  #include <linux/magic.h>

--=20
Jaegeuk Kim
Samsung

--=-q2SqjEyuLuAlCdxmXtZA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQtVlJAAoJEEAUqH6CSFDSkgUP/254MEuxQACAWtYlRoGhSTGV
WlaOGd7idpm1qMJLhxujL2J1COOG7vUaot8Op5bI71FzJ1UfJMfePCpj/66iPeDc
NAlsxueqi3FiWHm5CNELrZRsxZSRLQ5vqwm3LU883WmQFKEGQzju/LJ4JEOjh8gN
/Be5LJbaF60DdehaCx5mhEnU2inX1O/XpswiCJddENnPs/oPikaGva5FBc4k2IZH
qxG/x4SN0JpQecU7XAc3+c38ZxaMIliNpvFF2DrLAYv2/pG7+mryDTyTBXy5OBgA
dcfgM13cM186eSum4/5dydCIfEdPrDUYg182qKHfAnILhfR2lg+w50a91popVImc
CDJcVxqd9sJGC+c1JZjdWjMRabZAlOLq42EssqA6P6XUlkTNs7baIt7sdtS3B0DP
56m5aQhxrp/RJmJp4Hn65JJr/Ti6M5L5HxmgONYMjCsbNz+foaFqovBqh9p8YizX
t9YDOqm02DVfFJCTh+97rnvA8n2xtZaFAPQ7pYjBnWANeeurfgL4gtsmRzCK75rL
2RiiyQRYN6exNbS6tBvZzgsbFkmBfKYqIcRlW2N4heLFE8Cs5yFJgyxQ9H6rypmo
+PsDRxwQEY4RRCX0ZaxCjCA9PU1l+wcdghwYLxYxuijd16fP9KB4bxQOs8FZ1G0F
dh/k9fmVcyW7oldcGmvq
=+M8y
-----END PGP SIGNATURE-----

--=-q2SqjEyuLuAlCdxmXtZA--

