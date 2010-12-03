Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab0LCPul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:50:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47210 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab0LCPuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:50:40 -0500
Date: Fri, 3 Dec 2010 16:50:31 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Stefan Roese <sr@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, John Williams <john.williams@petalogix.com>,
        gregkh@suse.de,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        hjk@linutronix.de, Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: UIO / of_genirq driver
Message-ID: <20101203155031.GC5636@pengutronix.de>
References: <1d3f23371001272313i62fc9158se4cd9173f196fb12@mail.gmail.com>
 <20100128104545.GA3105@pengutronix.de>
 <201012031643.31428.sr@denx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WfZ7S8PLGjBY9Voh"
Content-Disposition: inline
In-Reply-To: <201012031643.31428.sr@denx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WfZ7S8PLGjBY9Voh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Is there any update on this in the meantime? Do you know of any plans to =
re-
> work/-push this patchset? Just checking...

I had another look recently; I wouldn't like to just copy/paste the
"new_id"-mechanism from PCI because the code would then exist three
times in the kernel (PCMCIA being the third user I am aware of). I
wondered if it was feasible to make the "new-id"-code generic and make
those subsystems just use it. I haven't started working on it, though.

Kind regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--WfZ7S8PLGjBY9Voh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkz5EccACgkQD27XaX1/VRuMWQCdF8iOdjY8DK3GeACA1YbVY/qX
oVkAniWPpN9kz0GSvHQJuDUZ18Jf0OgD
=8Ygy
-----END PGP SIGNATURE-----

--WfZ7S8PLGjBY9Voh--
