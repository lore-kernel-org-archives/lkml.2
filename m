Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325Ab0HNHmA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 03:42:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56015 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932895Ab0HNHl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 03:41:59 -0400
Date: Sat, 14 Aug 2010 17:41:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: geert@linux-m68k.org, heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org
Subject: Re: Latest git build failure on s390 - dma_get_cache_alignment()
Message-Id: <20100814174145.567cac3d.sfr@canb.auug.org.au>
In-Reply-To: <20100814163804N.fujita.tomonori@lab.ntt.co.jp>
References: <AANLkTinnLY4LZ-3xbKEJVR3Qjw5xghRZ6i=tWfw8hJHH@mail.gmail.com>
	<20100813154056S.fujita.tomonori@lab.ntt.co.jp>
	<20100813172752.4acd7089.sfr@canb.auug.org.au>
	<20100814163804N.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__14_Aug_2010_17_41_45_+1000_pEB0.AEAOzfaRHbl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__14_Aug_2010_17_41_45_+1000_pEB0.AEAOzfaRHbl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, 14 Aug 2010 16:39:15 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt=
.co.jp> wrote:
>
> > Even better would be to get most of the -mm tree into linux-next
> > itself ... ;-)
>=20
> Yeah, is there any way to push patches into both -mm and linux-next?

-mm is based on linux-next so if something is in linux-next, it will be
in -mm (next time -mm is released).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__14_Aug_2010_17_41_45_+1000_pEB0.AEAOzfaRHbl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMZki5AAoJEDMEi1NhKgbslnEH/0uTO9DFtJgvI1z3XkCpMVvA
Fqxqd+ot8ooWLZwZrrp1COIl1CQSJwe68eg179GDQDE9hkukDZcKupBcjK3ZCZGq
zZ38wdK5xbBzHk0Kyka91BX3j+bwsMhixKju3i0MqZp530kMHHOxD9fIcguJ4j3C
0iMJR/DkWOAssnacbTT5W0A0fUQq3Cl4RjMchlEY2A+ltNGDi7z9hiOvgvfUnNcM
+JrcKtcOG37HzsRBjt4rjUUqZEzuxHmA7kLKGngavepF9uEu3EanZs+ZUJKrckiM
7AqUKXOVAVGWDPzqZhFdBS5JidxHKc3wMZ/w6YmKqBI8K0IMC+42hFDnogQclRA=
=vLcx
-----END PGP SIGNATURE-----

--Signature=_Sat__14_Aug_2010_17_41_45_+1000_pEB0.AEAOzfaRHbl--
