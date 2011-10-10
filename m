Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1JJGCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:02:50 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:49934 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177Ab1JJGCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:02:48 -0400
Date: Mon, 10 Oct 2011 09:02:42 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 4/4] usb: gadget: get rid of
 USB_GADGET_{DUAL,SUPER}SPEED
Message-ID: <20111010060241.GC31707@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1314364322.git.mina86@mina86.com>
 <4b5e561ce923ca69b17ecb183e21e2520e977799.1314364323.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WfZ7S8PLGjBY9Voh"
Content-Disposition: inline
In-Reply-To: <4b5e561ce923ca69b17ecb183e21e2520e977799.1314364323.git.mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WfZ7S8PLGjBY9Voh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 26, 2011 at 03:18:37PM +0200, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>=20
> This commit removes USB_GADGET_DUALSPEED and USB_GADGET_SUPERSPEED
> Kconfig options.  Since now kernel allows many UDC drivers to be
> compiled, those options may turn to no longer be valid.  For
> instance, if someone decides to build UDC that supports super
> speed and UDC that supports high speed only, the latter will be
> "assumed" to support super speed since USB_GADGET_SUPERSPEED will
> be selected by the former.
>=20
> The test of whether CONFIG_USB_GADGET_*SPEED was defined was just
> an optimisation which removed otherwise dead code (ie. if UDC is
> not dual speed, there is no need to handle cases that can happen
> if speed is high).  This commit removes those checks.

and here.

--=20
balbi

--WfZ7S8PLGjBY9Voh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOkoqBAAoJEAv8Txj19kN1SrMH/3SHvxJLq+CV0e2092ivcKsD
cDt5TuzDeu5RsJkjKoWgAdFnE3zQyciCtnAoggX9jShk9143HdnWZTqHbHSKm1Yv
U92QAZoyEn3w7UCnMv9pCTOPu/8p5W6i99eRzNkHhz5hQcwnNj5XYc5BgjHCGjvG
GMzbfNVeXM2D5YTW5qOE8M684IaUqYSIvhdjE5Zi987oviwBF+bZ8c6AqYwb1cYT
AUyWgPx1MBToBqhfH6+91oDfsmjWjah4UJcRGjuDFjiFXECwcV1tF01/268mtEZR
pjnyFVmQX1VgRadjAgx7QKGvE6Is7c+Tp83il/1kIzoq7qi4pbR0oOGedbsX2wI=
=qZnM
-----END PGP SIGNATURE-----

--WfZ7S8PLGjBY9Voh--
