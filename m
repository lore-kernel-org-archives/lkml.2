Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab1JJGKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:10:48 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:55954 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752420Ab1JJGKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:10:46 -0400
Date: Mon, 10 Oct 2011 09:10:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 17/30] usb/musb: allow building USB_MUSB_TUSB6010 as a
 module
Message-ID: <20111010061041.GG31707@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-18-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oOB74oR0WcNeq9Zb"
Content-Disposition: inline
In-Reply-To: <1317566760-25681-18-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oOB74oR0WcNeq9Zb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 02, 2011 at 04:45:47PM +0200, Arnd Bergmann wrote:
> Commit 1376d92f9 "usb: musb: allow musb and glue layers to be modules"
> made the USB_MUSB_TUSB6010 option modular, but actually building
> the driver as a module does not work, so various randconfig builds
> actually fail. This changes all code that depends on the
> option to also check for modular builds, and exports the necessary
> symbols.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Felipe Balbi <balbi@ti.com>

applied, thanks

--=20
balbi

--oOB74oR0WcNeq9Zb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOkoxhAAoJEAv8Txj19kN1Y5wH/AmWmLlsjobGLBRA52RUI0eE
r3jNu2xbK/xp4Hw1ytfx0zMDFOL3l9GAaRr8fTpDNuAHQONSHw14u8g9OAx50m2B
fx1rTm0lsV0ZCCZwrCgJEPOWk2uUjRYQWZm8rhKJ52syOJim27q/p6ES4iEacZdZ
J5OQzFBmzXrgBhMFGpb9qbiJNS+3kzNJGOH5EvWle3lN008pL4h6Onfaid0XmPqC
skDxmgbH25H/L4+mumY/U5VemigsjEKEzyvIxDX9dMA9vNPtDLaWS1yIDFdmparu
bnI1G7FF8q31hatKUQL0PfHyUWfCsI7GTvpAE9f7NB8wrR4K5bWgoyvcex+HBLM=
=Kd4Z
-----END PGP SIGNATURE-----

--oOB74oR0WcNeq9Zb--
