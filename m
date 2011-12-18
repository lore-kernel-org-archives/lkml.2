Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab1LRWoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 17:44:08 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:39036 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab1LRWoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 17:44:06 -0500
Date: Mon, 19 Dec 2011 09:43:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20111219094359.7006f8971a0cd7f46a88dc9c@canb.auug.org.au>
In-Reply-To: <20111216140039.c279e8d7.akpm@linux-foundation.org>
References: <20111216163928.030494ce1beb330e4e8b7b40@canb.auug.org.au>
	<20111216140039.c279e8d7.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Dec_2011_09_43_59_+1100_FxRis1B9ok=mpCze"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Dec_2011_09_43_59_+1100_FxRis1B9ok=mpCze
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 16 Dec 2011 14:00:39 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Fri, 16 Dec 2011 16:39:28 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > After merging the akpm tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >=20
> > arch/powerpc/kernel/rtas_flash.c: In function 'rtas_flash_release':
> > arch/powerpc/kernel/rtas_flash.c:218:16: error: 'struct proc_dir_entry'=
 has no member named 'count'
> > arch/powerpc/kernel/rtas_flash.c: In function 'rtas_excl_open':
> > arch/powerpc/kernel/rtas_flash.c:343:21: error: 'struct proc_dir_entry'=
 has no member named 'count'
> > arch/powerpc/kernel/rtas_flash.c:348:16: error: 'struct proc_dir_entry'=
 has no member named 'count'
> > arch/powerpc/kernel/rtas_flash.c: In function 'rtas_excl_release':
> > arch/powerpc/kernel/rtas_flash.c:358:16: error: 'struct proc_dir_entry'=
 has no member named 'count'
> > arch/powerpc/kernel/rtas_flash.c: In function 'validate_flash_release':
> > arch/powerpc/kernel/rtas_flash.c:541:16: error: 'struct proc_dir_entry'=
 has no member named 'count'
> >=20
> > Caused by commit aef714db6205 ("core kernel: add refcount type and
> > refcount misuse debugging").
> >=20
> > This would also break in drivers/nubus/proc.c
> >=20
> > I have reverted that commit for today.
>=20
> Thanks.  The plan apepars to be to make `struct kref' usable in this
> situation so I'll drop these patches.

OK, I have dropped that patch from the akpm tree in linux-next.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Dec_2011_09_43_59_+1100_FxRis1B9ok=mpCze
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7myvAAoJEECxmPOUX5FEiK8QAKPTh92CVv8TwejEnnKLnKg2
qCmkSp7UyCxc4hAkP3JJlcxK4zD9PhnpHlCoNcFle/usqvmpPpjllhfnb05rpFCx
24hULpd5AnObJsdKT3CF1V37FHrAYKdVZIMCP8pS8jCFyFJfMoEUF8abuV6lGc03
A4TFbiA5+nYWgfk1YrZ/vRrEHpKtIDSZimyp0gL+tE2A3UIQqUzDp1yZmihIgkeE
5ZOyFYZqzuf3mptyVt0tMcYOtpwdISOC+Y1e0n6KbRAtfWcdWLzByNyq8UuzDEWR
ZBkqmrTp5ZAtkiPzEliuHPAy+KP1kyF2eDaThrLG4kehcyDVO6OoxyPWktUj3RvT
BxFnTEf8BRmNCbjgiYOnNP2rkqtnSu6IM//S/3ZucIZWssAnxB0ya9vMQpwtFQt+
8oVf9niImMcayr2XVA/jqbo/mKyToAEzrIe4tdmFsGzf8MLx64CrYZ2gJi0NXMX2
z+YvnG6iy24OGm5ZxdEEOKE5O4BhSs+e8BQHtrS5TDZqBEOgBsb+TjKKicDjqesl
sCNn92k18Sqy/n+kCu1BPm4f9vjj9RCnVkPYBnRDzduPQ/F+vghhnghB7p5mPZCw
+AOyFwrd+JaBd2liDZ7YIbrr43p3xJUkEAX4FGEac0pIgjjIU5ENDMpxPMYzmIgd
yOZnRRGiGgd28EQwoO6T
=xc1P
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Dec_2011_09_43_59_+1100_FxRis1B9ok=mpCze--
