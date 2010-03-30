Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0C3DVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 23:21:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56260 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab0C3DVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 23:21:54 -0400
Date: Tue, 30 Mar 2010 14:21:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 14/17] input: update gfp/slab.h includes
Message-Id: <20100330142148.2ac3fc0e.sfr@canb.auug.org.au>
In-Reply-To: <1269885165-18617-15-git-send-email-tj@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-15-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__30_Mar_2010_14_21_48_+1100_pngSdui=qEdkgfkF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Mar_2010_14_21_48_+1100_pngSdui=qEdkgfkF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Tue, 30 Mar 2010 02:52:42 +0900 Tejun Heo <tj@kernel.org> wrote:
>
> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> gfp.h or slab.h is included as necessary.
>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/char/sysrq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
> index 532c56c..593562d 100644
> --- a/drivers/char/sysrq.c
> +++ b/drivers/char/sysrq.c
> @@ -41,7 +41,7 @@
>  #include <linux/hrtimer.h>
>  #include <linux/oom.h>
>  #include <linux/input.h>
> -#include <linux/gfp.h>
> +#include <linux/slab.h>
> =20
>  #include <asm/ptrace.h>
>  #include <asm/irq_regs.h>

This patch does not apply to the input tree.  That tree does not have the=20
#include <linux/gfp.h>
line (your tree (slabh) adds that later in the linux-next cycle).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__30_Mar_2010_14_21_48_+1100_pngSdui=qEdkgfkF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuxbkwACgkQjjKRsyhoI8w+mwCaA2GOymsvN4zJCxRzTGg74Qea
NcAAn2A7WJ3kkLLHc42DDmKcC1Iu1RIr
=H/d/
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Mar_2010_14_21_48_+1100_pngSdui=qEdkgfkF--
