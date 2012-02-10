Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899Ab2BJSxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:53:38 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43767 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab2BJSxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:53:36 -0500
Message-ID: <1328900144.22240.94.camel@sauron.fi.intel.com>
Subject: Re: [Cocci] Re: [PATCH] scripts/coccinelle/misc/boolinit.cocci:
 semantic patch for bool issues
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Michal Marek <mmarek@suse.cz>,
        Gilles Muller <Gilles.Muller@lip6.fr>, bruce.w.allan@intel.com,
        rusty@rustcorp.com.au, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Julia Lawall <julia@diku.dk>
Date: Fri, 10 Feb 2012 20:55:44 +0200
In-Reply-To: <1328899861.14197.7.camel@joe2Laptop>
References: <1328893887-28932-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1328895943.14197.1.camel@joe2Laptop>
	 <1328899454.22240.91.camel@sauron.fi.intel.com>
	 <1328899861.14197.7.camel@joe2Laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-vo0RNvXxx4wT9dTXkb1R"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vo0RNvXxx4wT9dTXkb1R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-02-10 at 10:51 -0800, Joe Perches wrote:
> On Fri, 2012-02-10 at 20:44 +0200, Artem Bityutskiy wrote:
> > On Fri, 2012-02-10 at 09:45 -0800, Joe Perches wrote:
> > > On Fri, 2012-02-10 at 18:11 +0100, Julia Lawall wrote:
> > > > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > > Thanks Julia.  It seems to work well.
> > I wonder though, why would we want to change if (a =3D=3D true) with if=
 (a)
> > etc? Julia did not provide the explanation in the commit message but
> > referred to you and Rusty in the semantic patch.
>=20
> Testing booleans against specific values is poor form.
> booleans should be tested or !tested.

OK, so this is about taste, I thought there is a more serious reason.

> If you are going to submit these patches,
> I suggest you break them out by 2nd level
> directory.

No, I was just trying to help Julia a bit and let her spend more time
writing good spatches. I am not going to sumbit patches, sorry.

--=20
Best Regards,
Artem Bityutskiy

--=-vo0RNvXxx4wT9dTXkb1R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPNWgwAAoJECmIfjd9wqK0b8sQAJHhZgeE7dFXI5Fnqdlp3NFe
8ePZJU9tKd0YyWGyaMGtGKiX0mY3/rymGCsagrRD5PuUka++/ymssnpw8bfK/uWn
TvpTjTNVpPolS1KauLB0QSTR+dQo4Dv5H8fuR2H83fFZMqHkOIKVpFWG2cajUQnZ
V/UF13CYmr8xY1KmVqGvJLe5WyxyAfWjHQDYuKXClVHcvwXMi/M5foINXdB6iNTB
LKkHDgP9fRLHpPoBtBWf4vjbFMdZiqC+i+OjZO0BAZ0x00Brp6RSZ48vDfZqKtSq
W2gv1XPesFqI4WsWJwEneO7/9Ur7Z5h/OJi+L4PvYFLtjJWnlZFFCTA4kJ1VmQAE
dXA926HqpUh35DWl4vC2PWkBB/JMfoxDNMqa0aup54CTC4y7YKFVBttcM1vZi6Er
yvMEp/QFYX/cRGMgh9WT//gSlBapnMfyWmbNbj54pekmwRm22VwgCoyjXeQ4Lvd8
H9vUL3lB6CSzSPAZ/D09PbJR5soC5G7q6wUlrxQDSW7zS3JCT6zRnhax4MrLRuZC
qb4T+rzoJrHIDF1q/7R6SVaofP267D3jmrovWvTMKU16+td1Z35V2D9MEFX8a8+D
Nk11/hII2yvCI5NvUh/9fNlK+zIASGwHiEdLvpq/hhibW3MPndVwMJG4D5SXjpyu
CK0KtQbXxJgutmM1oAyq
=HzLz
-----END PGP SIGNATURE-----

--=-vo0RNvXxx4wT9dTXkb1R--

