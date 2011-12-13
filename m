Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1LMKS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:18:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44778 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab1LMKS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:18:57 -0500
Date: Tue, 13 Dec 2011 11:18:46 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Eric =?iso-8859-15?Q?B=E9nard?= <eric@eukrea.com>
Cc: linux-arm-kernel@lists.infradead.org, Sascha Hauer <kernel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Li Yang <leoli@freescale.com>,
        Felipe Balbi <balbi@ti.com>,
        "open list:FREESCALE USB PER..." <linux-usb@vger.kernel.org>,
        "open list:FREESCALE USB PER..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/19] mxc_udc: add workaround for ENGcm09152 for i.MX25
Message-ID: <20111213101846.GC2619@pengutronix.de>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c3bfwLpm8qysLVxt"
Content-Disposition: inline
In-Reply-To: <1323757911-25217-1-git-send-email-eric@eukrea.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 13, 2011 at 07:31:33AM +0100, Eric B=E9nard wrote:
> this patch gives the possibility to workaround bug ENGcm09152
> on i.MX25 when the hardware workaround is also implemented on
> the board.
> It covers the workaround described on page 42 of the following Errata :
> http://cache.freescale.com/files/dsp/doc/errata/IMX25CE.pdf

Nit: The title of the ENG would help reviewing, like it is preferred to
cite patch titles when mentioning the commit-id.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--c3bfwLpm8qysLVxt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7nJoYACgkQD27XaX1/VRvhpgCeO5eCLJWGf1Mqh1tG7IV1N60o
WlIAnR+7WBUZGAjLmgxBMpEf+zG0hw9n
=/0UZ
-----END PGP SIGNATURE-----

--c3bfwLpm8qysLVxt--
