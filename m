Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab0KJW0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:26:42 -0500
Received: from ms01.sssup.it ([193.205.80.99]:50166 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757118Ab0KJW0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:26:41 -0500
Subject: Re: [RFC][PATCH 05/22] sched: SCHED_DEADLINE policy implementation
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289418317.2084.50.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333814.8661.146.camel@Palantir>  <1289418317.2084.50.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7/lmts6+eHWGtTyul6sg"
Date: Wed, 10 Nov 2010 23:26:31 +0100
Message-ID: <1289427991.13577.293.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7/lmts6+eHWGtTyul6sg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-11-10 at 20:45 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:30 +0200, Raistlin wrote:
> > @@ -4922,7 +4965,11 @@ recheck:
>=20
> if you add:
>=20
> QUILT_DIFF_OPTS=3D"-F ^[[:alpha:]\$_].*[^:]\$"
>=20
> to your /etc/quilt.quiltrc, it won't see labels as functions.
>
Mmm... Even if I don't use quilt at all and all this is the output of
git-format-patch? :-O

BTW, thanks, I'll figure it out! ;-P

Regards,
Dario
--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-7/lmts6+eHWGtTyul6sg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzbHBcACgkQk4XaBE3IOsQGnQCfdpiDs1fZpNZRz79PU7iJM9Vm
xnUAn2DuGPjqY+X1hQy8yR7HbkMbTO6Z
=OPqi
-----END PGP SIGNATURE-----

--=-7/lmts6+eHWGtTyul6sg--

