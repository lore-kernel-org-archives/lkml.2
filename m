Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab1FANbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:31:39 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:59464 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753250Ab1FANbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:31:36 -0400
Date: Wed, 1 Jun 2011 16:31:30 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        khilman@ti.com, b-cousson@ti.com, paul@pwsan.com
Subject: Re: [PATCH 4/4] mfd: global Suspend and resume support of ehci and
 ohci
Message-ID: <20110601133128.GD2409@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1306934847-6098-1-git-send-email-keshava_mgowda@ti.com>
 <1306934847-6098-2-git-send-email-keshava_mgowda@ti.com>
 <1306934847-6098-3-git-send-email-keshava_mgowda@ti.com>
 <1306934847-6098-4-git-send-email-keshava_mgowda@ti.com>
 <1306934847-6098-5-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
Content-Disposition: inline
In-Reply-To: <1306934847-6098-5-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 01, 2011 at 06:57:27PM +0530, Keshava Munegowda wrote:
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 43de12a..32d19e2 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -146,6 +146,10 @@
>  #define is_ehci_hsic_mode(x)	(x =3D=3D OMAP_EHCI_PORT_MODE_HSIC)
> =20
> =20
> +/* USBHS state bits */
> +#define OMAP_USBHS_INIT		0
> +#define OMAP_USBHS_SUSPEND	4

#define OMAP_USBHS_INIT		BIT(0)
#define OMAP_USBHS_SUSPEND	BIT(1)

???

--=20
balbi

--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN5j8wAAoJEAv8Txj19kN1mFcH/jnNs+3xUWfHhP+T6YoOuuv6
KEhVF4C23qOGKfvIzHU3pb6+paddGOR3A/okvMaQoCvkaHYeSQhKtUiDwdA49QBt
S+g4v2qGOZZ4S0wkdUFcEMMiLDYN+/5ZEE+AiI1PpQ3oSpMJFjPq3CEFhm4hXcDK
AOB8gm9JPk91ki6eajBZm8pAmThq2F3kPaxtEzB29xRPlC7rcYvhs5nKlw++9OjH
nlj9G3BRpGyHuBn73jdiNpoOlq26XMLLXJWjMy0qEakiS5vAcpHnB4SyDEkyDrKU
vfsdM3ZhG1C5M8g2AS4Ta0RCeFN7uSGnG3V1+LPk/+8w+yT+OV8Efkk3sN0gBiY=
=lfcu
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
