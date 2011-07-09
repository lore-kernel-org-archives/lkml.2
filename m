Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1GIPmM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 11:42:12 -0400
Received: from ns39351.ovh.net ([91.121.21.191]:60555 "EHLO ns39351.ovh.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539Ab1GIPmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 11:42:10 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jul 2011 11:42:10 EDT
Date: Sat, 9 Jul 2011 15:32:44 +0000
From: Simon Guinot <simon@sequanux.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Simon Guinot <sguinot@lacie.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] drivers/leds/leds-netxbig: make LEDS_NETXBIG depend on
 LEDS_CLASS
Message-ID: <20110709153244.GC13351@kw.sim.vm.gnt>
References: <1310224038.14501.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <1310224038.14501.1.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 09, 2011 at 11:07:18PM +0800, Axel Lin wrote:
> We call led_classdev_register/led_classdev_unregister in
> create_netxbig_led/delete_netxbig_led, thus make LEDS_NETXBIG
> depend on LEDS_CLASS.
>=20
> This patch fixes below build error if LEDS_CLASS is not configured.
>=20
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `create_netxbig_led':
> drivers/leds/leds-netxbig.c:350: undefined reference to `led_classdev_reg=
ister'
> drivers/leds/leds-netxbig.c:361: undefined reference to `led_classdev_unr=
egister'
> drivers/built-in.o: In function `delete_netxbig_led':
> drivers/leds/leds-netxbig.c:313: undefined reference to `led_classdev_unr=
egister'
> make: *** [.tmp_vmlinux1] Error 1
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Simon Guinot <sguinot@lacie.com>

Thanks,

Simon

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk4YdJwACgkQgtp0PDeOcDqLnACgmxcWAz27yXK/6QxU2ENxPgbC
q88AmwQE0AhOCpnhGIF8Ng8bf+yfmzl4
=I0WT
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--
