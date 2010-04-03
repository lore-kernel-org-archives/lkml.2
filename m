Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0DCBgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 21:36:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37775 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0DCBgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 21:36:40 -0400
Date: Sat, 3 Apr 2010 12:36:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 05/17] staging: update gfp/slab.h includes
Message-Id: <20100403123629.d1148066.sfr@canb.auug.org.au>
In-Reply-To: <1269885165-18617-6-git-send-email-tj@kernel.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-6-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__3_Apr_2010_12_36_29_+1100_MbNpZaX5I6GoqhmO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__3_Apr_2010_12_36_29_+1100_MbNpZaX5I6GoqhmO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Tue, 30 Mar 2010 02:52:33 +0900 Tejun Heo <tj@kernel.org> wrote:
>
>  drivers/staging/comedi/drivers/quatech_daqp_cs.c |    1 +
>  drivers/staging/otus/usbdrv.h                    |    1 +

The changes to those two files are fixes mainline so should go into your
slabh tree.

>  drivers/staging/tm6000/tm6000-alsa.c             |    1 +
>  drivers/staging/tm6000/tm6000-cards.c            |    1 +
>  drivers/staging/tm6000/tm6000-core.c             |    1 +
>  drivers/staging/tm6000/tm6000-dvb.c              |    1 +

These four files are intreoduced in the v4l-dvb tree, so this part should
go to Mauro Carvalho Chehab <mchehab@infradead.org> (cc'd).

>  6 files changed, 6 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/s=
taging/comedi/drivers/quatech_daqp_cs.c
> index 92d7b72..ab00846 100644
> --- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
> +++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
> @@ -49,6 +49,7 @@ Devices: [Quatech] DAQP-208 (daqp), DAQP-308
> =20
>  #include "../comedidev.h"
>  #include <linux/semaphore.h>
> +#include <linux/slab.h>
> =20
>  #include <pcmcia/cs_types.h>
>  #include <pcmcia/cs.h>
> diff --git a/drivers/staging/otus/usbdrv.h b/drivers/staging/otus/usbdrv.h
> index 330d1b9..7e66c2d 100644
> --- a/drivers/staging/otus/usbdrv.h
> +++ b/drivers/staging/otus/usbdrv.h
> @@ -38,6 +38,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/wireless.h>
>  #include <linux/if_arp.h>
> +#include <linux/slab.h>
>  #include <linux/io.h>
> =20
>  #include "zdcompat.h"
> diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm600=
0/tm6000-alsa.c
> index bc89f9d..3404516 100644
> --- a/drivers/staging/tm6000/tm6000-alsa.c
> +++ b/drivers/staging/tm6000/tm6000-alsa.c
> @@ -15,6 +15,7 @@
>  #include <linux/device.h>
>  #include <linux/interrupt.h>
>  #include <linux/usb.h>
> +#include <linux/slab.h>
> =20
>  #include <asm/delay.h>
>  #include <sound/core.h>
> diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm60=
00/tm6000-cards.c
> index 2053008..2935533 100644
> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c
> @@ -24,6 +24,7 @@
>  #include <linux/i2c.h>
>  #include <linux/usb.h>
>  #include <linux/version.h>
> +#include <linux/slab.h>
>  #include <media/v4l2-common.h>
>  #include <media/tuner.h>
>  #include <media/tvaudio.h>
> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm600=
0/tm6000-core.c
> index d9cade0..2ae7ae0 100644
> --- a/drivers/staging/tm6000/tm6000-core.c
> +++ b/drivers/staging/tm6000/tm6000-core.c
> @@ -22,6 +22,7 @@
> =20
>  #include <linux/module.h>
>  #include <linux/kernel.h>
> +#include <linux/slab.h>
>  #include <linux/usb.h>
>  #include <linux/i2c.h>
>  #include "tm6000.h"
> diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000=
/tm6000-dvb.c
> index 1072206..dfba5e6 100644
> --- a/drivers/staging/tm6000/tm6000-dvb.c
> +++ b/drivers/staging/tm6000/tm6000-dvb.c
> @@ -18,6 +18,7 @@
>   */
> =20
>  #include <linux/kernel.h>
> +#include <linux/slab.h>
>  #include <linux/usb.h>
> =20
>  #include "tm6000.h"
> --=20
> 1.6.4.2


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__3_Apr_2010_12_36_29_+1100_MbNpZaX5I6GoqhmO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku2m50ACgkQjjKRsyhoI8x+BwCgre0MMtiOFhmSCFjIRh49C96J
9IwAn0uNkzpW0YfYqL2jgPUzQGIEhu5Y
=T1dg
-----END PGP SIGNATURE-----

--Signature=_Sat__3_Apr_2010_12_36_29_+1100_MbNpZaX5I6GoqhmO--
