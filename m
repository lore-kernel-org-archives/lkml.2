Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2CVWTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 18:19:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53041 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab2CVWTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 18:19:12 -0400
Date: Fri, 23 Mar 2012 09:19:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Mar 22
Message-Id: <20120323091900.d3c007d76b49d4053457906e@canb.auug.org.au>
In-Reply-To: <4F6B88D2.5060500@redhat.com>
References: <20120322170829.38a649b3f84d225d94808648@canb.auug.org.au>
	<4F6B88D2.5060500@redhat.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__23_Mar_2012_09_19_00_+1100_7LKQh7kJ8dr.s6FV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Mar_2012_09_19_00_+1100_7LKQh7kJ8dr.s6FV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Thu, 22 Mar 2012 17:17:22 -0300 Mauro Carvalho Chehab <mchehab@redhat.co=
m> wrote:
>
> Em 22-03-2012 03:08, Stephen Rothwell escreveu:
> > Merging edac/linux_next (4d096ca MAINTAINERS: add an entry for Edac San=
dy Bridge driver)
>=20
> Not sure what's happening, but I've updated my EDAC tree a few days ago,
> and I've added more stuff yesterday, but you're still pointing to an
> old changeset.
>=20
> Could you please check if it is pointing to the right tree/branch? It sho=
uld be:
>=20
> 	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git lin=
ux-next

Well, I am still using the infradead.org repo.  I will start using the
above today. (and it looks like the branch is actually linux_next)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__23_Mar_2012_09_19_00_+1100_7LKQh7kJ8dr.s6FV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPa6VUAAoJEECxmPOUX5FEiUIQAIFnxw7zKRPqX/QeIF3nDFgo
kFWuESWOWK7ITptjFyyX6Q81NQZ2OszXuAxwVOlVJSILMeZZcHz1QZ+rCZSawr33
O5hzQQkLo4pVuPXoynUwkHpDdsMwL1gVoSYU/bmKSMa3XOgcqN4cv4wYKWVvCrpr
vMm00SIQOWOnwS1ONapGKFglvYTB7ssGUuh5MWBtf1yE2+k+p8YEYBjvS8btDBke
dBxYF3yHJxueuv5RASaY0CHfC98xZ7+PCrNpuN6iP+14dtQdMVFW4ewnlkdjBHvv
MQNN8DSeMD8J2Q4iMR3cypJyGgQqpWoeXP5rNz0hom/gxXgyi2FH23muhr0RYZwB
a7DE1xb7OKHqtz1/MU86yj34ET5ZhaJYLb6K5zAt8OH4zo0mmx7LUAX0YhoUzf3k
Cl6tk6a/iDXiyqEhoLeMPseIdo30Grqr2HmE+fzOPyo9sDJgpYvgTRq0xy8lG09/
19gN00RSpVahOIRia+PIGJqBdou0l4UYx1HRgVlFTqxTY9f44VXyUoyTCpRtZKvS
C0tfbwDJF9F0+JHxFr2kEoba0o4jHxZ0fAZCXVm4clGZYdlCfCTuWkh/oJ4TJtEO
I74vVbX0CLjRWNhbTrfGpq1JueAE/J5RTagz6XYRPZTsILcT9NC8MUUkhgM/9t6r
BqcbmZfOMTq8beoHkomJ
=Wkv7
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Mar_2012_09_19_00_+1100_7LKQh7kJ8dr.s6FV--
