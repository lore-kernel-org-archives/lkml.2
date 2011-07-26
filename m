Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1GZOOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:14:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41799 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1GZOOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:14:24 -0400
Date: Tue, 26 Jul 2011 16:14:15 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Dan.Morav@nuvoton.com
Cc: linux-kernel@vger.kernel.org, debora@linux.vnet.ibm.com,
        srajiv@linux.vnet.ibm.com, m.selhorst@sirrix.com,
        Leonid.Azriel@nuvoton.com, Guy.Pavlov@nuvoton.com
Subject: Re: [PATCH] TPM Nuvoton I2C driver, kernel 3.0
Message-ID: <20110726141415.GA31162@pengutronix.de>
References: <8F2A7B0931C16B4C99DDA3B283A436301401CFB6@ntilml01.nuvoton.com>
 <8F2A7B0931C16B4C99DDA3B283A43630215E501F@ntilml01.nuvoton.com>
 <8F2A7B0931C16B4C99DDA3B283A4363059782006@ntilml01.nuvoton.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <8F2A7B0931C16B4C99DDA3B283A4363059782006@ntilml01.nuvoton.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 25, 2011 at 10:25:30AM +0300, Dan.Morav@nuvoton.com wrote:

> Below are the additions for WPCT301/NPCT501 Nuvoton Technology TPM with I=
2C
> interface device driver. This driver uses Linux I2C bus driver to interfa=
ce
> with the I2C bus and Linux TPM driver (tpm.ko), to export the standard Li=
nux
> TPM interface. This driver requires an I2C bus driver and TPM driver (tpm=
=2Eko)
> to be loaded prior to its loading. This driver tested on Linux kernel ver=
sion
> 3.0-rc6 on an x86 based platform and Linux kernel version 2.6.36.3 on an =
ARM
> platform.

NACK. Please address the issues I mentioned last time.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4uy7cACgkQD27XaX1/VRvpTgCgsu1cg26xsmuvydYdPapBp5+4
5IwAn0BER55qhuXTcuPlD7g9/CC3fAyV
=jIQ5
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
