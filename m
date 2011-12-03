Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1LCIcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 03:32:07 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:34027 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1LCIcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 03:32:04 -0500
Date: Sat, 3 Dec 2011 11:32:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 3/3] staging: vt6655: card.c, srom.c, vntwifi.c: Code
 cleanup
Message-ID: <20111203083215.GF3195@mwanda>
References: <1322855892-6400-1-git-send-email-marcos.mage@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7mjWZ9NKzhEjSVTm"
Content-Disposition: inline
In-Reply-To: <1322855892-6400-1-git-send-email-marcos.mage@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4ED9DE7F.000A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7mjWZ9NKzhEjSVTm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 02, 2011 at 07:58:12PM +0000, Marcos Paulo de Souza wrote:
> This patch removes commented code, useless comments, blank lines and fix
> coding style of the headers of functions.
>=20
> Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: devel@driverdev.osuosl.org
> ---
>  /*
> - * Description: Test if bits off in eeprom
> - *
> - * Parameters:
> - *  In:
> - *      dwIoBase        - I/O base address
> - *      byContntOffset  - address of EEPROM
> - *      byTestBits      - bits to test
> - *  Out:
> - *      none
> - *
> - * Return Value: true if all test bits off; otherwise false
> - *
> + * Test if bits off in eeprom
>   */

Some of these seems sort of useful.  It might be better to change
them to doc-book format instead of deleting them:

/**
 * SROMbIsRegBitsOff() - Test if bits off in eeprom
 * @dwIoBase:       I/O base address
 * @byContntOffset: Address of EEPROM
 * @byTestBits:     Bits to test
 *
 * Returns true if all test bits off; otherwise false.
 */

There is a howto in Documentation/kernel-doc-nano-HOWTO.txt.

regards,
dan carpenter


--7mjWZ9NKzhEjSVTm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO2d6PAAoJEOnZkXI/YHqR3F0P/2aqxkQjOuqDSyg9mzz1InZe
cOFlonRKG2Eht2dwDa4SD1gKknh0L8XgqkEIUAC/Nfy+pEBJWZa8u4hDWEmx/Mqk
QpdLPmRLOaZfVpT7xDSgBAp3M5F42RwekRA4UC0BzZv/gK2k1yWhZWOUjf4Mvifa
F/0pq5gfjVhO6/eaUFYqh4W4r+ikQYblzUpHBDX4SwMj3Ijh/M8TpyTkAfVj5bKW
+Z6MUiS1KBY5OT3jFvrNYlmf6DUNtqv8HU/Hvm79VA5rQO+3loObhajjbUveIFnN
OjRYUi1CAwUpWUEBkKYkz5vrDU4h/+L1v8vx2LtMNccO7VEK1H/w3KA/cgX162xb
BKP+bsESb94/kzW5vgARSfMpZp/kMNP5pmjmnKAlSr4+FvO5zzGWEg7UI0rgmsRb
BKv0faQHoZ7AOBR4pQBFkNfrAPH2rW7dYKhQu+93vGbclQqWMKigrHOk3aJUNoz3
lzEHHbcKtyI/a4h9/9TwMD3aJ2qd9PKj1UJnEOpkEkwrL6fqpcV8bHBW5SZDrTmX
MUAkeEaQtAbPMJAutWHers81tX6s0H+/RQcJdGMmzZ++P79ObQRSQe1gWpcgMoaC
kNNrMTpxUDyNaDY4WWZdUjrTmR0Qjy1hZtSW/ZoD9BWJBrMQxvhMJSmszF1QMIWs
vlWFwaR1AwyEqi6yikMo
=VMPI
-----END PGP SIGNATURE-----

--7mjWZ9NKzhEjSVTm--
