Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2CNE3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 00:29:51 -0400
Received: from ozlabs.org ([203.10.76.45]:33389 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab2CNE3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 00:29:49 -0400
Date: Wed, 14 Mar 2012 15:29:44 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: arm build failures (Was: linux-next: triage for March 13, 2012)
Message-ID: <20120314042944.GB26084@thor.bakeyournoodle.com>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Russell King <rmk@arm.linux.org.uk>
References: <20120313234707.GB7050@windriver.com>
 <20120314114115.24e59318bdac705fec61bd89@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <20120314114115.24e59318bdac705fec61bd89@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 14, 2012 at 11:41:15AM +1100, Stephen Rothwell wrote:
> On Tue, 13 Mar 2012 19:47:07 -0400 Paul Gortmaker <paul.gortmaker@windriv=
er.com> wrote:
> >
> > ARM:netx_defconfig,pnx4008_defconfig=20
> > 	when:	Mar 14, 02:43
> > 	why:	net/core/pktgen.c: can't find a register in class 'GENERAL_REGS'
> > 	status:=09
> > 	fix:=09
> > 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5869486/
>=20
> This is this:
>=20
> net/core/pktgen.c:682:2775: error: can't find a register in class 'GENERA=
L_REGS' while reloading 'asm'
> net/core/pktgen.c:682:3153: error: can't find a register in class 'GENERA=
L_REGS' while reloading 'asm'
> net/core/pktgen.c:682:2775: error: 'asm' operand has impossible constrain=
ts
> net/core/pktgen.c:682:3153: error: 'asm' operand has impossible constrain=
ts
>=20
> Which is a do_div() call.  The relevant code does not appear to have
> changed, so this may well be a result of our toolchain changing from
> "arm-linux-gcc (GCC) 4.4.0, GNU ld (GNU Binutils) 2.19.1" to
> "arm-unknown-linux-gnueabi-gcc (GCC) 4.6.3, GNU ld (GNU Binutils) 2.22".

Just for reference I build that code with:
arm-unknown-linux-gnueabi-gcc (GCC) 4.5.2, GNU ld (GNU Binutils) 2.21
and it was fine so I don't think it's to do with the switch from=20
arm-linux-gcc to arm-unknown-linux-gnueabi-gcc[1]

Yours Tony

[1] This switchwas done as a result off the discussion at: http://lists.inf=
radead.org/pipermail/linux-arm-kernel/2010-November/030627.html

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYB64AAoJEEsCiJRY75GKWloQAKdMFZKdAHMesGvhdNuPTJsV
+a43EiT6q6Azu5Y4B1OIfj5cxtvTPkjh/17jZS8wziIEFVhbX4dlqQtxVPeNZcga
46hxsZ1XbAAbGwwKWyXKJ1XfHuTNzo7omDTABO1jWUZ9Mk78clYy97VjqkYKTWka
zs+Y2nnwPYs1cmjqnWoct1pzPhanCf4XjhzT3ETZ6otd0B1eVUhLqumQ0bMepNA7
apUI3fD9G9NTjcihQs9GuocYnmDHMLw41uAbVN3UpRLnumGUkf+K0dZ9gwwwA+br
yVoPjlxHUrrMxldAaHxkqnFSKQQ5u1w9b3O4jiPjRBj4HwKXEqYiJAyth+1TcNDT
cK8Bkj8I2AYJ/fHI/48aeeuvs+Pah/WuWFjG3sSvCC1ba8d2y21PGyFgveH5mIf6
W1mp0qwE8W/IUloNhnd/3vRt/RbbjJNwgXv/45hfIVXP+i9ZX7JqA186NW6/bkam
o5D/DoO8ID+u2RVuHPM0lhSFuf7tqZ1F6uRIyIAdo2UThyhfQDo2HwWoy7gqz9ZR
YkGKzXr2hr50n0vL6mp2qeJaE5IE5JjuBVvB/bGScVS4k5bPQ4IcmodbGSZY6bqx
VaMN4ZrUEjFlMCFpeQXXgOWW9veAXM/xMUYstUXNd5Fvsz1oe8IlLVJpE9QZYWCp
k8mXQFp/qBus9oLZREQy
=qtr7
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
