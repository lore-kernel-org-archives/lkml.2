Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab0DLX4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 19:56:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60654 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab0DLX4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 19:56:19 -0400
Date: Tue, 13 Apr 2010 09:56:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       John Kacur <jkacur@gmail.com>, Roland McGrath <roland@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ptrace: kill BKL in ptrace syscall
Message-Id: <20100413095612.2348215e.sfr@canb.auug.org.au>
In-Reply-To: <20100412132910.098e3ddf.akpm@linux-foundation.org>
References: <1269812331-8511-1-git-send-regression-fweisbec@gmail.com>
	<20100329114046.GB16971@redhat.com>
	<520f0cf11003290506o629c9ab6n95c94c48ba24acf4@mail.gmail.com>
	<20100329130526.GA23201@redhat.com>
	<520f0cf11003290626q2e74c5d1r1eebb07a75e25dd5@mail.gmail.com>
	<20100329182204.GE5101@nowhere>
	<20100329183502.GA17842@redhat.com>
	<20100401184855.GB6142@nowhere>
	<20100412132910.098e3ddf.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Apr_2010_09_56_12_+1000_qiJ_8L.2VEWl1g=6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Apr_2010_09_56_12_+1000_qiJ_8L.2VEWl1g=6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 12 Apr 2010 13:29:10 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Thu, 1 Apr 2010 20:48:58 +0200 Frederic Weisbecker <fweisbec@gmail.com=
> wrote:
> >=20
> > I have applied it to:
> >=20
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.g=
it
> > 	bkl/core
>=20
> It hasn't turned up in linux-next yet?

It will be there from today (assuming no problems).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Apr_2010_09_56_12_+1000_qiJ_8L.2VEWl1g=6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvDsxwACgkQjjKRsyhoI8wiCwCfclAVKbSDBvvG41eeTR1Z8n6V
SOoAoIOgdRm+19ib6YHonSgGruI3Ww4b
=6VmZ
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Apr_2010_09_56_12_+1000_qiJ_8L.2VEWl1g=6--
