Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1G2LTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:19:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39342 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756304Ab1G2LTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:19:20 -0400
Date: Fri, 29 Jul 2011 21:19:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: atomic_set_mask duplication
Message-Id: <20110729211906.a98b2965d30694df7e12191f@canb.auug.org.au>
In-Reply-To: <CAMjpGUejy+p2+86DT8-LDMzWYxKKBp=2SQTNZ=7KaFoPMRiJ4A@mail.gmail.com>
References: <CAMjpGUejy+p2+86DT8-LDMzWYxKKBp=2SQTNZ=7KaFoPMRiJ4A@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Jul_2011_21_19_06_+1000_ropb2XVGds6nu/gi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jul_2011_21_19_06_+1000_ropb2XVGds6nu/gi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Fri, 29 Jul 2011 00:47:03 -0700 Mike Frysinger <vapier.adi@gmail.com> wr=
ote:
>
> seems that my atomic_set_mask() patch for asm-generic/atomic.h has
> made it into linux-next but duplicated ?  any idea what's going on ?
>=20
> commit 00b3c28bd753 is correct.  but then we also have 49472be55954
> which should not exist ...

Right.  The first one is in Linus' tree and the second is the one from
Andrew's tree and git was fine about reapplying it :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__29_Jul_2011_21_19_06_+1000_ropb2XVGds6nu/gi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOMpcqAAoJEDMEi1NhKgbs9a0IAKA6D93kgTlTI26adL8/xWZu
wshReUy6a1fCo/mS8zSn/EMdXy8pjF08dE0RmTlvmeuUlS5Vaa+hqahzGX820pGp
BbUFz6T9Gab4BDZqz+cdjtsKR/vmnIsKTnBoiOR0lC0BrPrVYdTbTbNc6/RyhMh0
7dgF3ihgE3MBUYXfQvKTvENwqNGn/+VPDMpw7urZHhP4ar8GC2C/9yx5fX1X6GRJ
wRngxXts9PNh5CDdPtiUp8SH+8lYRVJ3Yc9VGZ2CWjDZ5u1Ykh9cWnh4hTPCxMox
b4b5BnQctr0ko9nAGXTF9tG0dn2tnV6b83z/5RfPnowlmfyVOI8DopeQW0Jmxew=
=F5fC
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jul_2011_21_19_06_+1000_ropb2XVGds6nu/gi--
