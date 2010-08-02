Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab0HBAeE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:34:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43660 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab0HBAeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:34:01 -0400
Date: Mon, 2 Aug 2010 10:33:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: linux-next: build failure after merge of the final tree (kvm
 tree related)
Message-Id: <20100802103350.9b1b8ff2.sfr@canb.auug.org.au>
In-Reply-To: <20100726142725.fbc5d94e.sfr@canb.auug.org.au>
References: <20100726142725.fbc5d94e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_Aug_2010_10_33_50_+1000_2b=M6JtHd7WoB0uU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Aug_2010_10_33_50_+1000_2b=M6JtHd7WoB0uU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Avi, Marcelo,

On Mon, 26 Jul 2010 14:27:25 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the final tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:
>=20
> cc1: warnings being treated as errors
> arch/powerpc/kvm/44x_tlb.c: In function 'kvmppc_mmu_map':
> arch/powerpc/kvm/44x_tlb.c:319: error: format '%lx' expects type 'long un=
signed int', but argument 2 has type 'gfn_t'
>=20
> Caused by commit 05c07e00b15e00632a2502dcbf253415449e89da ("KVM: Use u64
> for frame data types").  I applied the following patch for today:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 26 Jul 2010 14:25:12 +1000
> Subject: [PATCH] kvm: u64's should be printed with %llx

Ping?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_Aug_2010_10_33_50_+1000_2b=M6JtHd7WoB0uU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMVhJuAAoJEDMEi1NhKgbsO+YH/1G2ZgXeyCQhhOK/ND9bErg5
5fjNEBwn0FnVXrz4ftb+IJAtrjg0pj+FgifdfW25QTUI1G5j8m2MrP7+QEd/Ov9T
CwcE8CnOnfGJe/GIG9i0Xja8bTsdXn2F3iKX4nWZsG83ozPHfRZG2ZY7r68HArak
kyYTZYsMSC3Mtea+rWOYF2BqvJuHYaplV9FVWsdOCi4mqn68brnBsDcZQmh1pdrP
/NqcieN35dh0zPIa0dw8NlPuuNByCq42cOu9JgaUl6naXoeyWzlkH3+hbvakJJVG
qNYBafO8X1r4GVwLiGOSInonunzHolhPbIDSSABqBZN4/8fi223jQ4VYew30VX0=
=gtSr
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Aug_2010_10_33_50_+1000_2b=M6JtHd7WoB0uU--
