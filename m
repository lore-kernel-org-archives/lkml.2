Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2DUCHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 22:07:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38209 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab2DUCHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 22:07:47 -0400
Date: Sat, 21 Apr 2012 12:07:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Howells <dhowells@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org
Subject: Re: [patch 03/18] smp: Add generic smpboot facility
Message-Id: <20120421120723.4b476ea39d18660e3401ee0c@canb.auug.org.au>
In-Reply-To: <20120420124557.035417523@linutronix.de>
References: <20120420122120.097464672@linutronix.de>
	<20120420124557.035417523@linutronix.de>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__21_Apr_2012_12_07_23_+1000_uBXE8aLppzixFTNZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__21_Apr_2012_12_07_23_+1000_uBXE8aLppzixFTNZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Fri, 20 Apr 2012 13:05:44 -0000 Thomas Gleixner <tglx@linutronix.de> wro=
te:
>
> Index: linux-2.6/kernel/smpboot.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null
> +++ linux-2.6/kernel/smpboot.c
> @@ -0,0 +1,12 @@
> +/*
> + * Common SMP CPU bringup/teardown functions
> + */
> +
> +#include "smpboot.h"
> +
> +/**
> + * smpboot_prepare - generic smpboot preparation
> + */
> +int __cpuinit smpboot_prepare(unsigned int cpu)

Where does this get its definition of __cpuinit?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__21_Apr_2012_12_07_23_+1000_uBXE8aLppzixFTNZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPkhZbAAoJEECxmPOUX5FEtSAQAKXKrNo95ESWc4dgyj+ydXnX
Ri2oHyD1EOivVRSdQ16P8i3XshptzqZzv4U+TorrrUroutX7YehKT6BVVFVtSGze
yrSXVllgfRTQqF0sC3eSDHt6Bcj++hNtl3U+Che+cWs4CHCWTF4kjAUwHG7R0l+F
Rv8ZHBB8i51bZQh4eEmJ5LcZTCXRmUcMbcCmg++23TGWss1v9cmtyBO32Vz0fmHn
XcSP2nzeLt0iw8VmmHUE3NgirYRhArcjDFEBVwh2CkUeF183vafpEh6ZSUaqne5q
7KMZk6KivXgyqBA2hWMN8rss6q9jU4NKvNLlW5js6ON4iQoiOY7PhuTxk/d1rl2U
CrNamjU61eWfXaETMvWQr3D/w86+61dsRnIfa1Sdp1BZEx6CPv+N1d6HVplvvxgM
NHGDfkW/O01Tee8aocy5wFG4w7u+DnG4EgfVM6IPb9yYN3fjzeA6Ng3hspRJuEcH
Q3e+rxN9lcDSHFBeWlbP2w5++nrCRzQDvf8SENZEl64MOCmscIzFKGQYJxTOc1Gh
eMdZhMnIqBQT5w2RVH8cn5ASgj0NMk2IZJnVYia0Y6zn1m8kB2VnSiEEBv6kirKA
fD6Kz8woTzSj52A2J6isEkP9Tj6VpolYFNH+xS+fxGEfs4jaLPwEhII14i1cBVV3
7AwIG0Ia/G8uOiEo56cu
=5xGM
-----END PGP SIGNATURE-----

--Signature=_Sat__21_Apr_2012_12_07_23_+1000_uBXE8aLppzixFTNZ--
