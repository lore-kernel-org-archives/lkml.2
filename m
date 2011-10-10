Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1JJGCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:02:21 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:50625 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177Ab1JJGCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:02:19 -0400
Date: Mon, 10 Oct 2011 09:02:14 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
Message-ID: <20111010060212.GA31707@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1314364322.git.mina86@mina86.com>
 <befb5cae917585ee1caee515426cb11045ce1d6b.1314364323.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <befb5cae917585ee1caee515426cb11045ce1d6b.1314364323.git.mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 26, 2011 at 03:18:35PM +0200, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>=20
> This commit replaces usb_gadget's is_dualspeed field with
> a max_speed field.

missing Signed-off-by

--=20
balbi

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOkopkAAoJEAv8Txj19kN1KAMH/A82C5iLjUJtz2PwIkDPkvy7
mYZ/bTmlpmaAQXj2PViQO3nOU8TiQV43w/qz+lrDnGaIgw5yeDeg5mAi35RwD2bI
gMF4AXhMucLp2mpNQydG2O2C+4MZl4S/J/Hg9MqNqf9jKezKHcT2NLUxeRp10prG
N52sYnAHQELk9yIJyXGFf4vyevuoG2ftvr7rd9UTidMQc1mhi7Pno7S2vv5bSX6j
prwgc6umj5MQiDdbIXxMdIzvQaxYGWRn7Uh9ubd3G4Gf4vHvyZCyfdhLhKNE9bLp
fK0wGl6+B8R91+jjnvmL+glz9kQBx+l8o7zOq5m8P9C7YpCi2pXzku/Ooe77pBc=
=FepR
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
