Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab2AaFQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 00:16:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34944 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab2AaFQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 00:16:17 -0500
Date: Tue, 31 Jan 2012 16:16:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: dedekind1@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>
Subject: Re: mtd api rework
Message-Id: <20120131161608.42c145d8f3f89dd3181cdac5@canb.auug.org.au>
In-Reply-To: <1327933829.13286.6.camel@sauron.fi.intel.com>
References: <1327933829.13286.6.camel@sauron.fi.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__31_Jan_2012_16_16_08_+1100_LeI1Stz/sESaYTx6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__31_Jan_2012_16_16_08_+1100_LeI1Stz/sESaYTx6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

On Mon, 30 Jan 2012 16:30:29 +0200 Artem Bityutskiy <dedekind1@gmail.com> w=
rote:
>
> we are doing MTD API rework and I've just pushed this patch to my l2-mtd
> tree:
>=20
> http://git.infradead.org/users/dedekind/l2-mtd.git/commit/a088d81808f6803=
ca6bfb9ea9148beef53fde1d2
>=20
> Which renames MTD function pointers to make sure no one uses them
> directly. I've build-tested this for i386 and arm and it compiles.
>=20
> However, there may be compile issues in future if one of subsystems not
> aware of the change try to use old names. Please, be aware. The right
> thing to do in this case for the subsystem is to either not use the
> pointer directly and use the corresponding mtd_func() wrapper. Please,
> let me know if there are any issues related to this change.

Thanks for the heads up.  It seems OK so far, but you may want to check
the build results at http://kisskb.ellerman.id.au/linux-next as they
become available.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__31_Jan_2012_16_16_08_+1100_LeI1Stz/sESaYTx6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPJ3kYAAoJEECxmPOUX5FE9BYP/3DgRqGdZKfWC3XrmCani0OE
jeE6QOQS5lpcmVN8bWmnshgGGMZmA7cSO1xpVMp18JFG/3DkIGrFEwrubOkio7TW
P9oW1lAmPFq+eGPhPY/V/IgDwQriFnLLCmtWmMYJX4KbsCo9GyNUW6CDCWxgUtFw
ZS2ifEw1YzFW5sqlghkWIEsCFMk1rigErg5daLmIh7ItRhDS8eN01NEEA8tWem99
QhcZt+hXRze8PQxEFjh/g19pfQO4ZG+IQmSMGNwU++CcjXHREHLQ1mm+2LdDx82g
t4eL140E518lp3q8OAiXu1hKx3XFeVYsUZV8vWk7YE3JfL08a8r6zzNKpK3UBsbr
M20OeumOgxatbfrGxKzKnLXomTc5/o9G9hO9kCWmjQeNodDeNjy+NVhHbMRf3O3K
FSkYrkhIFlNh1zKJ9xcBjbZw5A2I9tRqmVYfEfr1nltzZNQCPDhUNymPmjsnQHpB
jWBKHAh8ORIMF7xdqAdnyQVuSRvDFqPpZmHeOBs7HoaES8j2PcbL2Frs9UT27Yp5
BmDr0XlmZUwYNhUbz8YVcuSUyL/F5VDxsBfGOli4Mn1d63xk2icSYyKrdTdonuba
cEYcH1ctACecX4wQ315dMn5O1RXua7hU73FXwgjnBhL0+Xp1wvY4dOmadsiM/J7l
7t13eAvnUm7O6I3tEiNz
=ZheV
-----END PGP SIGNATURE-----

--Signature=_Tue__31_Jan_2012_16_16_08_+1100_LeI1Stz/sESaYTx6--
