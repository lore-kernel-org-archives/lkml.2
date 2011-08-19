Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1HSKNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 06:13:44 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:46721 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054Ab1HSKNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 06:13:41 -0400
Date: Fri, 19 Aug 2011 13:13:38 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: balbi@ti.com, Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        mporter@ti.com
Subject: Re: [PATCH] irq: always set IRQF_ONESHOT if no primary handler is
 specified
Message-ID: <20110819101336.GH23101@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de>
 <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com>
 <4E4D4A5F.202@linutronix.de>
 <20110818213418.GA20509@legolas.emea.dhcp.ti.com>
 <4E4E0FEF.3010006@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tT3UgwmDxwvOMqfu"
Content-Disposition: inline
In-Reply-To: <4E4E0FEF.3010006@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tT3UgwmDxwvOMqfu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Fri, Aug 19, 2011 at 09:25:35AM +0200, Sebastian Andrzej Siewior wrote:
> Felipe Balbi wrote:
> >>Pantelis Antoniou wrote:
> >>>Let me report that with this change Beagle board fails to boot,
> >>>hangs right on rootfs mount.
> >>Can you provide some more information about the kind of the failure and
> >>used drivers?
> >>
> >>>Users of BB should revert this until the offending driver(s) are fixed.
> >>Which is the offending driver?
> >
> >I would guess it's the lack of threaded IRQ conversion on the
> >twl4030 driver. I have converted it but noone actually picked the series
> >[1].
>=20
> This makes no sense. If you don't use threaded handlers that means
> you specify a primary handler and therefore the patch does not change a
> thing for you.

the thing is that twl's children are using threaded IRQs, but no the
core itself.

--=20
balbi

--tT3UgwmDxwvOMqfu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTjdQAAoJEAv8Txj19kN1GS4H/1wuMWgGguNJyHP9bYUWW0YX
n6DA0sOS7vkLKMsp1osfvXY52/5GhTc/Jk8e3PuZA4PsYFF6CxUx2IdJH4uxt8NZ
//7Q8+6kCyjDQzgtTG8G97DYXXQnq2DAyM+3Fp03qA+LX3wIZYJHkTury+9P7xSf
enKyKMwXLu82AVuRZi5AVXV5XuB65p+IPfyTSlBF7X0qWc4nEmfcvoWtiPI5sb6A
qUh8McoQ8ZjiURGivOI8gp8wepqgdBfZVjIhpO7kFWF4tMx6DbkKMnKxqZ/W9bJ8
JLzB6qZYzzkomv9pp+dP1wzJHXTx1RP/KlNF+98D+JHbAFfabWwGkeUfmxEprOE=
=NyLi
-----END PGP SIGNATURE-----

--tT3UgwmDxwvOMqfu--
