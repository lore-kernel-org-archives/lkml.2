Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab1HRVeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:34:25 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:36280 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659Ab1HRVeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:34:24 -0400
Date: Fri, 19 Aug 2011 00:34:18 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        mporter@ti.com
Subject: Re: [PATCH] irq: always set IRQF_ONESHOT if no primary handler is
 specified
Message-ID: <20110818213418.GA20509@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de>
 <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com>
 <4E4D4A5F.202@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <4E4D4A5F.202@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 18, 2011 at 07:22:39PM +0200, Sebastian Andrzej Siewior wrote:
> Pantelis Antoniou wrote:
> >Hi there,
> Hi,
>=20
> >Let me report that with this change Beagle board fails to boot,
> >hangs right on rootfs mount.
>=20
> Can you provide some more information about the kind of the failure and
> used drivers?
>=20
> >Users of BB should revert this until the offending driver(s) are fixed.
> Which is the offending driver?

I would guess it's the lack of threaded IRQ conversion on the
twl4030 driver. I have converted it but noone actually picked the series
[1].

http://marc.info/?i=3D1309427470-605-1-git-send-email-balbi@ti.com

--=20
balbi

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTYVaAAoJEAv8Txj19kN1UeMH/15n2PcmoHmoMl2swg7DiDQ9
xKE0430Vsd2yupaume/1uoXRseMCgcWWlRC4ijzTn54rbHKfCQewam1RyX8j/5/O
Vvbd3rHzG15asMgrfL87SFbWzwdKe8NxiGfSUazpxqB+TJuLUXkYX7RvdE2Lja6Y
+b0o6gFubMAHL3RT8AzB8gojKAQgicHyBpmMsdSyhuLpPQ/a7uPqhAY1PPGPMEu5
kEk/N6brSDK8Yd6JVz71v3MYFgwj+vdfga7a7yExp66XUj2oLmk4dLu8DzNYyFjt
z3+hL7NUHHkJ6ifqU0Pu720icgarZFhZcBmNfRnOK7hj21CgCetslSV9pNfickw=
=nk6B
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
