Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1JYPFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:05:00 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:53185 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1JYPE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:04:59 -0400
Subject: Re: [PATCH] mtd: clean up usage of MTD_DOCPROBE_ADDRESS
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Oct 2011 18:04:47 +0300
In-Reply-To: <1319533207.2409.68.camel@x61.thuisdomein>
References: <1319533207.2409.68.camel@x61.thuisdomein>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-s0BauUu8GXOk4gMAgO/Q"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1319555096.2814.1.camel@golum>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-s0BauUu8GXOk4gMAgO/Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-10-25 at 11:00 +0200, Paul Bolle wrote:
> Depending on whether MTD_DOCPROBE_ADVANCED is set or not,
> MTD_DOCPROBE_ADDRESS will default to either 0x0000 or 0. That should
> lead to (basically) identical code in docprobe.c. The current two
> defaults should be merged.
>=20
> And, while we're at it, if MTD_DOCPROBE is set MTD_DOCPROBE_ADDRESS will
> always be set. (MTD_DOCPROBE_ADDRESS depends on MTD_DOCPROBE and it has
> a default value.) So the check whether CONFIG_MTD_DOCPROBE_ADDRESS is
> defined is unnecessary and should be dropped.
>=20
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Pushed to l2-mtd-2.6.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-s0BauUu8GXOk4gMAgO/Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOptAPAAoJEJtuLFy+q7feiIsIAI300nkRST9olDtmP7+ipxxz
J7+tKxNY9wFduWT5JQPVitRJQyQDVkp5pH/Ak40TSROp6WfLuQykgWIO7b1M62vb
y9N4LnWEEY0xP56vHz/kIkcUIHbtkzx/slLBr/omIJUrpF7PLJncMjkkkoNoQalK
FMTbw0ptLm+qil+REuHzmICOi9ODE+yj7xxaSpewQJwzxwRBJBVrzKDg4QWT0X1D
yd34Vz0hRuC+XtoO6fpmTqczh1k4pnT4AK9LIDRZU6V2gv6kyM64WJvF487E28DO
tYwDU1bDS0V/ny32WSSRsn6U2EefQNtvVMqBIjbKSBM+EhulcNQw3gyX/kXL4EI=
=4PC9
-----END PGP SIGNATURE-----

--=-s0BauUu8GXOk4gMAgO/Q--

