Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab1AES5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 13:57:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33510 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1AES5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 13:57:18 -0500
Date: Wed, 5 Jan 2011 19:57:16 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 0/2] Annotate gpio-configuration with __must_check
Message-ID: <20110105185716.GA6753@pengutronix.de>
References: <1294159868-4989-1-git-send-email-w.sang@pengutronix.de>
 <20110104202718.GA31444@suse.de>
 <20110104212916.GA14436@pengutronix.de>
 <20110104213414.GA6774@suse.de>
 <20110104230508.GA18363@pengutronix.de>
 <20110104234440.GC30328@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20110104234440.GC30328@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 04, 2011 at 03:44:40PM -0800, Greg KH wrote:
> On Wed, Jan 05, 2011 at 12:05:08AM +0100, Wolfram Sang wrote:
> >=20
> > > > should fail if it cannot be requested. Or not. Things get worse for
> > > > architectures I never used before. This is why I think it is really=
 better to
> > > > let people do the fixups who have/understand the hardware in questi=
on.
> > > > Otherwise the fixups could indeed be more harmful than helpful.
> > >=20
> > > Sure, they could be more harmful, but at least try.  Make the patches
> > > up, submit them to the maintainers, and if they are wrong, they will =
be
> > > the best to fix it up properly.
> >=20
> > Well, I could generalize all cases and always issue a WARN() if the req=
uest
> > fails. But this would just move a compile-time warning into a runtime w=
arning.
> > Also, I have my doubts that even the arch/mach-maintainers know all the=
 boards
> > and their peculiarities. There are thousands of them.
>=20
> Well, they better know the peculiarities of the hardware they write code
> for :)

For the architecture, yes certainly. But for every board? I wonder...
Even if it is possible for one person to fix all the warnings, it is
surely beyond my resources, because I believe it should be done
manually. The pity is: My main intention was not primarily to cure old
bugs, but to prevent new bugs from happening. Some CONFIG-option would
still allow that which is what I'd prefer meanwhile. Okay, I can still
apply my patches locally and simply send fixes for code which I use.
Maybe others will do, too.

> But no, a WARN() might not be that nice as it usually is never seen by
> embedded developers...

Well, not after devices are deployed. It is seen during development
which is also the time those bugs would typically appear.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0kvwwACgkQD27XaX1/VRuxSgCgn+SCA0YYQ3bE4hcpQBqEhmbn
pgMAnjONMnWBmLa1CVw3/ZBxw093qGeG
=qjHs
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
