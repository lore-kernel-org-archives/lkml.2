Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab2KLD41 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 22:56:27 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43799 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2KLD40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 22:56:26 -0500
Date: Mon, 12 Nov 2012 10:42:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [next:akpm 136/313] mm/mmap.c:1878:6: error: 'mm' undeclared
Message-Id: <20121112104251.096430979a05e998f1947077@canb.auug.org.au>
In-Reply-To: <20121109062150.GA7022@google.com>
References: <509c9bb9.+RUyEEi+hJKJghoL%fengguang.wu@intel.com>
	<20121109062150.GA7022@google.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Nov_2012_10_42_51_+1100_1/1uKHOcWBSy_apX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Nov_2012_10_42_51_+1100_1/1uKHOcWBSy_apX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Nov 2012 22:21:50 -0800 Michel Lespinasse <walken@google.com> wro=
te:
>
> commit 34550b95185c1ecfa8882664744c14edda385868
> Author: Michel Lespinasse <walken@google.com>
> Date:   Thu Nov 8 22:14:34 2012 -0800
>=20
>     fix mm: augment vma rbtree with rb_subtree_gap
>=20
> diff --git a/mm/mmap.c b/mm/mmap.c
> index d12c69eaf23f..0b8f9d83e2e2 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2032,7 +2032,7 @@ int expand_upwards(struct vm_area_struct *vma, unsi=
gned long address)
>  				if (vma->vm_next)
>  					vma_gap_update(vma->vm_next);
>  				else
> -					mm->highest_vm_end =3D address;
> +					vma->vm_mm->highest_vm_end =3D address;
>  				perf_event_mmap(vma);
>  			}
>  		}

Added to the akpm tree today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__12_Nov_2012_10_42_51_+1100_1/1uKHOcWBSy_apX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQoDf7AAoJEECxmPOUX5FEAdQQAIYVxGU65e77v4WVRdPze1dR
qXt3sCTwl1KE/FB7mNCaOS26umH3ItE/RHin0eb/iS+5vNaPUD6orXfYRNmXXr3m
9xAHdIdLNogC6H7RHc1Vxm9sH7EDbR5KwV0gFbeBBflcm98fsVfPi5x6IEKmRhUx
0Oj4n7mIWjBZ8QUf8jksMR+cVILix4ooeTbjW/MQ+SVyfaIf0M7gCpVo3YWWFpN7
bUhujUzklMKfBj2FHut0JzUfq6HUA9LHe7rh5zIq7wPoSe13K9db/dGybwu6a20J
XVY0xm6Bti3lXcOlrPpz59DpFCd9UJ1qcmlTJGXC2p0adZB2rSuITur2ZtIKCmCd
fpjkirySmK/FE3vYH+4MHXxSxXbxYDpdbOkUTIBMyPHFbXFTtU4oxkvZ6Y4gjBY1
GFZoUm3S+mTGhqot8GtA8fCMWsHDAEUKhYVKfeh5dBuf3WEaLN/GEB8LtUP6fj7R
Aoih+We1OnQAFF9awFSDcIggekLs3kII5TR5eEKkUlIrnoLGB9seRO80Jqh76F0j
hN7QdyURFj+WSYYJthjtU/8kVgMKFLr4slTxQ+wJp9lVAM45KLm3aEMnJI8UGMgh
zX58esjpB28OlmBmnm41xtun2EhXQ429O8gpPLNX2iUExWrhdLtk87UMtPfCImm8
l392FeOJ17xDduwJ5Z+L
=XahQ
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Nov_2012_10_42_51_+1100_1/1uKHOcWBSy_apX--
