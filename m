Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab1HDAtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 20:49:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35089 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182Ab1HDAtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 20:49:36 -0400
Date: Thu, 4 Aug 2011 10:49:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: linux-next: Tree for Aug 3 (efivars/pstore)
Message-Id: <20110804104927.be96accd4f255d2537d7372a@canb.auug.org.au>
In-Reply-To: <20110803104030.3c6443ab.rdunlap@xenotime.net>
References: <20110803151651.687fc6f377e255eccf58301b@canb.auug.org.au>
	<20110803104030.3c6443ab.rdunlap@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Aug_2011_10_49_27_+1000_G+QZc3kG1ifK01Q6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Aug_2011_10_49_27_+1000_G+QZc3kG1ifK01Q6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Wed, 3 Aug 2011 10:40:30 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
>
> What is this warning about?  I don't see the problem.
>=20
> The warning only happens on i386 AFAIK.  Must be some typedef glitch?
>=20
> drivers/firmware/efivars.c:602: warning: initialization from incompatible=
 pointer type

The second argument to the write method in a pstore_info is supposed to
be "unsigned int" but the assigned function has "int" in the
!CONFIG_PSTORE version.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__4_Aug_2011_10_49_27_+1000_G+QZc3kG1ifK01Q6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOeyXAAoJEDMEi1NhKgbsdMUH/015pHB1inkGgEZy2ymkBd2r
W4uPpfF1U2+/kzafjhX+dQb0K+4qHrCnhY3nl7LufYNPgVb4BnhSvt2fJU6ZbEgf
q5ZsarZSXp3yfmtEf9RyhnKDJSXHdtaxZtZ30m4PfW2uHUkSa6AAEVR0bW/oCdng
W1bWhW6goF5aKjFyipWuuW2kCVokVvVJIQhnr65939GGH+ZJNPz6k1wZpQWz6PuM
rTp7APHMahBzRmFTlyAYvVzusppjQZkX0be1EmeCDukq4NQbXvBVd7lZ6gjQqOpv
xfErraKqHBJEJ9UXl1kM910YA4kcYrS5JQxrxhk67Kk/gMrckljPQIpnWMFdbZk=
=rw0I
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Aug_2011_10_49_27_+1000_G+QZc3kG1ifK01Q6--
