Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab1CaNXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:23:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57115 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1CaNXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:23:37 -0400
Date: Thu, 31 Mar 2011 15:23:28 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: John Williams <john.williams@petalogix.com>
Cc: Michal Simek <monstr@monstr.eu>, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        hjk@linutronix.de, gregkh@suse.de
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
Message-ID: <20110331132328.GB2202@pengutronix.de>
References: <1301574600-4861-1-git-send-email-monstr@monstr.eu>
 <1301574600-4861-2-git-send-email-monstr@monstr.eu>
 <20110331124925.GA2202@pengutronix.de>
 <AANLkTi=sG6oVNifwLLi8jjKQXjR6kXZx43NxtFfoPumy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
Content-Disposition: inline
In-Reply-To: <AANLkTi=sG6oVNifwLLi8jjKQXjR6kXZx43NxtFfoPumy@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


>    Maybe I misunderstand you, in my view it is the responsibility of <ven=
dor>
>    to create their DTS files to indicate they want <special-card1> to bin=
d to
>    generic-uio.

Device tree is a OS-neutral hardware description language. "generic-uio"
is neither OS-neutral nor a hardware description. devicetree.org has
more information about this.

>    Our use-case is pretty clear, in FPGA-based systems it is common to cr=
eate
>    arbitrary devices that developers just want to control from userspace,
>    with simple IRQ and IO capabilities (DMA can come later :). =EF=BF=BDT=
hey don't
>    need to bind to other kernel APIs or subsystems, and don't want to inv=
est
>    in one-off kernel drivers that simply will never go upstream.

For that, the new_compatible-file would be suitable, I think.

>    UIO is perfect, and simply tagging the device as generic-uio in the DT=
S is
>    so simple, clean, and elegant.

Simple, yes (I do understand I wrote the first approach ;)) . Elegant,
not really, because it breaks core conventions of the device tree. For
your case it is a very conveniant hack, but it is still a hack.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2UgFAACgkQD27XaX1/VRuEugCgjLO3U70anQaSTbTP6iHZhLe0
53AAoMLdNVxGaWW5c/OogxM1oGWLO7Lv
=HpOQ
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
