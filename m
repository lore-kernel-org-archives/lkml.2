Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2JJC0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 22:26:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59380 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754233Ab2JJCZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 22:25:58 -0400
Message-ID: <1349835953.6336.25.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 068/108] HID: hidraw: add proper error handling to raw event
 reporting
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>
Date: Wed, 10 Oct 2012 03:25:53 +0100
In-Reply-To: <20121008193409.GC3004@herton-Z68MA-D2H-B3>
References: <20121007225834.673681075@decadent.org.uk>
	 <20121007225844.105600523@decadent.org.uk>
	 <20121008193409.GC3004@herton-Z68MA-D2H-B3>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-gxeEzJg7DYZuDTCRz3Jq"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gxeEzJg7DYZuDTCRz3Jq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-10-08 at 16:34 -0300, Herton Ronaldo Krzesinski wrote:
> On Sun, Oct 07, 2012 at 11:59:42PM +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Jiri Kosina <jkosina@suse.cz>
> >=20
> > commit b6787242f32700377d3da3b8d788ab3928bab849 upstream.
> >=20
> > If kmemdup() in hidraw_report_event() fails, we are not propagating
> > this fact properly.
> >=20
> > Let hidraw_report_event() and hid_report_raw_event() return an error
> > value to the caller.
>=20
> This needs in addition a small fix on top, commit d6d7c87
> ("HID: fix return value of hidraw_report_event() when !CONFIG_HIDRAW")

I've added that, thanks.

Ben.

--=20
Ben Hutchings
Who are all these weirdos? - David Bowie, about L-Space IRC channel #afp

--=-gxeEzJg7DYZuDTCRz3Jq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHTcsee/yOyVhhEJAQprLg/9HQ46/npG9rsRZRU7Ae8LNVlP6Wit1ZjJ
2mFmW9SAeEYcBQG0i2r9vuPRvPd36gZAu5Y7VM97PKWDKxDmZvH08USLrqIFw7ZX
F3BIRVh+vFDUZdmPUbWkInY5bQBhVOdMlXNiz0nNoRcaCBAowiXi6GlZF/xZAtwP
rKvBmWRchIV1fEY6FBFgqBIwA2Ekqzg+VfISwgABEvMDLlVeAWOuzLvnWWHSz9cE
QPzDFz9NsKY+ZgnC1iGevahen4s8fRw+2GuInUvo+Ump7XK6w2FtNuJuKoEdcrV5
riX7nWvdGiUzsmOACkrpROriMif1Tbz8eFNaPm+z0+wxn28uC9CDAUgd04qlTn05
0OEwPplRqiH76EUdGNPCUbze1hSsI4rhPkzciN+1g+SJf1CFHrcADPuWjq3e9MMW
3JndEVh5I/2ucx+oq2vblAyBLvMzt9hCpv32cYtfy3vYU4Wwmldv01/jc7aeXRkk
XUQEZLpLfRGbtNhzPeTd9uNcGj0/ENttGQwgetVAsyi+XsvhGn09QQkZ6iTw+wyr
K+MHgYRF1z4xRyzkowssItAmTatVzfeagDeB040i0nrejvPXVCeZakkGzqUC2nQZ
LFq/F0Pstm80vM8xEmb83DbdYlrkxrBs0+CZAw4M6yVfwMjOCCQTwqxwIMcZuq2e
RW6EbjhiXWo=
=V8Uv
-----END PGP SIGNATURE-----

--=-gxeEzJg7DYZuDTCRz3Jq--
