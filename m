Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab1AEN4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 08:56:12 -0500
Received: from mail.openrapids.net ([64.15.138.104]:57490 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750953Ab1AEN4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 08:56:10 -0500
Date: Wed, 5 Jan 2011 08:56:09 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Valdis.Kletnieks@vt.edu
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 3/5] ftrace trace event add missing semicolumn
Message-ID: <20110105135609.GD31831@Krystal>
References: <20110104231629.996422888@efficios.com> <20110104232419.441463699@efficios.com> <20110105000005.GE2911@nowhere> <20110105001837.GA9737@Krystal> <20110105020759.GG2911@nowhere> <12932.1294196493@localhost> <20110105031016.GI2911@nowhere> <20754.1294209428@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20754.1294209428@localhost>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:54:15 up 42 days, 18:57,  5 users,  load average: 0.00, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> On Wed, 05 Jan 2011 04:10:18 +0100, Frederic Weisbecker said:
> > On Tue, Jan 04, 2011 at 10:01:33PM -0500, Valdis.Kletnieks@vt.edu wrote:
> > > Can DEFINE_EVENT ever be sensibly used in a context where the additio=
nal ; will
> > > cause an issue (for instance, a hypothetical array initialization lik=
e:
> > >
> > > static struct events[] =3D {DEFINE_EVENT(..), DEFINE_EVENT(...) }
>=20
> > You can't do the above as DEFINE_EVENT() do more than just creating a s=
tructure.
> > It can define functions and so.
> >
> > Plus it doesn't behave the same whether CREATE_TRACE_POINTS is defined =
or not:
> > it can either define or declare the functions and structures.
> >
> > > or other places we usually do the 'do { X } while (0)' trick to make =
the code legal?
> >
> > I just can't figure out a sane case.
>=20
> OK..  I was wondering if there was a corner case where we had to resolve =
the
> one versus two semicolon issue in a specific way to guarantee syntactic
> correctness, but it looks like this one gets to fight it out on taste/sty=
le
> grounds...

As I pointed out in my reply to Frederic, the creation of an array of event=
s is
the exact use-case I have in mind. It allows us to shrink the code, remove
dynamic initialization code and to shrink read-write data size significantly
over the current Ftrace trace event scheme.

Thanks,

Mathieu


--=20
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFNJHh5PyWo/juummgRAoJBAJ91F7IddJuZNPACnw5zXunSiOnDCACeMxmt
wWSbMc+6kRhrxJqBf1SuhRw=
=/URE
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
