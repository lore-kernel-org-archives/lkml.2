Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab1KCRZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:25:18 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:39818 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751991Ab1KCRZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:25:17 -0400
Date: Thu, 3 Nov 2011 19:25:12 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kyle Manna <kyle.manna@fuel7.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 4/6] mfd: TPS65910: Move linux/gpio.h include to header
Message-ID: <20111103172511.GC30472@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1320340086-15371-1-git-send-email-kyle.manna@fuel7.com>
 <1320340086-15371-5-git-send-email-kyle.manna@fuel7.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
Content-Disposition: inline
In-Reply-To: <1320340086-15371-5-git-send-email-kyle.manna@fuel7.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 03, 2011 at 12:08:04PM -0500, Kyle Manna wrote:
> The tps65910.h file depends on linux/gpio.h.  Move the include from the
> source file to the tps65910.h header file.

you should never rely on indirect inclusion of header files. If both
header and C source need the header, include on both. The header should
be safe for multiple inclusions anyway.

--=20
balbi

--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOss53AAoJEIaOsuA1yqREBCoP/166at3IMofgGa83H5vJiI2j
sB9plUfjYCvHp8rrK8JlcQMdFLorbTdPjSbiBJEr4vxAtAvzpk1IPvsfQdy7DLWa
cVbLL8QvKU1G0xsqguY1M2qWr5xQWgw0ec42jMUFojChyKDh8PiBHcxnKj7yfM8s
WRVR8ByOjJNJa1bHM7xo8Nhz7vET8sftri96+BMXrWHnpOZzjvwLb32lECM82Kye
snFohO1I6Ji0imaVojPJSObAAsmpNbt9xSk8m4rEHUYu1n71F6tP83z34icYNOoK
Oml4j4h9GTQkLP4/gFZC3NmT98EtQcQfacIzDSqDnpYY9yHNFduiS0loDa6rXxrb
4fOyD27PEO2A1ueAFF9tXE4tSAmj9ULmcsHNyYm7trpERye/I6pzIH8AFXm/YIhF
2nSH0K9QPCxBKRqxwxxQQDhtQZ8eX9ZMMh6Yn83lW8Kn8QtvkRoWPbENovQU7RN1
gfQeZikJfVxJuEZFGyKASH3+KSOLC2nGr4qzwGItYDgx74UsogJLFy+IR3gvwsW7
P9Ub85/BMLAVYU+dh8y2sWofk2HnormWGa1oSt8SrL/7kj2FTZLh/az5nhlPuEYc
MbhtXmV2qDSOEKczFrSlzAYW4AJEbRlRQ7xLeixN7ZoG9ZH0JI/Y5eSGVKg05PGg
+ZcuvdyLq3bbk62G9A/a
=DdO+
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--
