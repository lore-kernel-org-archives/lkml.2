Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965364Ab1JGDHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 23:07:13 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:47299 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab1JGDHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 23:07:11 -0400
Date: Fri, 7 Oct 2011 14:07:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the md tree
Message-Id: <20111007140704.1ba7b29ccf5b8aacdb43560a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Oct_2011_14_07_04_+1100_NyPvLOGVsIPBARnl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Oct_2011_14_07_04_+1100_NyPvLOGVsIPBARnl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

After merging the md tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from drivers/md/raid1.c:40:0:
drivers/md/raid1.h:71:2: error: expected ':', ',', ';', '}' or '__attribute=
__' before 'int'

and went downhill from there ...

Caused by commit 9d64362373aa ("md/raid1:  add documentation to
r1_private_data_s data structure").  Please build test ...

I have used the md tree from next-20111006 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Oct_2011_14_07_04_+1100_NyPvLOGVsIPBARnl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjmzYAAoJEECxmPOUX5FE4y4P/j8vjUIQ68Bb0nMf20RomdXj
JrdRvyCzSg95pBSj7KBxz2sK/oeiOdZkh6+/I1OJ6OhMbYYBtccOFo4LCZ5N6iR5
Zz1Ick2+irPodZ7aMPAZ/Mseelr0wHfJjQPLXFBe2G9Lpr5snB9msSEr9Z471WtL
4Sn12cuizKkkKJORyrlrzYYW0MCLrA7kKPOWFb3BXMNbfCFM82NLc/CPzFGgbyXD
3COIR30K5XwwJOcrAaiAWmX91GMgHiVEGw/0fxsg1fWWayBMFu/ZVu7Zw+Dw69Gq
wPW1Dwm9nFvgDoOg7eHo2rRgMoP8ABGy7yYh/Pxqp4hpy/Ep1m/q8Vy99bLgSLWm
xc1NVv49pDl8Rll3CVMXqB9/dnayfNb19tjFlJ1BY5cU6vA0zB3oHpVU++yMYM3+
cEmSlb7VozrO7VbWIl7EMmI1oOkakc3BmZW9iFMiEhadQiNK2vNBq/fBFoaR548F
wkRQq5Z+CsK24vbbyw7jQqTjrkM5Cbnn4aLfNYYggdQpCH4dm15oxsrNyzEfeGQu
obWtYVrdXNid4nPqAp+sKfNqvNurd4JqE6C5LvbR5TWQicp9xAfvI3cXvQdH4e+Y
9hLOgXFyIp21Mc6kZINx53NpAciJtfdJa0Npyc5Liwhl6M7Wyo1mQsokEmBXTOac
pmE/k3PusQP+ifM9aw1n
=hyBL
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Oct_2011_14_07_04_+1100_NyPvLOGVsIPBARnl--
