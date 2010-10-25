Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab0JYXwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:52:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47065 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170Ab0JYXwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:52:47 -0400
Date: Tue, 26 Oct 2010 10:52:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: coda@cs.cmu.edu, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 25 (coda)
Message-Id: <20101026105239.e3866312.sfr@canb.auug.org.au>
In-Reply-To: <20101025163339.a2ffca49.randy.dunlap@oracle.com>
References: <20101025145834.9b68e026.sfr@canb.auug.org.au>
	<20101025163339.a2ffca49.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__26_Oct_2010_10_52_39_+1100_EvEeHx=3oeWDMo/O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Oct_2010_10_52_39_+1100_EvEeHx=3oeWDMo/O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Mon, 25 Oct 2010 16:33:39 -0700 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> The coda BKL fixes (git tree) are not in here yet, right?

I have no coda tree in linux-next (hint, hint :-)).  However, there were
a few coda patches went into Linus' tree overnight (my time).

> fs/coda/* currently has 12 warnings like these:
>=20
> fs/coda/psdev.c:140: error: implicit declaration of function 'lock_kernel'
> fs/coda/psdev.c:142: error: implicit declaration of function 'unlock_kern=
el'

Hopefully these are fixed today by the above commits?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__26_Oct_2010_10_52_39_+1100_EvEeHx=3oeWDMo/O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxhhHAAoJEDMEi1NhKgbsLvcH/AiWQvTr7JSOVDQ5dG7JBekx
P8y+I+rmfboZo8caQ5lv55y9OTIbfkVAj/qid3LFLXQ+14buoXhCaMe1by8eBRXV
faBP5WFuijQZ5CQkw9U5NlmascTq1CFO73LLs2Pler29X7emhPdOKo9GPTwcajZo
MO495R8DUTEXUrjDs+xrN7E6o7EJym7ielGLlAKmzrCsXvA+sUcSa8lHzTo9V49C
dyX16hS58XQKI7v4N4qx1ATLDjPPHJrlV9Glxo8U4oyY+zTsiL/ZV1hP83DTRYsG
FrlvAOCDIqpauhcWZEy5zEck0Zw6k/D7D8D1GAAtjmayEdSVwmCifQr97+np0HA=
=aXwr
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Oct_2010_10_52_39_+1100_EvEeHx=3oeWDMo/O--
