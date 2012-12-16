Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2LPWiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 17:38:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51097 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2LPWiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 17:38:14 -0500
Message-ID: <50CE4D47.8000701@pengutronix.de>
Date: Sun, 16 Dec 2012 23:37:59 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>
CC: linux-can@vger.kernel.org, Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] tx/rx LED trigger support
References: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
In-Reply-To: <1355656113-9562-1-git-send-email-fabio.baltieri@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC27E1E032A2A7B1C6D3A8A1B"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC27E1E032A2A7B1C6D3A8A1B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/16/2012 12:08 PM, Fabio Baltieri wrote:
> Hi all,
>=20
> this is a resend of the patch series on tx/rx LEDs trigger.  The patch
> set was put on hold after the latest discussions on Kurt's rename patch=

> due to a missing feature in the LED subsystem, which has been just
> merged in:
>=20
> a8df7b1 leds: add led_trigger_rename function
>=20
> So, as months passed since the latest developments, I'm reposting the
> whole set, rebased on current mainline.  The first patches are the same=

> that were merged in can-next/led-trigger, but there was some (trivial)
> conflict in the rebase.
>=20
> As for the test, I've tried the patch on the current mainline kernel
> with my custom usb-can interface.  For the drivers, I don't have any
> SoC-enabled board anymore, so they have only been compile tested.

Thanks for your work. Can you move patches 8+9 to the beginning, before
touching the device drivers. I'll apply on the Thursday, as I don't have
proper internet now.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigC27E1E032A2A7B1C6D3A8A1B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEUEARECAAYFAlDOTU0ACgkQjTAFq1RaXHPHXgCXdzfvTUOuNjC6z9xJcxKBpH5f
cwCZAR1jIfrqgdyS0ICZU4qjRDxbIhc=
=J5xi
-----END PGP SIGNATURE-----

--------------enigC27E1E032A2A7B1C6D3A8A1B--
