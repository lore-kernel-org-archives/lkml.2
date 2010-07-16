Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935812Ab0GPHT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:19:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57290 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935747Ab0GPHTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:19:25 -0400
Date: Fri, 16 Jul 2010 17:19:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martyn Welch <martyn.welch@ge.com>
Subject: linux-next: build failure after merge of the final tree (powerpc
 related)
Message-Id: <20100716171920.51ce1b88.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__16_Jul_2010_17_19_20_+1000_lYfodvP+Q6=ZuAhj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Jul_2010_17_19_20_+1000_lYfodvP+Q6=ZuAhj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allmodconfig) failed like this:

ERROR: "of_i8042_kbd_irq" [drivers/input/serio/i8042.ko] undefined!
ERROR: "of_i8042_aux_irq" [drivers/input/serio/i8042.ko] undefined!

Presumably missing EXPORT_SYMBOLs ..
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Jul_2010_17_19_20_+1000_lYfodvP+Q6=ZuAhj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMQAf4AAoJEDMEi1NhKgbsFSoIAJXfCe3PuQaXJLvnVkr8eUHT
oYRCtR3kEWPCpdedg5MSaWMNL6LUepCwdINPcL+FisvYZHhyBm92mrNdLIzvL4YF
MK+aUCTSF5Fi2zL0N2T4zH6sJHXXJdg/tlGL5bG0CEuuuBCn2gdDzZUtNmJrNy42
NyrwQNS7G+judqbNjws5L1LPxjeybSRHz60dLTUSiALQK6V7v1aNGkJhepG4XNO1
9+ZFKfKlCJmelmOGwytl1a5FKcb75CWBDDwcPRirQnDG2hJLuMjnCT8eOUZrFKcZ
UH6laP8bVaB1uWsn5C27NSp/T+u8OxMjKxsy0HUzyIkekCC8C5D/lgzXQ1pIMio=
=0pZN
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Jul_2010_17_19_20_+1000_lYfodvP+Q6=ZuAhj--
