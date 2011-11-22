Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab1KVKhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:37:11 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:51040 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1KVKhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:37:09 -0500
Date: Tue, 22 Nov 2011 21:36:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH linux-next] iwlegacy: debug.c needs export.h
Message-Id: <20111122213659.3fae12bf805d4dfa4dd6597a@canb.auug.org.au>
In-Reply-To: <20111122075933.GC2199@redhat.com>
References: <20111122142502.ca68d0a1640b2a8480d51ad2@canb.auug.org.au>
	<20111122075640.GB2199@redhat.com>
	<20111122075933.GC2199@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Nov_2011_21_36_59_+1100_tujm4Np9chIbrwpU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Nov_2011_21_36_59_+1100_tujm4Np9chIbrwpU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stanislaw,

On Tue, 22 Nov 2011 08:59:34 +0100 Stanislaw Gruszka <sgruszka@redhat.com> =
wrote:
>
> Fix:
>=20
> drivers/net/wireless/iwlegacy/debug.c:1395:1: warning: data definition ha=
s no type or storage class [enabled by default]
> drivers/net/wireless/iwlegacy/debug.c:1395:1: warning: type defaults to '=
int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
> drivers/net/wireless/iwlegacy/debug.c:1395:1: warning: parameter names (w=
ithout types) in function declaration [enabled by default]
> drivers/net/wireless/iwlegacy/debug.c:1410:1: warning: data definition ha=
s no type or storage class [enabled by default]
> drivers/net/wireless/iwlegacy/debug.c:1410:1: warning: type defaults to '=
int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
> drivers/net/wireless/iwlegacy/debug.c:1410:1: warning: parameter names (w=
ithout types) in function declaration [enabled by default]
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> This is linux-next patch only, in wireless-next we do not have
> include/linux/export.h file.

I will queue this up for as a merge fix in linux-next for tomorrow.
Alternatively, John, you could merge v3.2-rc1 or rc2 into wireless-next
and apply this as a merge fixup.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Nov_2011_21_36_59_+1100_tujm4Np9chIbrwpU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOy3tLAAoJEECxmPOUX5FEKgwQAItb9xocJC/LM+cPDL8DhjeV
K+OBLu0mvTssl6nlpxZxLxx45vugMY61qaPvbJiPye/8sTIaCal9tdIH2si1Ko7p
mEJ8h/Vq44mkAnn0pWWpJ1Q6jQkTe/0RUQXJBhUK9GMAzJwLt4pFgXF+zSpN81pi
3Gyjc8RZYgXm8Rj0aE4pKItNM9pX6MBV3qsml6/9qrD02BztKN6eF3RSIVJlIiit
6qCS83VXwRblD5VheSKVg7d88QIm0x774bgoJEha/bMsjftINo3qDS3zyQED4r8Q
ctYhTTZgEHTaV0IXi73VrDzozF783bQJVhBued8/hyRs0Ks/p/dnjRw2g2DKQZ7F
s0t0IwxdsbGgj8C+2EK8QJ/3M8FdMVqusqMn7p9C0uuD3P0jf/9quJKBq4V+0bvS
UEztDO8y6izVsfoAtdBS7bPk0pc/oDnm/nUAkjGQr/TYzJXWAGdG/s2OF07NO4z/
Iq/C5zn6A0BsOOUi/7RgX7QQjEYIXDEDFJ2SDywAfohPc0wASGtkTS1B4bcegZx7
AAIJvrD6it90IvWmt2Gi4O/NkGRsFvM45kEmlDuKV3DAgecPbeIm+Kn8E1fBq/dX
t1yAl4jiJO55FXILznldpE8LHB9CiZVA9i3s0eL/kOm/Rn/57J0RDKbRuVVLjgYK
3Fj7gV9ne00gyIulhmBm
=/gna
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Nov_2011_21_36_59_+1100_tujm4Np9chIbrwpU--
