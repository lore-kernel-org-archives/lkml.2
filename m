Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab1LEIjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 03:39:53 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:52432 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730Ab1LEIjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 03:39:51 -0500
Date: Mon, 5 Dec 2011 10:39:46 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Shimrit Malichi <smalichi@codeaurora.org>,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, target-devel@vger.kernel.org
Subject: Re: [RFC] UASP on target (was: [RFC/PATCH v4 1/3] uas: MS UAS Gadget
 driver - Infrastructure)
Message-ID: <20111205083946.GE9900@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1323028390-12846-1-git-send-email-smalichi@codeaurora.org>
 <20111205082047.GA2423@linutronix.de>
 <20111205082326.GA2734@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JbKQpFqZXJ2T76Sg"
Content-Disposition: inline
In-Reply-To: <20111205082326.GA2734@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JbKQpFqZXJ2T76Sg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 05, 2011 at 09:23:26AM +0100, Sebastian Andrzej Siewior wrote:
> * Sebastian Andrzej Siewior | 2011-12-05 09:20:47 [+0100]:
>=20
> >* Shimrit Malichi | 2011-12-04 21:53:09 [+0200]:
> >
> >>This patch implements the infrastructure for the UAS gadget driver.
> >>The UAS gadget driver registers as a second configuration of the MS
> >>gadet driver.
> >hch said to use target framework and you haven't done so. This is what I
> >have so far. It is not yet complete. What I need to do is:
> >- wire up command processing (currently here)
> >- wire up data processing
> >- check it works =3D> post v1
> >- wire up command tagging =3D> v2
> >- remove hard codings and fix whatever people complained about.

This is much better, indeed, but the way it is now, it's only usable by
the gadget framework because you have put the function driver on the
transport layer. I wonder if there wouldn't be a simple way to split the
"SCSI Over USB" part in a more generic way which could be shared between
gadget side UASP and host side UASP drivers ?!? Maybe ?!?

The drivers/target/uasp_*.c would really be just a transport layer and
gadget/host drivers would make calls to that "library" ? Something like
that ??

--=20
balbi

--JbKQpFqZXJ2T76Sg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO3INSAAoJEIaOsuA1yqREcvoP/3CqV6au+6UiHLAqOSY/NQpP
xPijL1sRddjYIEIzpoYJkZQCEth0/OpNx3rENXYSjqZ6M1vZXUj3hRAOQgLQq2Lh
skc4TsnqfoMa1E+s2yPh3WakNi60IxJOlA5dbYCOGV33u4k/GmOW87qEG6+rwqhz
FCkpHD6yHDFOX4Xkf8KrSdLYfNSUkan1jevtR+s0OfJwGswlOHDbkNfKbAXl0K6g
S+S4f0u9vJWkiIdZwyyH9yzBivM2jcNvXR3rFHR7G4fvi2IPU9u2gnKM7I14mVoV
Cr29LfzrbM8PQxBHSFFwdzCMrJWEMiCtv7AzuI7mmDm6SGv8bzYjYqjpAO0KJY6q
EC4J7/Z9E1NVECQ4HWP2aKZT+rJaGPuw9/70HN8wUQBc/TfnfURkhjwfsSxzAN/a
AKn0EYRiNegOuRhJFEY9suvhvNukqEVgaIANDngd66WCoRL61S67zqwXDS6YJWzk
A1swXmP2+E+rDhk3HlYIYvwF9Y03N7uUp1CMsos/AYsRtV/6/T+F525MXOBc8RGP
0Tdz5XMYdbvDkNBzOhQjJo9c0AQbqhaZtpWuN/sEIyM7vT4R+yTGj1q3SlNe+Rt0
1JBAF66i82LvixGPYC1BPE5NZoPm4a5yiaA/KLRTfl9FlE2Ed6e/ptVH382ueeOl
AeaXtgcJRzrL1OnSqOCy
=gMPn
-----END PGP SIGNATURE-----

--JbKQpFqZXJ2T76Sg--
