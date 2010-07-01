Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab0GAMe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 08:34:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53595 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab0GAMe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 08:34:27 -0400
Date: Thu, 1 Jul 2010 14:34:26 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
       STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
       l.fu@pengutronix.de
Subject: Re: [PATCHv3 1/3] mfd: add STMPE I/O Expander support
Message-ID: <20100701123426.GD4092@pengutronix.de>
Mail-Followup-To: Rabin Vincent <rabin.vincent@stericsson.com>,
	linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
	STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
	l.fu@pengutronix.de
References: <20100627235515.GB9264@sortiz-mobl>
 <1277985648-28468-1-git-send-email-rabin.vincent@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9dgjiU4MmWPVapMU"
Content-Disposition: inline
In-Reply-To: <1277985648-28468-1-git-send-email-rabin.vincent@stericsson.com>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:29:30 up  6:17, 12 users,  load average: 0.12, 0.09, 0.02
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:250:baff:feac:3723
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9dgjiU4MmWPVapMU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rabin,

On Thu, Jul 01, 2010 at 05:30:46PM +0530, Rabin Vincent wrote:
> Add support for the STMPE family of I/O Expanders from
> STMicroelectronics.  These devices include upto 24 gpios and a varying
> selection of blocks, including PWM, keypad, and touchscreen controllers.
> This patch adds the MFD core.
>=20
> [l.fu@pengutronix.de: fix stmpe811 enable hook]
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> ---
>=20
> CHANGELOG (for the whole set)
>=20
> v2 -> v3:
>   - Locking fixes
>   - Expanded Kconfig description
>   - Moved stmpe-devices.c content into stmpe.c
>   - Moved debug ifdefs to header
>   - Folded in Luotao Fu's one-liner fix for STMPE811 enable
>   - Folded in Luotao Fu's one-liner fix for stmpe-gpio input
>     direction
>=20
> v1 -> v2
>   - Variant data to support other STMPE* variants
>   - Enable/disable API
>   - GPIO setup/remove callbacks
>   - pdata made optional for GPIO
>   - Platform specifies which blocks it wants to use
>   - IRQ invert polarity option
>   - STMPE811 support (needs testing)
>=20
>  drivers/mfd/Kconfig       |   23 ++
>  drivers/mfd/Makefile      |    1 +
>  drivers/mfd/stmpe.c       |  915 +++++++++++++++++++++++++++++++++++++++=
++++++
>  drivers/mfd/stmpe.h       |  176 +++++++++
>  include/linux/mfd/stmpe.h |  154 ++++++++
>  5 files changed, 1269 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/stmpe.c
>  create mode 100644 drivers/mfd/stmpe.h
>  create mode 100644 include/linux/mfd/stmpe.h
>=20

It might be great if you could also fold the patch
35df3fb7291f7b0281f0fce27a4e9cde0ea0b32f
mfd/stmpexxx: add touchscreen platform data
https://patchwork.kernel.org/patch/107833/
into this serie too. It simply makes little sense that the ts platform data
should be added in a separate patch, while keypad and gpio platformdata
stuffes are included in this patch.

otherwise:
Acked-by: Luotao Fu <l.fu@pengutronix.de>

cheers
Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--9dgjiU4MmWPVapMU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwsi1IACgkQkLuxfMCkDTYxIwCcDUxRSlkWP3VL4YuibjldRWNi
UeoAn2MKGPSvcGZhw4uIAX8BwkYpwmTb
=W/M7
-----END PGP SIGNATURE-----

--9dgjiU4MmWPVapMU--
