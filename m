Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab0LSOCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 09:02:43 -0500
Received: from uucp.gnuu.de ([83.246.114.63]:3666 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab0LSOCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 09:02:42 -0500
X-Greylist: delayed 1415 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Dec 2010 09:02:42 EST
X-DKIM: Sendmail DKIM Filter v2.5.2 uucp.gnuu.de 32568488087
Date: Sun, 19 Dec 2010 14:27:05 +0100
From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: Oops in trace_hardirqs_on (powerpc)
Message-ID: <20101219132705.GE6615@alea.gnuu.de>
References: <20100806233157.GA7117@alea.gnuu.de>
 <1285184671.26872.127.camel@gandalf.stny.rr.com>
 <20100927125037.GA4497@alea.gnuu.de>
 <1285639094.2989.1.camel@frodo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dzs2zDY0zgkG72+7"
Content-Disposition: inline
In-Reply-To: <1285639094.2989.1.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dzs2zDY0zgkG72+7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

Steven Rostedt hat am Mon 27. Sep, 21:58 (-0400) geschrieben:
> On Mon, 2010-09-27 at 14:50 +0200, J=F6rg Sommer wrote:
> > Hello Steven,
> >=20
> > Steven Rostedt hat am Wed 22. Sep, 15:44 (-0400) geschrieben:
> > > Sorry for the late reply, but I was on vacation when you sent this, a=
nd
> > > I missed it while going through email.
> > >=20
> > > Do you still have this issue?
> >=20
> > No. I've rebuild my kernel without TRACE_IRQFLAGS and the problem
> > vanished, as expected. The problem is, that in some cases the stack is
> > only two frames deep, which causes the macro CALLER_ADDR1 makes an
> > invalid access. Someone told me, there a workaround for the problem on
> > i386, too.
> >=20
> > % sed -n 2p arch/x86/lib/thunk_32.S
> >  * Trampoline to trace irqs off. (otherwise CALLER_ADDR1 might crash)
>=20
> Yes, I remember that problem. When I get back from Tokyo, I'll tried to
> remember to fix it.

Did you've fixed this problem? The bug report is still marked as open.
https://bugzilla.kernel.org/show_bug.cgi?id=3D16573

Regards, J=F6rg.
--=20
Begebenheit aus dem wahren Leben:
Mediziner: ICEs sind die wei=DFen Z=FCge.
Mathematiker: Das ist falsch. Jeder ICE ist zwar wei=DF, aber nicht alle
  wei=DFen Z=FCge sind ICEs.

--Dzs2zDY0zgkG72+7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0OCCgACgkQwe0mZwH1VIClwgCfWOiK7rMhb1pvLCTPbogFGJKY
4YgAn2ruSTXz84YqT7fDyFiY9S6aRHad
=ElQJ
-----END PGP SIGNATURE-----

--Dzs2zDY0zgkG72+7--
