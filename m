Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1GZOoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:44:12 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:58331 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491Ab1GZOoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:44:10 -0400
Date: Tue, 26 Jul 2011 17:44:06 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Herbert P?tzl <herbert@13thfloor.at>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Axel Lin <axel.lin@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: s3c2410_udc: fix unterminated platform_device_id
 table
Message-ID: <20110726144405.GA32582@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1310468729.6590.3.camel@phoenix>
 <20110714082414.GC7149@linutronix.de>
 <20110726144108.GB18052@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cN+O50sc7gZAK+8F"
Content-Disposition: inline
In-Reply-To: <20110726144108.GB18052@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cN+O50sc7gZAK+8F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 26, 2011 at 04:41:08PM +0200, Sebastian Andrzej Siewior wrote:
> * Sebastian Andrzej Siewior | 2011-07-14 10:24:14 [+0200]:
>=20
> >* Axel Lin | 2011-07-12 19:05:29 [+0800]:
> >
> >>Signed-off-by: Axel Lin <axel.lin@gmail.com>
> >Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>=20
> Felipe / Greg: can one of you please pick it up, please? Should I
> resent it?

I'm starting to take patches now. This is queued now.

--=20
balbi

--cN+O50sc7gZAK+8F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOLtK1AAoJEAv8Txj19kN1ODAIAI133eV9087Ev3Elr3fYEWXG
rRT8xFd5OFx541WOeO5CwfRtQ9r/pc6Mzyg5wdJ13Nsn1q9SFy4O0maabu2vjDkO
u5O6eO70jh3ycuQa/+EvRZ03dWtpP7JXjUZi9ECOvB53/CmfwnFAIKTRI3HtrbrR
HnRfB6KU4KXzXoSkaR8/rVNwul4l1RVEgIEtAB7EjjKjM5D0YhhWRITyaHfbv3Eu
xQw3CtA6tEtR//Cp/kOPd6+CnjBAstQgpueN9TYZl2Y5wB7BhKTN/jcEcdnVApjx
WRRNlDISZUX/aIb0d2kMsngdPAsuaIxjkVgMg17mEzhFEKecvH4JRVq/78b5RFQ=
=a3fA
-----END PGP SIGNATURE-----

--cN+O50sc7gZAK+8F--
