Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0LMDqB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 22:46:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36136 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab0LMDqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 22:46:00 -0500
Date: Mon, 13 Dec 2010 14:45:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Ed Tomlinson <edt@aei.ca>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: rcu-walk and dcache scaling tree update and status
Message-Id: <20101213144555.17aa7826.sfr@canb.auug.org.au>
In-Reply-To: <20101213025910.GA6981@amd>
References: <20101213023733.GB6522@amd>
	<201012122153.33427.edt@aei.ca>
	<20101213025910.GA6981@amd>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__13_Dec_2010_14_45_55_+1100_kN7fJ_7rTPG/UiS_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Dec_2010_14_45_55_+1100_kN7fJ_7rTPG/UiS_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nick,

On Mon, 13 Dec 2010 13:59:10 +1100 Nick Piggin <npiggin@kernel.dk> wrote:
>
> On Sun, Dec 12, 2010 at 09:53:32PM -0500, Ed Tomlinson wrote:
> >=20
> > I get this when building:
> >=20
> > security/security.c: In function 'security_inode_exec_permission':
> > security/security.c:520: error: 'rcu' undeclared (first use in this fun=
ction)
> > security/security.c:520: error: (Each undeclared identifier is reported=
 only once
> > security/security.c:520: error: for each function it appears in.)
> > make[1]: *** [security/security.o] Error 1
> > make: *** [security] Error 2
> >=20
> > Missing include maybe?
>=20
> Ah, missed permutation while doing a final build check. `rcu` should
> just be renamed to `flags`.

You will, of course never put anything not build tested into a tree for
linux-next inclusion, right?  ;-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__13_Dec_2010_14_45_55_+1100_kN7fJ_7rTPG/UiS_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNBZbzAAoJEDMEi1NhKgbsT08IAJs2m7e9YDPzOQoqtSXQy6zk
3/ox+NJ1SWoBAGopemFY4gPMBdXHFobRrcszXeX9vj9DMo1N8pSyYwC4OWe9Yh6V
kHqFdqo1i+CxWGC77GLS+2sebnGVoRjdcUhVCgJHhAE66WHFYQmYw2gITXBcwZ21
1V69TRB3C3ngVU2JzOfU1CqI0gtZi88JCeLP+fBgqpNSHtjqDzhKz8KqD52HFhWu
s0P2lw2cyJDPNoZ1Fs2wO21F5tHkWUQpPwIP9lYkBmXFnY0qSmXFl65ug388zyNZ
noast2ckXYDdkHoGapeqW5s9cQm2/SHWVZ5+at2vG2XGch6fLFixFPFcsqou2Dk=
=x+NF
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Dec_2010_14_45_55_+1100_kN7fJ_7rTPG/UiS_--
