Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0HKHii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:38:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51612 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab0HKHig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:38:36 -0400
Date: Wed, 11 Aug 2010 17:38:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Fomenko <ext-alexey.fomenko@nokia.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Michal Marek <mmarek@suse.cz>,
        Trevor Keith <tsrk@tsrk.net>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20100811173829.40638b5d.sfr@canb.auug.org.au>
In-Reply-To: <20100810222310.e04f7031.akpm@linux-foundation.org>
References: <20100811133812.2b594551.sfr@canb.auug.org.au>
	<20100810222310.e04f7031.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Aug_2010_17_38_29_+1000_puo49JNFnvBPZFVK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Aug_2010_17_38_29_+1000_puo49JNFnvBPZFVK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 10 Aug 2010 22:23:10 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> doh.  This?
>=20
>=20
> From: Andrew Morton <akpm@linux-foundation.org>
>=20
> - don't kfree("")
>=20
> - fix one missed conversion
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
> Cc: Trevor Keith <tsrk@tsrk.net>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

works for me, thanks.

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

Now, don't you wish that had been in linux-next?  ;-)

Please send to Linus (if you haven't already) and I will add it to my
fixes tree for linux-next tomorrow unless Linus has taken it by then.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_Aug_2010_17_38_29_+1000_puo49JNFnvBPZFVK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMYlN1AAoJEDMEi1NhKgbs83QH/jjr1uo7qzvsTodT1aW0VCBJ
lLB9lkQhB4RWgSCoaUuN4CZxX9A3fucR3UYk2V1EEf04opMX+m8C0wmHBtJdCUgx
sENQxH6bjU4T4BJeueSsne2yKSHuompuAB6cIBL7J4HJpRa3G2rEUIodTrHI/5O0
Pr5YaaEDPhFEIlu5OuDTK2zuf9gWizfbP6+lm0mvWyE0pcdSkyGeHoY6kXZdLscT
6xv21r/clBl0597CcewwGS5SaMygwh+fgGQ+R6erPaSvWW0ORtHumhlz956WHWYl
NAS/ObQXgkENiZtR3r2kcuStHt3CJuxcBxFaP8fqoroIzZBZ8W9GmDvOGiqmZfc=
=1z88
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Aug_2010_17_38_29_+1000_puo49JNFnvBPZFVK--
