Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab2CBIrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:47:12 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621Ab2CBIrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:47:11 -0500
Message-ID: <4F508908.4010907@nod.at>
Date: Fri, 02 Mar 2012 09:47:04 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: linux@openrisc.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] OpenRISC: Use generic bitops.h
References: <1330649715-32438-1-git-send-email-richard@nod.at>  <1330649715-32438-2-git-send-email-richard@nod.at> <1330671026.19557.99.camel@satguru>
In-Reply-To: <1330671026.19557.99.camel@satguru>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6936FB24B4A2CCA46E0890BB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6936FB24B4A2CCA46E0890BB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 02.03.2012 07:50, schrieb Jonas Bonn:
> On Fri, 2012-03-02 at 01:55 +0100, Richard Weinberger wrote:
>> There is no need to reinvent the wheel.
>=20
> NAK... we have optimized versions for some of these operations so the
> generic header isn't right for us.

Sorry, I missed that.

> Have a look at arch/openrisc/asm/include/bitops.h to see which function=
s
> we override with accelerated versions.

Okay, but some operations are missing in your bitopts.h.
Like test_bit_le() or find_next_zero_bit_le().

#include <asm-generic/bitops/le.h>
Should to the job...

Thanks,
//richard


--------------enig6936FB24B4A2CCA46E0890BB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPUIkMAAoJEN9758yqZn9eULgIALHpfupAcH1yRBiguP18V3fA
UWhNrtSoCSwRI+T1nPsD+FQM/U9oIDVxCcu7SFVyWj7xriCqEZU5s9AeIz/U75Ir
1SWoFILIs5W4ypM/jZvrb2pByDXswd8RCOZD75fdWf11gP/EyGKXotLvmuTniomn
Yb0VtCnQ7BU8VAaN1mkx0WmeLQk5RjHLxKHkj8JFYAdO2LDeskucl5yYVu3nSSoi
DcfU/1xwkCHnFO2DafF7IwbEZ76OlD+YrZTSHKdnixgCwhkz3oWzDm+YI6tDdPFR
h2+nxVWRFB4Mg2AW4z4G3Dte0JxMYlJ7GbSPIfRxQyovs1e5bvFK/obfTz8PWMg=
=iEnx
-----END PGP SIGNATURE-----

--------------enig6936FB24B4A2CCA46E0890BB--
