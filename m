Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab2C0Hyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:54:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50817 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2C0Hyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:54:49 -0400
Date: Tue, 27 Mar 2012 09:54:47 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Peter Rusko <rusko.peter@prolan.hu>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: PCA GPIO interrupt triggers, matrix-keypad
Message-ID: <20120327075447.GA6790@pengutronix.de>
References: <4F6B4C11.4000608@prolan.hu>
 <20120325074012.GA25173@pengutronix.de>
 <4F704490.7000308@prolan.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <4F704490.7000308@prolan.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 26, 2012 at 12:27:28PM +0200, Peter Rusko wrote:

> >? I fail to see why having EDGE_FALLING together with EDGE_RISING is not
> >supported. Are you sure you didn't use some other IRQ_TYPE here?
> >
> Yes, you're right, the problem is not there.

It was the most likely answer looking at how IRQ_TYPE_EDGE_BOTH is
defined.

>=20
> >>I think, this patch should work:
> >
> >Think? Can't you test it :)
> I wish that could be that simple :)
>=20
> I can test it with the matrix-keypad driver. But there's an inverter
> (+delay) in the circuit (to prevent contact bounce) and I don't know how
> it affects the signals. But in the end sometimes I don't get e.g. the
> key-release event.

It would be great if you could find out, since it might result in
arbitrary patches otherwise which would be a waste of time to review.

> Another change in the code was with the IRQ request. I could only make
> the matrix-keypad driver working with threaded interrupts:

[...]

> Is this okay, or is there another way?

The change itself is basically correct, but you need to make a proper
patch out of it. Please read Documentation/SubmittingPatches (also
Documentation/development-process/ if you haven't already) how to
generate one. Look at other threaded irq users how to convert properly
(you are missing something). Please CC me to the generated patch.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk9xckcACgkQD27XaX1/VRsMQwCZASX27wKlWQGwSnxl9U612j3V
6UgAnjpYSM8F9MjD3LZOXh3vg4K7JPC4
=S8cq
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
