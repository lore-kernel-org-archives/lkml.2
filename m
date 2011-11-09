Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab1KIGhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 01:37:33 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:47026 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1KIGhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 01:37:32 -0500
Date: Wed, 9 Nov 2011 17:37:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Kyungmin Park'" <kyungmin.park@samsung.com>, linux-next@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: incorrect build fix
Message-Id: <20111109173722.a7f4c7d65c13bcb80bf2e6ba@canb.auug.org.au>
In-Reply-To: <003401cc9ea6$785e7dc0$691b7940$%kim@samsung.com>
References: <20111109082624.ea5697763c50ef9128244783@canb.auug.org.au>
	<003401cc9ea6$785e7dc0$691b7940$%kim@samsung.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__9_Nov_2011_17_37_22_+1100_rjuHPwVXhkywzhzu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Nov_2011_17_37_22_+1100_rjuHPwVXhkywzhzu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 09 Nov 2011 15:11:50 +0900 Kukjin Kim <kgene.kim@samsung.com> wrote:
>
> I'm not sure following......
> So only for THIS_MODULE, <linux/export.h> should be added instead of
> <linux/module.h>?

Yes, that is correct.   It means that much less code is included.  If
replacing module.h with export.h causes other build errors, they should
be fixed by including the correct files directly (module.h include a lot
of other include files).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Nov_2011_17_37_22_+1100_rjuHPwVXhkywzhzu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOuh+iAAoJEECxmPOUX5FEcD4P/RBEYoXhXwcaXcs/5vbCS/ct
qa2v2DFk545vsiWOz57m3N7ioipPrHsDm72t6zKIgY4BKXslP6pGtrPc9rWKGxGA
lBURsM/hBY+YF4gNHRMfe/G6qcxd+12tAw9xzSzX1Oe5OFDa9jBaTCP1bOmJTqWu
yRFf+QkYn7SGvSFKJj7yj7wJ0bmCvriig9AGyYu8S//EOv3kJJhHT3r9DtuXR7wx
fYrr7VeGPLD7X0eKxOYcn2Adg4V1LJvnoViGGXdSnns7JMZCd+0sChXgi69zS0bD
mvGpCYS3y25P+M5zqtc3LWzvp0y8MPZ6XJdsUPkAjbQDWDLpP+Nnot4cJYfLVCwS
u6xZW49zmKpITjBSBiQmnHitAp6GGh4+XppHE/PCJ3jrmhWiM+P0sRbrfcWu4jSd
Vtceg2JOAjFlNQrUJfOdd0JpRWic6blJf4gz+r5hg1jCXH9VQho8THxn7+HBL1/h
UYpS9NrdjadW9cces1LHrUsoHIUyqN+zzG4Tt6Gfh26Si+xQh7pHGQLy0nUXQIBi
+Ul8ZRfoKCxOgBE+JeERJnv2RouNr0xe3szuUdV78ItzSGM4iyCxkhb6rMXCivG2
JbtdDbhAcklkTeF0O04zvJ2FQ5faokOndX/L+vn8P+kjLEDzpRgb4p1wlLotasc3
M2TVxkHD1sB0ombba2n/
=cUuI
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Nov_2011_17_37_22_+1100_rjuHPwVXhkywzhzu--
