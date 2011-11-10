Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab1KJUKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 15:10:14 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:57870 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190Ab1KJUKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 15:10:08 -0500
Date: Thu, 10 Nov 2011 22:10:02 +0200
From: Felipe Balbi <balbi@ti.com>
To: Nikolaus Voss <n.voss@weinmann.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org, khali@linux-fr.org,
        nicolas.ferre@atmel.com, rmallon@gmail.com, balbi@ti.com,
        linux@arm.linux.org.uk
Subject: Re: [PATCH v5 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Message-ID: <20111110201000.GB17468@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1320934086.git.n.voss@weinmann.de>
 <f29b091aaf5165d602f7ddd3980de748c1c27688.1320934707.git.n.voss@weinmann.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7qSK/uQB79J36Y4o"
Content-Disposition: inline
In-Reply-To: <f29b091aaf5165d602f7ddd3980de748c1c27688.1320934707.git.n.voss@weinmann.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7qSK/uQB79J36Y4o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08, 2011 at 11:49:46AM +0100, Nikolaus Voss wrote:
> This driver has the following properties compared to the old driver:
> 1. Support for multiple interfaces.
> 2. Interrupt driven I/O as opposed to polling/busy waiting.
> 3. Support for _one_ repeated start (Sr) condition, which is enough
>    for most real-world applications including all SMBus transfer types.
>    (The hardware does not support issuing arbitrary Sr conditions on the
>     bus.)
>=20
> Tested on Atmel G45 with BQ20Z80 battery SMBus client.
>=20
> Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>

FWIW:

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--7qSK/uQB79J36Y4o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOvC+YAAoJEIaOsuA1yqREg3sQAKyTNZkFNeLjnflHsnBWeGcr
H1ZLLMnDLQUPCmzFSrywge68Ox3b7cNOPRKzo22/f0ubDNEYohg7ji+35ejJTYQl
bTW/hS6UxUyrMYHlPvIBS+Gqlr7uHwpe1z5CKGf05dH7A4rdL/Dk2PF3Hqmrt50j
XYAUdfRyYPUgcfrZo/AkDZISIUIrR+qaOrzQo7HdQ0EVMxmD4ThWckTASrYFYDa0
qgxZvoxZwxtb9TDFpF6XZg33hd1FPeadnRCEgyGRLWtoMpQc0633xrzyLALwBo1q
oYl18m9Dj+EiGS3sv1EZlNCPqjmsOCxXDZt+lYgcscw0zZmatpgK/Xh36yzsycpq
uM59L7drfhZzsnFHHcShFr95eE3wfYAAcdnKvTvRFUjH65D5dDsxL8NlD8O1cfn+
uwLwDfZlLonX//O94kFFBAfqm+HqGrXGs+Fk0Yx+ERuqT4k7oS/3QKL+jqOYZ1ZK
1SviZRBpsC4ra6xsTqTFqI0gtj7gErsk65UqQJfc0y378kSm1aODGnsVa9FmBr8m
qE3GnPXsHQ01t3OOmlr6ei5lrrptBI79Soas2EohBZYs2W9LmkPY7/9oWNdJwPXr
iEFBhizpcmAxVpMMdQ2JTehON4M920jO6zIIRy9E0xu2KQDiL8qYIhXdV+2gI6IV
mCbTS4raAEZwuZFSbJ/T
=HaU4
-----END PGP SIGNATURE-----

--7qSK/uQB79J36Y4o--
