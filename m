Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab1GaNn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 09:43:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48987 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1GaNn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 09:43:57 -0400
Date: Sun, 31 Jul 2011 23:43:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: atomic_set_mask duplication
Message-Id: <20110731234344.2c80d301a35d44d478a96f7a@canb.auug.org.au>
In-Reply-To: <20110729211906.a98b2965d30694df7e12191f@canb.auug.org.au>
References: <CAMjpGUejy+p2+86DT8-LDMzWYxKKBp=2SQTNZ=7KaFoPMRiJ4A@mail.gmail.com>
	<20110729211906.a98b2965d30694df7e12191f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__31_Jul_2011_23_43_44_+1000_Q_Mtz/+cN6QdhOG0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__31_Jul_2011_23_43_44_+1000_Q_Mtz/+cN6QdhOG0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Fri, 29 Jul 2011 21:19:06 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Fri, 29 Jul 2011 00:47:03 -0700 Mike Frysinger <vapier.adi@gmail.com> =
wrote:
> >
> > seems that my atomic_set_mask() patch for asm-generic/atomic.h has
> > made it into linux-next but duplicated ?  any idea what's going on ?
> >=20
> > commit 00b3c28bd753 is correct.  but then we also have 49472be55954
> > which should not exist ...
>=20
> Right.  The first one is in Linus' tree and the second is the one from
> Andrew's tree and git was fine about reapplying it :-(

I have dropped that patch from my copy of Andrew's tree for tomorrow.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__31_Jul_2011_23_43_44_+1000_Q_Mtz/+cN6QdhOG0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJONVwQAAoJEDMEi1NhKgbsUnMH/3Yepdj23u81Ca7vpLUd/CJS
bbOO8dKTIYldY1dYGx1ala6VHUQEa5YwwAjZCtTQlQqqM/AQT2jXIEGzDq8XQVgf
lpN5zt8cDB/XMeyw1xKeac4K95ehKnSDBw8xukN1tBbz5TLgD2AKNvkAPoeb1ZF2
fIRovsh3RDRADx/a6zFnTjz58ds+FD59mhE1/WQHH0xHEMY9/IN5HB/ytE8AixJe
wwoG1NxVDYpObHhxj2zb/I4q7ZciLY6EMKTisKgE9zCYceeCEuz91Az7jPLjGug0
rXwgP4+aCKJwSUCun4bOAj/Um8jGLIZ/dk7nlI/XKqUadEbP5YemA/o0sJCDnlA=
=SNxg
-----END PGP SIGNATURE-----

--Signature=_Sun__31_Jul_2011_23_43_44_+1000_Q_Mtz/+cN6QdhOG0--
