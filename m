Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab2JTHEt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 03:04:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33452 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2JTHEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 03:04:48 -0400
Date: Sat, 20 Oct 2012 18:04:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
Message-Id: <20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
In-Reply-To: <CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
	<20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
	<CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__20_Oct_2012_18_04_36_+1100_Qs7h062CnkpLWqm/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__20_Oct_2012_18_04_36_+1100_Qs7h062CnkpLWqm/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 16 Oct 2012 07:50:52 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Mon, Oct 15, 2012 at 7:41 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git kvmt=
ool/for-linus
> >
> > So you have not taken this in the v3.7 merge window.
> >
> > Will you ever merge this?
>=20
> I have yet to see a compelling argument for merging it. It's tons of
> code, it doesnt match the original "small simple" model, and I think
> it would be better off as a separate project.

So are there any compelling arguments from the proponents, or can I
remove this from linux-next (and have it removed from the tip auto-latest
branch)?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__20_Oct_2012_18_04_36_+1100_Qs7h062CnkpLWqm/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQgk0EAAoJEECxmPOUX5FEjusP/jch5zhp4ilbD3Oj9DL1ApKq
OVBKC/C9Q7pDrMM7pzCAfUO61CO2HD4Q+xoBQFSwcjHeU8HTlZB8GsnNzC4kU8j5
yPVOydt8ezsI/vLI0xwyYunWU9BUIn94z0pvA7xbU7gC6iv71FC/iRqVeYcq+sKS
jwY7eHc14rQwG6jmcn9pTZbMXTG7vzFTPguRQPUsM6V6G36I7DgRbkAREQJxXgZk
4swLasIdHxPM14gTGR06FNcao6DTA7R76Ugvgh/qkRCQm4X7f4x32rHM1mG2NcUa
uDnWaQfYMjKaHWwC0MSHN6l7+YwkKWi1t0gvUN9yzk9fxYGQMFOECUtGRm6Qwu4O
uroigAzkkFQ/2yj5Dqt952VT5MUqUyV5f+Q+eR8nB9wpcDM/5SDSbBQAYvtQWiwo
6Kwy4nlIaDAK6sY5VjcYa3Upme4oLH9aqqQ/4nwy1NLNqnbR8CfUoMl1y+ck9iB0
5eAw+pqq2wVsekaFh3wUa+Pl/HH95gyV2EIxUSi9q8wiafaCWrDiDncWrYAMdwVs
pNvjaooYTjQCeeec8/CxvsfQE0P9WWyxVO52EFyRbfNeAW2plxrhOuJ9aDgXguYY
U3egWhcr3gFqdmwTmACruDO9hsH5h66V+62Kgr+CVqaoKbROyCgGmgP3efFBVc8E
qVzeptMbYipmd0OG2XPC
=mPTz
-----END PGP SIGNATURE-----

--Signature=_Sat__20_Oct_2012_18_04_36_+1100_Qs7h062CnkpLWqm/--
