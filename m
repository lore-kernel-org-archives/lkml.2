Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab2IMIcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:32:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54464 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2IMIb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:31:56 -0400
Date: Thu, 13 Sep 2012 18:31:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20120913183154.5a638d274ae5bae800890ee0@canb.auug.org.au>
In-Reply-To: <CAK9yfHwceAmikpPCYGCnDwzY9igvwkOj7j314+sC4_kD8Egzmg@mail.gmail.com>
References: <20120913174441.f5fbf5cc38713425331f4d86@canb.auug.org.au>
	<CAK9yfHwceAmikpPCYGCnDwzY9igvwkOj7j314+sC4_kD8Egzmg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Sep_2012_18_31_54_+1000_kYyZwpK=oGMBTx/N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Sep_2012_18_31_54_+1000_kYyZwpK=oGMBTx/N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sachin,

On Thu, 13 Sep 2012 13:19:48 +0530 Sachin Kamat <sachin.kamat@linaro.org> w=
rote:
>
> > - *  This program is distributed in the hope that it will be useful, but
> > + *  This program is distributed in the hope that it will be useful, bu=
tX_ID_MASK
>=20
>                             ^^^^^^^^^^^^^
> Looks like a stray paste..

Yeah, thanks.  I will sort it out tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Sep_2012_18_31_54_+1000_kYyZwpK=oGMBTx/N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUZn6AAoJEECxmPOUX5FE75YQAIesbM/5+W9jYwjMM272mmqF
iMic17K0lSkdNtKJA+luHxrTOS8pu4G6xKylzZK854pI4QJaVtN9rjK2uTk3xQ2l
LicClKh8CySzmLbf4ZLwkxCouID8OgzEIVkbl3dzzY7Jqb54pKSbZMwcpuwme5S+
5X/in3epGqX6q3A7NqnQkEr/dybSm9X54I5zOsQFwxGxZQn2K6Is+0CQ4mTb1N3U
rkw6cBohK+MvrkMcOqBsgRTgjwOFs4XHoIpq8DyF+RpXjeRTKmXyFLsEqdSKr0es
ExjhDEe09kNPR7f/ZY50JWodAXI236ln4uUft8TH0ZQs4spe5bucq8yyXuXWzTne
SWQLiY86uJUtfQt5FSmzoa/Hsnk8OKKQBr1uOZc7VyXVLIBeo43+5bhoDrO7wTTH
UxTnRTmLc0GqW+ufAWT0A34fbKqGTCAZ+/G9LOIQ3oDYiiP7bufQgi81t7Y2cpaQ
qtf4LSoW8nJw3L2gZrbgZPbPVBSYnaOcd2Tj/4n4jjvexRLWupIQzecZnp5nkeRE
n4OW6eOmhxkUp6QlokmftIPxO6vkw8AvjJIAtUTHP9MA8jcol9Z1fsuDkak8rlG/
jQ4vWJ3luUE22axaouXqoRiDBuMAQzeLwv/acmuOj22kErQGUuG0bi0JOFKuWSoJ
uXIi7qS05y7xGx6XcbfJ
=C8eU
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Sep_2012_18_31_54_+1000_kYyZwpK=oGMBTx/N--
