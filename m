Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab2BJE6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 23:58:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55900 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab2BJE6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 23:58:13 -0500
Date: Fri, 10 Feb 2012 15:58:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: linux-next: build failure after merge of the staging tree
Message-Id: <20120210155800.ccef418fd5c2f2b87a5d6315@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__10_Feb_2012_15_58_00_+1100_Npx+O5=Z/WniRGL2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Feb_2012_15_58_00_+1100_Npx+O5=Z/WniRGL2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/staging/ramster/ramster_o2net.c: In function 'ramster_remote_async_=
get_request_handler':
drivers/staging/ramster/ramster_o2net.c:91:2: error: implicit declaration o=
f function 'o2net_force_data_magic' [-Werror=3Dimplicit-function-declaratio=
n]
drivers/staging/ramster/ramster_o2net.c: In function 'ramster_remote_put':
drivers/staging/ramster/ramster_o2net.c:250:2: error: implicit declaration =
of function 'o2net_nn_from_num' [-Werror=3Dimplicit-function-declaration]
drivers/staging/ramster/zcache-main.c:40:64: fatal error: ../zram/xvmalloc.=
h: No such file or directory

Caused by commits ba351b02ab11 ("staging: ramster: local compression +
tmem") and 14a3cd58dd4f ("staging: ramster: ramster-specific new files").

I have used the version of the staging tree from next-20120209 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__10_Feb_2012_15_58_00_+1100_Npx+O5=Z/WniRGL2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPNKPYAAoJEECxmPOUX5FET90P/1QnaDZZblLQultoeIbYF6bi
diiuVjHDoVPyi5nom5zxkUX0yQBnbIrmnBjjb8Kub59ofuWdBz5h6jGohafkFI9V
ob1KIpknN8CYlADsVbXdA2b6iHHNdsTDeLZ9B0hPYzdy3zMlcjGcV4dZiQdRSf+f
jhHhHqJmpzCnkY1bzzUgMg7c/eP3iBQOfjuJjc88sNA1MGGpLLZ0Awi/PiHXstrL
7mhuAKQ81uq9aJl4AJ/z7Dt8lcjZMdtQqWKFz2hxuqFvkTi8Mfi39NKxtMoT3T98
6jpMyCP93n+AxVsMSzepMN9PAv9n91ye0UYOt60Lh8b9pJnimPyiLsPjIKGFUqm9
QLuZpCohcYzNnLg/q91SLvF6ft+y8cApLvUCTywT2BF35QavqALSdXsWWAoTqoGd
0Jg1y4iEqlhhs6cMaFlIgwk47ZrIALaCENSUO8RwvAKJvSoa9eTO4XVsl/WlUeWz
Hg8RstjafKqgFyBEAwEFToxRkqykQMElwDyNe5kVS7jXFwL20lMSL+vpTCISGCCy
NB6YWfOdVhVB7iqc47LuXpm71ZLaFCz+dYiDQjtKzbl3ZCD10OAhX0UegWq08pJ6
lpkzDyuEp5bQJRKKs+shRSxl9cYdS2nuhTJlwC7bEFjD4OKqlmUpvFUUUVSX1HaO
zRsFk6XGMganKGkd3qqM
=WNaL
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Feb_2012_15_58_00_+1100_Npx+O5=Z/WniRGL2--
