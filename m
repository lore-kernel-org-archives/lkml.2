Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1LSC53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 21:57:29 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60448 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1LSC52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 21:57:28 -0500
Date: Mon, 19 Dec 2011 13:57:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonas Gorski <jonas.gorski@gmail.com>
Subject: linux-next: manual merge of the l2-mtd tree with Linus' tree
Message-Id: <20111219135716.f121c97ba912b6c17ec411a8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Dec_2011_13_57_16_+1100_VXTx2MJxJ8nZtT9O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Dec_2011_13_57_16_+1100_VXTx2MJxJ8nZtT9O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
drivers/mtd/maps/bcm963xx-flash.c between commit 4e549d6d4a32 ("MTD:
MAPS: bcm963xx-flash.c: explicitly include module.h") from Linus' tree
and commit 573052d2e4a4 ("mtd: maps: remove the now unused
bcm963xx-flash") from the l2-mtd tree.

The latter removes the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__19_Dec_2011_13_57_16_+1100_VXTx2MJxJ8nZtT9O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7qgMAAoJEECxmPOUX5FELAMP/2DfMDfQfTvJDF+OmS5WjK3i
U8J8HHHnD33uNAh8SuswkoeMR3VBVQZcGa3gLNXPLSGFmxLP8OvmDuqpUJnr6Cxo
KVtfCc1gppZeDcAKuLutqp2Uxo/qgpOrK9XHS3bz46GyZPtPkitJAmlaBSiQ/ak0
8Ze/WqmYYV4oCE65/DuJBaX6n2optvK+9vwWizGeogEIKxW27nRx3eYZK8cB+XHt
n9nAtN9QEQcnLQ5HXx06bFTZfyhgYCzAGwr/6vHs7Mlr+18K+4yqEhtIJCRm/wW7
3JNHKQSt/xKr3A4JOHZMk0xzs305ysmh9xf9nEbyvetWcVXK++2YQVDjIOix79TQ
B2Q/8XmY/CL7CDzjjdy47J17mEHzOFWlIllyDJ06Qj9c0umLLulSFJcgZEdytoZK
5HXlLriR+K/HrKxe7TPQqvG/ZR1B3vc68f9aOluAlRyZrzgx/6/uo3kzxDZlTTWK
9jtH519TG6GSsPQnRCYhpbNMcOaWiBiZil1wCvUkG0fQ2q7SQKO8CSejBqxxtKKY
9ecj+oDCxI9bXW6/p8no1xw9dKOWw0Woa0ct9YuBzONnGG495XZR6yIVxw0KBk/H
xE3mNsw6OX7t9s7s+4excXV3e7xCsKxUluAXPhkL1iXShOj4UDNof6CagX6j9InT
6oOjT3hs88RsMLDPcrcZ
=HJ7X
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Dec_2011_13_57_16_+1100_VXTx2MJxJ8nZtT9O--
