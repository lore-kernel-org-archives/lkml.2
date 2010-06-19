Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab0FSNuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 09:50:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49237 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab0FSNuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 09:50:20 -0400
Date: Sat, 19 Jun 2010 15:50:16 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>, linux-kernel@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com,
       Linus Walleij <linus.walleij@stericsson.com>, l.fu@pengutronix.de
Subject: Re: [PATCH 1/3] mfd: add STMPExxxx I/O Expander support
Message-ID: <20100619135016.GA6825@pengutronix.de>
Mail-Followup-To: Samuel Ortiz <sameo@linux.intel.com>,
	Rabin Vincent <rabin.vincent@stericsson.com>,
	linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
	Linus Walleij <linus.walleij@stericsson.com>, l.fu@pengutronix.de
References: <1275308236-1775-1-git-send-email-rabin.vincent@stericsson.com> <20100618234222.GL3582@sortiz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <20100618234222.GL3582@sortiz.org>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:42:10 up 12 days,  6:10, 18 users,  load average: 1.06, 2.34,
	2.28
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Jun 19, 2010 at 01:42:24AM +0200, Samuel Ortiz wrote:
> Hi Rabin,
>=20
> On Mon, May 31, 2010 at 05:47:14PM +0530, Rabin Vincent wrote:
> > Add support for the STMPExxxx family of I/O Expanders from
> > STMicroelectronics.  These devices include upto 24 gpios, a PWM
> > controller, and a keypad controller.  This patch adds the MFD core.
> The patchset looks fairly good, but before merging it I'd like to know of=
 we
> could merge it with this one:
> https://patchwork.kernel.org/patch/106173/
>=20
> I don't know enough about the hardware, and although the register layouts=
 don't
> look like they have much in common, I'd like to know from the actual HW
> manufacturer (i.e. you :)) if there's something we can do here.
> I'm cc'ing Luotao here so that we get his input as well.
>=20

hmm, I took a quick look into the core driver. The register layout
seems, as Samuel mentioned, quite different. However, the r/w
functionalities and irq handling are quite the same. For now I'd say
that should be possible to merge the stuff.

cheers
Luotao Fu

--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkwcyxgACgkQkLuxfMCkDTY+oQCfUiExlh9jNx6srAiHufYsj5sQ
W1QAmwbfUPtVKfw5xnApwyeS92HMygIg
=vjN6
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
