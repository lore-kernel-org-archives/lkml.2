Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1LFPoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:44:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50068 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149Ab1LFPoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:44:03 -0500
Message-ID: <1323186215.7454.271.camel@deadeye>
Subject: Re: [tip:core/locking] lockdep, bug: Exclude
 TAINT_FIRMWARE_WORKAROUND from disabling lockdep
From: Ben Hutchings <ben@decadent.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Nick Bowler <nbowler@elliptictech.com>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Date: Tue, 06 Dec 2011 15:43:35 +0000
In-Reply-To: <20111206154206.441e85c6@lxorguk.ukuu.org.uk>
References: <tip-xopopjjens57r0i13qnyh2yo@git.kernel.org>
	 <20111206151345.GA22353@elliptictech.com>
	 <20111206154206.441e85c6@lxorguk.ukuu.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3QC/SVshFQafNKWt19Z/"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3QC/SVshFQafNKWt19Z/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-12-06 at 15:42 +0000, Alan Cox wrote:
> On Tue, 6 Dec 2011 10:13:45 -0500
> Nick Bowler <nbowler@elliptictech.com> wrote:
>=20
> > On 2011-12-06 01:38 -0800, tip-bot for Peter Zijlstra wrote:
> > > Commit-ID:  df754e6af2f237a6c020c0daff55a1a609338e31
> > > Gitweb:     http://git.kernel.org/tip/df754e6af2f237a6c020c0daff55a1a=
609338e31
> > > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > AuthorDate: Mon, 14 Nov 2011 13:13:49 +0100
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Tue, 6 Dec 2011 08:16:47 +0100
> > >=20
> > > lockdep, bug: Exclude TAINT_FIRMWARE_WORKAROUND from disabling lockde=
p
> > >=20
> > > It's unlikely that TAINT_FIRMWARE_WORKAROUND causes false
> > > lockdep messages, so do not disable lockdep in that case.
> > > We still want to keep lockdep disabled in the
> > > TAINT_OOT_MODULE case:
> > >=20
> > >   - bin-only modules can cause various instabilities in
> > >     their and in unrelated kernel code
> > >=20
> > >   - they are impossible to debug for kernel developers
> > >=20
> > >   - they also typically do not have the copyright license
> > >     permission to link to the GPL-ed lockdep code.
> >=20
> > This is all bogus.  We have a proprietary module taint for the above.
> > Out of tree does not mean "bin-only", "non-GPL" or anything else like
> > that. =20
>=20
> It also stops people developing drivers of their own who are not
> building them in the kernel tree currently (eg when I'm building tests
> of the GMA500 graphics driver). This is a ludicrous patch and should be
> reverted

My change to set TAINT_OOT_MODULE had the (unintentional) effect of
disabling lockdep for OOT modules.  I subsequently proposed to change
that (while adding taint flags to lockdep output).  This patch doesn't
make any change either way.

Ben.

--=20
Ben Hutchings
Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer

--=-3QC/SVshFQafNKWt19Z/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATt44J+e/yOyVhhEJAQoYGRAAzh5hgn2VFNuIKzmVVhr+hTIkx+y6LytT
G5qJ9NWx8PVf0CGK4xWbgxiLp9T74i5eoRATankPFfbkj73/l1FSYkie28k2lhhv
m2upLCks9wgO9ZWhJkrNG7ae/leI2L7r/ZQ+DC4hac6R4aAuB2n5BJz2n5ikf7FD
LIzkHRjMqf9gEfI3oCyn9LXeMzgM0C4FlNFlneeFgDtsff5/MBWuv45RKlZmuM2P
cQXrBwq305bBYZ04YaPpiMTp+4CnnlzRs644iT/lbTQEXaHuUuvz44PsgVwnYRLX
Z7fxXvdf0EXO2sCc38GChvd6Be+0BhbidPM89DqMzlXZ96KW6uNyMbP8WZcs1MqT
MCt3fc2gwVVA5zva65PdCqkNzUcWwhEDSewYoJRLPyEGewMEfo23RcLzmgdbyIsv
aUcmsGLrBnQ3WEhBWa9w9wPTmgLBSiakSIjU/xcMKcR/gcl9NIYHrjNkpFguTiZo
1qi2I4bLT7zStbh/REfn/qfSIuUxnYRpjlfFGWYuQCHQNUOWvt9i+PYX1AYWaIK7
9a9JSZYf4YpCz100SiJWuMVwnnrOcXr3HCOFYeAqphcXA0fQ53ATYuhtW3+fzmlq
2HieHaQCi+oy3L5tAWONOREpR6uXCg4yaczhmOG/fbUgJMrPaKXcHCUsOvy2t91M
FXV8HVaF0yc=
=7Vz2
-----END PGP SIGNATURE-----

--=-3QC/SVshFQafNKWt19Z/--
