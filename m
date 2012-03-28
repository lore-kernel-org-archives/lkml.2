Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab2C1MTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:19:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54671 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2C1MTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:19:24 -0400
Date: Wed, 28 Mar 2012 23:19:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
Subject: Re: [PULL REQUEST] DMA-mapping framework redesign preparation
 patches
Message-Id: <20120328231910.759801b2f9173ea0a1247fbb@canb.auug.org.au>
In-Reply-To: <00b701cd0cb9$5a4ea900$0eebfb00$%szyprowski@samsung.com>
References: <1328898737-15854-1-git-send-email-m.szyprowski@samsung.com>
	<20120213112145.4b8990c739d297cd30714d52@canb.auug.org.au>
	<00b701cd0cb9$5a4ea900$0eebfb00$%szyprowski@samsung.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Mar_2012_23_19_10_+1100_3wK5ySiHIExxtj7z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Mar_2012_23_19_10_+1100_3wK5ySiHIExxtj7z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marek,

On Wed, 28 Mar 2012 10:04:08 +0200 Marek Szyprowski <m.szyprowski@samsung.c=
om> wrote:
>
> I've prepared a separate git repository for all our dma-mapping related w=
orks.=20
> Could you update your database with the new entry? From now the dma-mappi=
ng=20
> updates will be available at:
>=20
> git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git dma-mapping=
-next

I have changed to use that new tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Mar_2012_23_19_10_+1100_3wK5ySiHIExxtj7z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPcwG+AAoJEECxmPOUX5FEN6YP/jg1Xk2guXfoYfwPKHUQmqjL
dyvLzxbicmCYxo2dcpToNzmAfmhfHerEEFzglAW+CTscE+qOxHeFojN5ePopxvYw
WgW8Fccz8oI44g1D5ysgyud/W9YtsobXCCpDp4CBbvA7v1mALnO119hOnJIiixiV
nKo4fZ7UT1VFC15BEpSnm1ImQlWDKtgcoMAD0jBp6XHfpKzjzKPTArClveUK4pf4
XOM8fDeEM65GGid9PLSCRMxrKEsLg+6VLWGNw/05d92inun9FND/R75NxqL/I9BX
yJwMfbsKTmSCA5sa+Ukf4PuwQ0WJ+O5tvv+8USNxxnK5jHAxMRBI19BLCg9wQ9MM
jQH7ebB0eBBtZWab3aLqFNTVfjVvEr8Hu32xhD+mtEHARS8LeXCImFIySEHlzSG3
4IYiTjizH4exzPUfjE9WZj/dbsWMNzxRBv65QKzCsUFGd6Es/RtvHvxzgJlVk++l
Z46w3Bg5iWPr/ON420SHEoPjAeeDQnxhswuY93tlUsBZvPTHe9vlK7QPzACbuNLU
SxpIlAukOmMyrwFq59UYOmm/rWpxt/gxmpr/oVEZNsTLUTvpy2mqJoOyJNgDUJKT
HOpu9iZdRgrIDE6/WoCoHw5Jw2YBbpAyCjApoFjXQY53fw3ow2SgyZUuDLYRcHnp
nBdpAOZFD+nHxosbKoLB
=Fc7s
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Mar_2012_23_19_10_+1100_3wK5ySiHIExxtj7z--
