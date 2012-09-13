Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2IMHgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:36:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40064 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2IMHgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:36:41 -0400
Date: Thu, 13 Sep 2012 17:36:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Iglesias =?UTF-8?B?R29uc8OhbHZleg==?= 
	<siglesias@igalia.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Jens Taprogge <jens.taprogge@taprogge.org>
Subject: Re: linux-next: manual merge of the staging tree with the tty tree
Message-Id: <20120913173637.dbbe51c2ca99bdb0a00a961b@canb.auug.org.au>
In-Reply-To: <1347519565.4539.204.camel@fourier.local.igalia.com>
References: <20120913161417.e863926832ccf8a2e1ca1f2a@canb.auug.org.au>
	<1347519565.4539.204.camel@fourier.local.igalia.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Sep_2012_17_36_37_+1000_RWOsyMxBaz+UJkkd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Sep_2012_17_36_37_+1000_RWOsyMxBaz+UJkkd
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

On Thu, 13 Sep 2012 08:59:25 +0200 Samuel Iglesias Gons=C3=A1lvez <siglesia=
s@igalia.com> wrote:
>
> On Thu, 2012-09-13 at 16:14 +1000, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the staging tree got a conflict in
> > drivers/staging/ipack/devices/ipoctal.c between commit 734cc1783816
> > ("TTY: use tty_port_register_device") from the tty tree and commit
> > 2afb41d9d30d ("Staging: ipack/devices/ipoctal: Check tty_register_device
> > return value") from the staging tree.
> >=20
> > I fixed it up (I think - see below) and can carry the fix as necessary
> > (no action is required).
>=20
> I don't see tty_port_register_device in any header file in staging.
>=20
> Is it defined in tty tree and it is not merged into staging tree?

Yes, that is the case.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Sep_2012_17_36_37_+1000_RWOsyMxBaz+UJkkd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUY0FAAoJEECxmPOUX5FEFTQP/308VkRwQkByTP67YRd6lH8B
bF04389pq/Tl0Uf6s+MbUIQgY7a72SvD5DDxJDbqpwAt2nsJNBw9T5bTrsKqKkdF
Xg+eP9ohY0gqiAQTkppup1akD2N1Xwnr7Kx3LkpRYwsMSRHPUCGPOvuPkNwiat2N
EsUrFyqcEAMKH+Jc3ix+bqoMya9k1eei4lC3jW163ZL2NXw/E00L7DuYxGGzqKql
Xu4Na6IJOlIynWXHQE2d8yrRwKTlGHPSLqisnVs1W+PjHaTeVvov9/aBBHuYakJB
ArZgRN8RAa9Xyfz6KkYacffLdBVelotaoXCNRu0jG7+7/0MEgwuP1QARnpv/q5OD
9LDn4rJ4fkUJ3WAvE27f5FjKrmBxfQpvPXt43lxWID5KLkwAOpQnE+0kJJWHDUwQ
l8mALslPiWTU++GqKWuMSnwDDXqxBf3n1+IpuJcDN0WA9nPhTPzL2hVevUmKB5vx
MdgvaAVmtSFKLr3/oXmx5OJh9Jj1YjZy6rti4LgoNto4S2KTVdZPRHOgrPCm+9D8
GKwDUyXXVOKjIeIdv2gtLt9Na2jgK2hQkQfvfh4DPv+mQ7PO7pEDgMTNFZN7QMIz
eKHSxYjcxBChuP6pqKrZSwGecf6idTaQl9OWRIg62+QV9/h3K5NzivYONr8rLfku
+8aLVMGuN9zv62THcjB1
=cLdt
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Sep_2012_17_36_37_+1000_RWOsyMxBaz+UJkkd--
