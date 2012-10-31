Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807Ab2JaVeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:34:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41824 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759980Ab2JaVeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:34:13 -0400
Date: Thu, 1 Nov 2012 08:34:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: Please add swiotlb.git tree to linux-next
Message-Id: <20121101083403.30dec16fa242e81f9761529f@canb.auug.org.au>
In-Reply-To: <20121031125929.GA27144@phenom.dumpdata.com>
References: <20121031125929.GA27144@phenom.dumpdata.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Nov_2012_08_34_03_+1100_smMisBtzB07G1TQ6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Nov_2012_08_34_03_+1100_smMisBtzB07G1TQ6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Wed, 31 Oct 2012 08:59:29 -0400 Konrad Rzeszutek Wilk <konrad.wilk@oracl=
e.com> wrote:
>
> Please add:
>=20
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb.git #linux-=
next
>=20
> in the linux-next system. The branch is 'linux-next'. This would be the
> tree and branch used for maintaining the swiotlb and its different users.
>=20
> The Ack's have already been given per this commit:
>=20
> commit 6e28b761c5020c4bc943c7e38da86bea8af77d5c
> Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date:   Mon Oct 8 16:28:05 2012 -0700
>=20
>     MAINTAINERS: add Konrad as the SWIOTLB maintainer
>    =20
>     Now that I've an IA64 box on top of the other boxes (IBM with Calgary=
-X,
>     Intel VT-d, AMD Vi, and AMD GART - that can use SWIOTLB as fallback) =
I can
>     reliably do regression testing.
>    =20
>     Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>     Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>     Cc: Ingo Molnar <mingo@elte.hu>
>     Acked-by: "H. Peter Anvin" <hpa@zytor.com>
>     Cc: Thomas Gleixner <tglx@linutronix.de>
>     Acked-by: Tony Luck <tony.luck@intel.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Thu__1_Nov_2012_08_34_03_+1100_smMisBtzB07G1TQ6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQkZlLAAoJEECxmPOUX5FEu/4P+wRIwr3eqAhuspdhOTlsjPUa
3HTLkznDWhwgLdcNJnkSkPK8GSzhDMBW83rvfByt2GM67F4CgikAp2Q+GmfDIoxE
9GMHqrHGf4owY4CMXqGFi36zVCnkLyaSMow3UBxeVKkNnQMZQK764Ftitcqf1fFU
b4CS+xMcP5EjFYmroD5N1Odc/NRo/d+blg/LbHlofQcFte2PM5Dkv/pY7jMPVTjC
jNMuv07j5hZTFYFGgCK7PH6euaULoYdd/2iMoIVH66/OayubntDWV/DVT+7J5x52
XqfLtSPXQXHr0QH/H0ieCSGRCeKg6zvjdeemu+AiRdL7F6tw+eIiBijZwDWNnS0l
U8brxqLEPE9rYWqGBxdGNfeQuaud3CYWhbrIudKoxlLNu4c0uN98huBIVErcOrLi
ae/+kvy141yvwN4HlauZfjyS4ba6z7rbKaRhUCWNcBgTT/s+dqww6Hp4kRDAjvpF
6Sc9uN31TR4bOB6HGBAGEjhSrFX9Bz4HijU7jKzMiJFhqFxhoj7iho/GsXFbhG/m
Y7ZE8XvkVSv+97HGwMHaT+rhJ//bjABaTXcG0jrRmH3J26J2xhQVJxoc0dN7axt0
Mbd8smMzYG7ed6/TNoGTaxc1VcNob41Hp+c7T8Ea9888S7AZePh5j355vK9Jh/M5
8Glar1c9jAcqoOeiIDux
=ANYG
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Nov_2012_08_34_03_+1100_smMisBtzB07G1TQ6--
