Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab2JCC1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 22:27:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35629 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2JCC1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 22:27:44 -0400
Date: Wed, 3 Oct 2012 12:27:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: linux-next: build failure after merge of the ubi tree
Message-Id: <20121003122735.692388e2f68dd85e43052c70@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Oct_2012_12_27_35_+1000_K9LNcQfAeb+ZiuV2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Oct_2012_12_27_35_+1000_K9LNcQfAeb+ZiuV2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

After merging the ubi tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

ERROR: "ubi_update_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
ERROR: "ubi_scan_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
ERROR: "ubi_calc_fm_size" [drivers/mtd/ubi/ubi.ko] undefined!

I have used the ubi tree form next-20121002 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__3_Oct_2012_12_27_35_+1000_K9LNcQfAeb+ZiuV2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQa6KXAAoJEECxmPOUX5FEWNMP/2cq7OLQsIMU9+mzPm1S4KRX
KnpvFqVkWEJGCpN3zafgKZPICANAAmibJmWXziF0M8BI9ayq0OgJmK33AKk4EKVF
pb3gldKQ6n4M9MLJsrQPdVh7sLbWXsqfYcgrvXhjhzDxpstRV1d73m13VssDOmzy
63YhQnJksS/xM+GoSfIGCqROs/tDEqnhZ4VWfOjj6WQJp2g6rmmMQV9B707SuNtY
+vYzJW0MUG5lD72gbYlD9bt7ZqyGHDWTOkYdCVo5QD6mhi4CL6SDC2SRMAicyoHE
+qKzl2Sp3Vo+SQLC+m6afy/yv0XR/SDUOg2Q9x1FRFKhfcVH82QPUPzgk37+B7cc
hd+Q6El4tIq11/rmLmkNyRDS1/Abm69DdsiJq97Tj+yLKq37g7PJfolcuD998bUB
GZqqD6cmQNq7A0w7SPizX4RFexxSvNhvlYF0HcBHXErcaJEt4FF/zIWxqP+kHnDU
pPHmn4gCDGasKcxaY+V5zX7kq0qVcFdFzMVFaOZ36Wcn8sHxjooRsZxoE3eiaiYA
+4hbuJhvQMjhtDMuUe5jMh7U2UWmUvvAc1tTLC7iMURm27TCXqJGR8ZtOMlmoa3P
kzvklZAIsnzUN4MeR6pmlOAckajHcqSFZSRI0bkYlRLsVtM0+A72zNFREGv+yFET
Fv0m0M1zOVBE5Z25KKqC
=EZjM
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Oct_2012_12_27_35_+1000_K9LNcQfAeb+ZiuV2--
