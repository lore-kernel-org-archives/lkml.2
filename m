Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab2DUCUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 22:20:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41255 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2DUCUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 22:20:52 -0400
Date: Sat, 21 Apr 2012 12:20:41 +1000
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
Subject: Re: [patch 04/18] smp: Provide generic idle thread allocation
Message-Id: <20120421122041.f7aca15382148d77e068507d@canb.auug.org.au>
In-Reply-To: <20120420124557.102478630@linutronix.de>
References: <20120420122120.097464672@linutronix.de>
	<20120420124557.102478630@linutronix.de>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__21_Apr_2012_12_20_41_+1000_WCd+V+2VKKG=cH52"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__21_Apr_2012_12_20_41_+1000_WCd+V+2VKKG=cH52
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Fri, 20 Apr 2012 13:05:45 -0000 Thomas Gleixner <tglx@linutronix.de> wro=
te:
>
> Index: linux-2.6/kernel/smpboot.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/smpboot.c
> +++ linux-2.6/kernel/smpboot.c
> @@ -1,12 +1,95 @@
>  /*
>   * Common SMP CPU bringup/teardown functions
>   */
> +#include <linux/err.h>
> +#include <linux/smp.h>
> +#include <linux/sched.h>
> +#include <linux/percpu.h>
> +#include <linux/workqueue.h>

#include <linux/init.h>	/* should have been in previous patch */
#include <linux/kernel.h>
#include <linux/completion.h>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__21_Apr_2012_12_20_41_+1000_WCd+V+2VKKG=cH52
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPkhl5AAoJEECxmPOUX5FE+9IP/jmoXEWl394S4asygtz/0jab
RL32eJ5+91IOMTnnhva1PUX0PEJOK6d7v03yLDzfJ9Xe77fFUxFx/RxXhZNn6uEP
ImJk92WBcu0Om8IkiInLwNL9EuV7/FwteUGzK4W0YLOizOgqD7N8K6JnVsZ7z08C
kCs0Z00NBe/qNagQhogxO8S9UAA+8CORYpsUpx3PkbwkwoKEkNI9ST1cYtUXN9aY
N+E0FKb1I/0zvbanJJpK7sMqLC8ZsslWnhfRJFL2QEzXT3CYhp8eywnQlN1cfAkN
qFK9VFa1dAHqM41uvviJHfpv118z8/m9XbG1vfxg6qHoFxBqKYu6gH91n/NvjKeO
gcS2lJ2zCEn5aORIM3egXpQrfK1/zevoCSkzXg9BYC7ywRUCtASz0IONWUckAV0J
TNT9dhsLROSXFWceDmkU7ODGEMZprl/2EmNxLVCnS5AWLntgvcRs3D2PCpHK3/MN
VtGHShg8PxSqYno9jo7sNs+Coe+6NXHSXPD/HtB8kRoNoY002D63bsxdLB56LnkO
mucC+bF8fzGCG80akgygBronYb284LWdzpCWtLT6qmbYvhfWJojdJ8/TIJoxWYAA
zT3kZKE/dGwBH0XCejhpTIqNMTrfAHZ39pGlcxG5EBZjqa9001SgXwQ9v9YhLjma
aenuCGfuZKPuKpY5wuzp
=R/rm
-----END PGP SIGNATURE-----

--Signature=_Sat__21_Apr_2012_12_20_41_+1000_WCd+V+2VKKG=cH52--
