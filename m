Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab1F0IVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 04:21:23 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:45787 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756231Ab1F0IUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 04:20:45 -0400
Date: Mon, 27 Jun 2011 11:20:37 +0300
From: Felipe Balbi <balbi@ti.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 16/37] Remove unneeded version.h includes (and add where
 needed) for drivers/usb/
Message-ID: <20110627082036.GE2508@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1106240030390.17688@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BQPnanjtCNWHyqYD"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106240030390.17688@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BQPnanjtCNWHyqYD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 24, 2011 at 12:31:43AM +0200, Jesper Juhl wrote:
> It was pointed out by 'make versioncheck' that linux/version.h was not
> always being included where needed and sometimes included needlessly
> in drivers/usb/.
> This patch fixes up the includes.
>=20
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Laurent, I guess Jesper needs your Ack for the uvc part. It looks good
to me, but I'll leave it to you.

> ---
>  drivers/usb/gadget/uvc.h         |    1 +
>  drivers/usb/gadget/uvc_v4l2.c    |    1 -
>  drivers/usb/storage/realtek_cr.c |    1 -
>  3 files changed, 1 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
> index 5b79194..81971fb 100644
> --- a/drivers/usb/gadget/uvc.h
> +++ b/drivers/usb/gadget/uvc.h
> @@ -56,6 +56,7 @@ struct uvc_event
>  #include <linux/usb.h>	/* For usb_endpoint_* */
>  #include <linux/usb/gadget.h>
>  #include <linux/videodev2.h>
> +#include <linux/version.h>
>  #include <media/v4l2-fh.h>
> =20
>  #include "uvc_queue.h"
> diff --git a/drivers/usb/gadget/uvc_v4l2.c b/drivers/usb/gadget/uvc_v4l2.c
> index 5e807f0..a715805 100644
> --- a/drivers/usb/gadget/uvc_v4l2.c
> +++ b/drivers/usb/gadget/uvc_v4l2.c
> @@ -16,7 +16,6 @@
>  #include <linux/errno.h>
>  #include <linux/list.h>
>  #include <linux/mutex.h>
> -#include <linux/version.h>
>  #include <linux/videodev2.h>
>  #include <linux/vmalloc.h>
>  #include <linux/wait.h>
> diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realt=
ek_cr.c
> index d509a4a..fe21104 100644
> --- a/drivers/usb/storage/realtek_cr.c
> +++ b/drivers/usb/storage/realtek_cr.c
> @@ -26,7 +26,6 @@
>  #include <linux/sched.h>
>  #include <linux/workqueue.h>
>  #include <linux/kernel.h>
> -#include <linux/version.h>
> =20
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> --=20
> 1.7.5.2
>=20
>=20
> --=20
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>=20

--=20
balbi

--BQPnanjtCNWHyqYD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOCD1UAAoJEAv8Txj19kN1Kh8IAKPGsOWhj1NsBB8cDcKIWgir
VyY7/yaxPHWr2lkclvSE4rZndQliXMHq2fLqk+RfF8NARLmCDtqatFItJIUnPzoO
S4E5UJFEHJ+V5BgvAhJi9MsZzHn09Yls2bXTZy4JOWKNHNZ0FOddcYCDvqc2gBF7
34Tz77tp2uxP0lLICThyPsah058T2iejKmcDuhIBYeJaGrE1FflsGu/fjEU2Z40P
kaN/u/h6Qwl7yuGWqtX4I42hBF2KcpeyRZ9cUDL1foBgqzqpyYXKozTrJ78YkzTI
DAzPzRVgxto75nW4hrCx1uxSUglQHH38eb7MejNccx4a3N9fu0Gc7Xp3DsW4ikg=
=jo2C
-----END PGP SIGNATURE-----

--BQPnanjtCNWHyqYD--
