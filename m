Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1H2LTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:19:45 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:55490 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307Ab1H2LTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:19:39 -0400
Date: Mon, 29 Aug 2011 14:19:32 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Felipe Balbi <balbi@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] sound: usb: mixer: increase control transfer timeout
Message-ID: <20110829111931.GU13925@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1314616226-15942-1-git-send-email-balbi@ti.com>
 <20110829111607.GB21556@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sBvc846/5FzkyDmz"
Content-Disposition: inline
In-Reply-To: <20110829111607.GB21556@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sBvc846/5FzkyDmz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 29, 2011 at 01:16:07PM +0200, Sebastian Andrzej Siewior wrote:
> * Felipe Balbi | 2011-08-29 14:10:26 [+0300]:
>=20
> >Not sure this information is valid on a commit log, but I
> >have a FPGA-platform which I use to test my USB controller
> >and when that's running on FS, this message fails because
> >control message times out before controller has the opportunity
> >to complete all three phases of the SETUP transaction.
>=20
> Does it still happen if you remove all the debug output from your udc
> driver?

I can try it out, but what's the point ? If we don't increase the
timeout, then whenever we want to debug some other problem, we will have
to keep a local patch on that file ?

--=20
balbi

--sBvc846/5FzkyDmz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOW3XDAAoJEAv8Txj19kN1G6wH/RBB5V93bS68st7mY8fW2WUl
QwVOl/ztpPCRGrVuNKw7e+dW3jL9R1BI0LlmjRDzc51dtTCZixs6//PqciwF1V+I
fMj7olopOdIlU7DNwrA9lgFb2E0239XQBVVPw+spJX09XK8D/h7BLpKmDCZRNJOw
yXnY9jF9tphy43UH/NLC1BkN3ql5L+JeN729jnOJ7Ymp2aqob/Rh0a0bg/cpfj/4
4EMthpYP0AD9vfGJy4Pcl9VYibbsn1vSL/SbyfLbgHATHRIHiW2w/5vUwgrOqiAq
i07Ng9YQ364pF5U7Gp1SlCODacZx2AWARHpOBB11mOhGtbs9KKk0rRuR8/QiyeE=
=7At/
-----END PGP SIGNATURE-----

--sBvc846/5FzkyDmz--
