Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622Ab2JXMr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:47:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50968 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab2JXMrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:47:25 -0400
Date: Wed, 24 Oct 2012 23:47:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -mm] procfs: add VmFlags field in smaps output v3
Message-Id: <20121024234714.03b516f6fcb32eb5a27eed1b@canb.auug.org.au>
In-Reply-To: <20121024122730.GO30983@moon>
References: <20121024122730.GO30983@moon>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__24_Oct_2012_23_47_14_+1100_zr/6siix3p8ocXD2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Oct_2012_23_47_14_+1100_zr/6siix3p8ocXD2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cyrill,

On Wed, 24 Oct 2012 16:27:30 +0400 Cyrill Gorcunov <gorcunov@openvz.org> wr=
ote:
>
> +static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struc=
t *vma)
> +{
> +	/*
> +	 * Don't forget to update Documentation/ on changes.
> +	 */
> +	static const char mnemonics[BITS_PER_LONG][2] =3D {
> +		/*
> +		 * In case if we meet a flag we don't know about.
> +		 */
> +		[0 ... (BITS_PER_LONG-1)] =3D { "??" },

Sorry to be picky, but the braces above are unnecessary,

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__24_Oct_2012_23_47_14_+1100_zr/6siix3p8ocXD2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQh+NSAAoJEECxmPOUX5FEk4IP/12Gz9x5Xa6cQ+Cs0Qjglxxk
2e6EvjTb9o0swIrFQ8PZVa4Ba3Xgrvk6eoxSPwgNagv7UHV4Yn02v6EmhnYaJpZD
dUfRma6/hpBk6YKfhn5vI4VOT+DGs1iZ6avXeF3up64TP1Id4Xo3VBPh3whhXYEi
5y/0rW6+O+dcgYsUNA4/omBDeuAMkpkx5ZqS3HlLmbxI6n2kaBbGXSuXj/2HOavb
Bc2nxSnkspw9tspcOcEHFgsU5x+bkj2p0NQQrbtg1dz2yUCRk5alMSs/uYdzAIh7
aIagTKKiiPmlDtPhE0B+6ozQYG/+u9XOeLPGktqwd6hw0ft5gwDT3E8a8uMFsa1n
Ib4o+0EKTGpYW6Eoi73fmrgbr4w2hk4/yDfV9feaOwXIDkNj9ZWUCe3y5yeFyxaT
beCQ8ldm4NBTVBbdFKrgq8Zx7DUPnWXI8D7ttexW3cvOBPF64ZzWQFDMTgvYmfgz
1mySHal5wV9htML5EcvmZ4nxSsHeOqwl+tU+0zk1nB30pkQXEGzDgpKHCaSmvu+m
VK1JJKLTQxhCfzQ1EJUtHW7+F+XY1YQq0EJkU+NtN1Q3MjQZMJ2eTYhO/RDs8Shb
tawy5g3UTLP3CyocRYf5dSNCfEHuJJTy1apNufPg0UvzNYFDyJgxaSuhXWoFQRvL
aWeX0QLgDxqZPZW3wgqg
=qlLK
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Oct_2012_23_47_14_+1100_zr/6siix3p8ocXD2--
