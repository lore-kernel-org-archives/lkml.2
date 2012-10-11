Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2JKCsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:48:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35638 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab2JKCr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:47:59 -0400
Date: Thu, 11 Oct 2012 13:47:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tabi Timur-B04825 <B04825@freescale.com>
Cc: Alexander Graf <agraf@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        David Howells <dhowells@redhat.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: manual merge of the kvm-ppc tree with the
 powerpc-merge tree
Message-Id: <20121011134754.2e2cbb24842fa991e61cf97c@canb.auug.org.au>
In-Reply-To: <6AE080B68D46FC4BA2D2769E68D765B7080FA8F8@039-SN2MPN1-023.039d.mgd.msft.net>
References: <20121011121841.1b946f996cba995d9a5a2be7@canb.auug.org.au>
	<6AE080B68D46FC4BA2D2769E68D765B7080FA8F8@039-SN2MPN1-023.039d.mgd.msft.net>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Oct_2012_13_47_54_+1100_D4i8oI1jWMbaZHyJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Oct_2012_13_47_54_+1100_D4i8oI1jWMbaZHyJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Oct 2012 01:47:13 +0000 Tabi Timur-B04825 <B04825@freescale.com>=
 wrote:
>
> On Wed, Oct 10, 2012 at 8:18 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> >  arch/powerpc/include/asm/epapr_hcalls.h      |  511 ------------------=
--------
> >  arch/powerpc/include/uapi/asm/Kbuild         |    1 +
> >  arch/powerpc/include/uapi/asm/epapr_hcalls.h |  511 ++++++++++++++++++=
++++++++
>=20
> What is include/uapi?  epapr_hcalls.h is not a user-space header file.
>  I don't remember seeing the original patch which moved it, so I don't
> know where this comes from.

Commit 549d62d889b4 ("KVM: PPC: use definitions in epapr header
for hcalls") from the kvm-ppc tree added an include of asm/epapr_hcall.h
to the user visible part of asm/kvm_para.h so asm/epapr_hcall.h became a
user visible header file.

The UAPI changes are moving the user visible parts of export header files
into a separate include directory called uapi.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Oct_2012_13_47_54_+1100_D4i8oI1jWMbaZHyJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQdjNaAAoJEECxmPOUX5FEFdgP/i76k2wMBk/pXJdDyK/dgfrb
GO5fsKE6Gt3/fvLC2pG1qplyexbqj1kGfhSSVFVVV3L062tPRFfYgjNp0+Bxl2Pa
Ds3R20SBG2KJIXwdki41s5nRonXFfPKGxVUX22/NSygpJU84Fdt2+yBg5hVcB39s
yEfToFoTR9fFogi0qANCL/nEn4OsvfXYpqyWPlkw7gnCeBNkhS+fBUVAZD1RMLSq
1YUV3jZnrYR8OxSdT/Q3ha1K2HtsVY4+e01AugpXPfnszGmIlQrhWyHIveVV+f6D
wA2mCwVMYgZkH6N/yA1yTj7eoZ9CZJ2EiOzahjFaXG2v2KJ2cdV+EfRDAGmM8FuA
dVV64X30hV0HtXLVmScRnTSb04PudD3dovqiRnzipJ0a4qXq+SaQy/r8JlP+K0vj
O0ghWHK0O2w7E6Ya0Ec63gJCeVdip1yWvfmfshJ5cV3ggoUaqyl8oTAYVuHkx0Bv
+rf7sW9XSWi+MoTaukNq1YZMKf8YzzGfmdXmQPLwsvuHiugYUqkDSlpDLcxCCKxc
8+mjIOeklU3MWKHENMVKLcunjG/WrDlZCn1aAyqXkO+skPh+KFm3BBIceqaQWgKU
hs2do0K/op/Zd3Lh5/6wsZP9KucfivY4Kaja6M8Rf3+BeyNPOYLrDe2KRQ34H2+q
mmxzfRNQVsqly7MBJfrG
=dAcz
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Oct_2012_13_47_54_+1100_D4i8oI1jWMbaZHyJ--
