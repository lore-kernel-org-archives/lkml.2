Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2LKVlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:41:22 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40022 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2LKVlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:41:20 -0500
Date: Wed, 12 Dec 2012 08:41:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>, Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kees Cook <keescook@google.com>
Subject: linux-next: recent rebases
Message-Id: <20121212084108.de14154ec0e365453617bfd7@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Dec_2012_08_41_08_+1100_yoT=d4CfmdSCJcS."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Dec_2012_08_41_08_+1100_yoT=d4CfmdSCJcS.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

I am not sure how much you care about this, but here is a list of the
trees in linux-next that have been rebased in the last day (i.e. since I
fetched the trees for next-20121211):

fsnotify: rebased to v3.6(!) to resolve a conflict.
	git://git.infradead.org/users/eparis/notify.git#for-next
f2fs: rebased to v3.7
	git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git#dev
dma-mapping: rebased to v3.7 (you already merged this)
	git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git#dma-mapping-=
next
drop-experimental: rebased to commit caf491916b1c (this tree rebased many
	times since it was added to linux-next - mostly with no change to the
	patches involved - maybe it has had Acks added or something).
	git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git#linux-next

At least these trees have been rebased in linux-next as well.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__12_Dec_2012_08_41_08_+1100_yoT=d4CfmdSCJcS.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQx6h0AAoJEECxmPOUX5FEutcP/3WpBG+Ykv39IAZzDvjJI/Wr
O3QDLcu23JGvoCgf64goln3UEM9Chc9uYDUlEH57yitnfEta8WeMNVhKxxAPtWer
/Q3/GXur10h6BbFXs+opa5RSsOyl4QZ/sAXXh42R49bDdAmbatxIkXuAkoKmBCqw
KE3746x0TvAWM/rgQuQA1YSIvpC4at5eiq56eMlSsf3UEZC4tFGgNTW34srQ7dYv
0QmcuqMJs7ZXIGfGo+wdYPOlNvdBaT08EcY+YH6MtriVjutRxhrmsD2TKnWh2kKr
W9s0x4FVAJla2UrIFBhE6X36buR/IdGlKcgPYY7ja2FAa4q3Z22JJPAY7ohHJtOL
lCTeERpeVhpNhZfkr6pPQT1P+e742/V0ZpYYAHEuvDsxKJBo2st6X7rN0omXnkFs
qwHJObZKTErwKj1WpFsU9WSQ/JkR7jQO5HkK/oDEVfNhudUD7W2zu9qbMqWkPzW6
8zIREsrspYopC5H89njmOWTaDTXxtYffQyAo9/utnGBWvY3fQ7M11C8QFI0lXRCx
wfhVVEz99Ty/IHUWO74oMy6Z3tk+4UNSDBxgk4geS2LxC0exgI3i1CAea2JcASiM
XA6j/ZfbSjREdU09oYGzwccaVkNXib8HKj7KGTxdu8NYRhp0S6vnmyWMOjD6mwbF
HsOYp0swoPNy+3CNuPnU
=hGbS
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Dec_2012_08_41_08_+1100_yoT=d4CfmdSCJcS.--
