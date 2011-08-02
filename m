Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1HBVTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 17:19:35 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:33845 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856Ab1HBVT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 17:19:29 -0400
Date: Wed, 3 Aug 2011 00:19:24 +0300
From: Felipe Balbi <balbi@ti.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH][Resend] Remove unneeded version.h includes (and add
 where needed) for drivers/usb/
Message-ID: <20110802211923.GB10120@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <alpine.LNX.2.00.1108012329380.31999@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1108012329380.31999@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 01, 2011 at 11:33:29PM +0200, Jesper Juhl wrote:
> It was pointed out by 'make versioncheck' that linux/version.h was not
> always being included where needed and sometimes included needlessly
> in drivers/usb/.
> This patch fixes up the includes.
>=20
> For the UVC gadget driver bits, this was ACK'ed by Laurent Pinchart.
>=20
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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

does uvc.h really needs <linux/version.h> ?? Laurent ?

--=20
balbi

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOGnbAAoJEAv8Txj19kN1Q7cIAI6gYGaEE/ML5qZhRWhhUYzy
NfPiKH4h9TN2euOhn+y/OBVsb4Ek67aZb+AevrFfCPD3WKqhk3eAm2KCG8GCV2u5
kENdWEjRKi6AwX8gnyHvl5itoW8EZgbjmE5vukbsEM1Al7dsAlbF0gnTHqffToe7
w44y0f25p7kcZBUTEskGfGqJ1WTjPWy5CK6J2RqnMCsHBXQqQNCJOZNWYuFtIjuD
KWKeN5SiSjTJYZ12WZUYzM64n+4+2Fx62vHO5FxaNZXPON9qFLk7Och3A7lgYEiQ
HA/NL265AKRMzftx9b2aM4E6QcJSwdJdQBptN4vwqibMUS5OkeGEJ6Scb1LOMZk=
=TJ2g
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
