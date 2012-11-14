Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab2KNLed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:34:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59767 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755351Ab2KNLec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:34:32 -0500
Date: Wed, 14 Nov 2012 20:34:25 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mfd: arizona: Sync regcache after reset
Message-ID: <20121114113424.GM7407@opensource.wolfsonmicro.com>
References: <20121112175648.GA29044@opensource.wolfsonmicro.com>
 <20121113055618.GC18224@opensource.wolfsonmicro.com>
 <20121113131219.GA29198@opensource.wolfsonmicro.com>
 <20121114012007.GD4415@opensource.wolfsonmicro.com>
 <20121114104854.GB23525@opensource.wolfsonmicro.com>
 <20121114105106.GK7407@opensource.wolfsonmicro.com>
 <20121114113138.GC23525@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vdqwC0msT4ilQ2it"
Content-Disposition: inline
In-Reply-To: <20121114113138.GC23525@opensource.wolfsonmicro.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vdqwC0msT4ilQ2it
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2012 at 11:31:38AM +0000, Charles Keepax wrote:
> In the absence of a physical reset line the chip is reset by writing the
> first register, which is done after the register patch has been applied.
> This patch synchronises the register cache after the reset to preserve
> any register changes that had been applied.
>=20
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Please submit patches as covered in SubmittingPatches, you've added a
random "Re" to the subject line...

--vdqwC0msT4ilQ2it
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQo4GeAAoJELSic+t+oim9PjEP+gKfs1sNUT3vjVrbOtZ54Nti
+fgDC5mmLOPOAJvNz7RcfSNSKvJHB2Fq3FgaHsXgIgoQa1KKOnSPneiCaPdvvD4Y
rWjVfpnghqdkpiZHOSpEHsd2LGj6U/p4eyCZKmrwcZBdb1eSxmKE2ObymAuxvHlE
1DsVY9PYeRv9Hpsi2I580zpkq6kwIOHJncxIYR3mQ6DuLRqXIwcbjCOi4gM911MV
/AzV/QXvOqkc7bXpZy72UR6gU2ZH1tdF75o4dSBTcjyNCpCM6z6aPzty8UgQrG2c
LV7uDol3jJubh/wWCRslgvs+mrf28xFIasIHgy13mgV0cEtDNrkfuEzqs/gMg106
Sw+WWCmm0XzgJbceLxalULqu863TGDTm/dG6m3+HDqSlKH2JwygrbQ0hOy2h3MOF
kNfnacz9JLE1JMFtqiCgFcr4UZ5LErdFhLzVKKUtDVI6jRmKLEiz1irfe+s2+1b7
TqQ5SJ87ya4FlLdXtN1SjgPoNODJ3tr6IoZ+2JTew3YjrlP9c7UOM8xhMNjwTQXm
XPlCl9Kt7Dn1uMUYAhybAkGfxf7DqXm68hQNRiUGCMY/6WQRRB3QwQwZ279F0mmo
0LiZyB/RC0xwbnCPFXY0mEFgsSpjYgdAABYfXdjudAG6AFtrNxpDN7aSHS8d/MGs
iOouX9oGecXpK65Il4fz
=UPbZ
-----END PGP SIGNATURE-----

--vdqwC0msT4ilQ2it--
