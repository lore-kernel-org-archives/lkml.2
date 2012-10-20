Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab2JTCbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 22:31:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47600 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757790Ab2JTCbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 22:31:32 -0400
Date: Sat, 20 Oct 2012 13:31:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ralf Baechle <ralf@linux-mips.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (tip/s390 trees related)
Message-Id: <20121020133102.cdb946cbbb7b80902925760a@canb.auug.org.au>
In-Reply-To: <20121019223938.GB12658@gmail.com>
References: <20121018172201.b81dcc8fe40868256f532364@canb.auug.org.au>
	<20121018150209.GB17439@linux-mips.org>
	<1350683562.2768.78.camel@twins>
	<20121019223938.GB12658@gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__20_Oct_2012_13_31_02_+1100_ArwEPBD+kR12B2wf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__20_Oct_2012_13_31_02_+1100_ArwEPBD+kR12B2wf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Sat, 20 Oct 2012 00:39:38 +0200 Ingo Molnar <mingo@kernel.org> wrote:
>
> From 7fc4d49214dba401f4b92ed62da60a5b257a653a Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@kernel.org>
> Date: Sat, 20 Oct 2012 00:33:01 +0200
> Subject: [PATCH] MIPS/thp: Fix update_mmu_cache() cache call
>=20
> As per recent upstream commit:
>=20
>   b113da65785d mm: Add and use update_mmu_cache_pmd() in transparent huge=
 page code.
>=20
> The call in do_huge_pmd_prot_none() needs to call update_mmu_cache_pmd()
> as well.
>=20
> This resolves a MIPS build error triggered on linux-next.
>=20
> Reported-by: Ralf Baechle <ralf@linux-mips.org>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>

Just a small nit - I didn't actually report this one, just Ralf did.

Thanks for the fixes.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__20_Oct_2012_13_31_02_+1100_ArwEPBD+kR12B2wf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQggzmAAoJEECxmPOUX5FEOqYP/0P2Onm/WOOz9WF1pajb94AT
YDtyLGgnsXmtF1/vCfQWawJGgGDvL3w32oNL9zUI80uDB+2vntaq0c2c7yYI8Hqm
oeDpd+oEK0ofYsk2qr6e23Idc16E0Np1mG6RW2A9H7wJDw4TT1tQcF1mcmVDXDBr
Zv+culXDAUYl/xrMbZ8afQL/W+2ouyLrmg35r4oC1O6/o4O9wn+O/dLEDIrD7yxC
nDHrTA9KXtlQHz0Fqqdqbp4UeeghLUyb3ho2C0s+o5i2yWPMujIefAW+AA2KHgXM
OQG+QAC4e5UvEs0gig4PFg6cdlegQT8259tdFHSCP/Xzkj89+b2yZ89eehlH4GSg
7eC0HM0j74zWTVMu2Ets4U7HtbHusU6UEfj3+XQnjsCCt/m7ahYxegMkwB1O/WQL
aiaZTDqqD69VgDxi3oYwATf6OBAoyrxklQtkQoHx7/1oOvvI17cHhkgkarCP8P2j
MlsJ5oS0MX8xpaPX6dPYtOLgM94I+eJqui1ZbQyLidF9PuF1SjZpItujaafSXGJh
RlGBDDllTMD/4j3JoO7ZjnfVR4eldlQNOa68bMIdlqm4DvyjyBRu2ptjITEgWivT
Jb+kwc2rCz/xIjhsBxCo/Ld93nA+dJ78BrRFT6bcnpTOGyeXPpJkXj6R/L/0DVH6
1JZdSuu/G73HZ7BUsNLI
=vf3r
-----END PGP SIGNATURE-----

--Signature=_Sat__20_Oct_2012_13_31_02_+1100_ArwEPBD+kR12B2wf--
