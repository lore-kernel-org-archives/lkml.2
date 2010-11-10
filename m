Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab0KJXHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:07:04 -0500
Received: from ms01.sssup.it ([193.205.80.99]:43595 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756496Ab0KJXHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:07:02 -0500
Subject: Re: [RFC][PATCH 03/22] sched: SCHED_DEADLINE data structures.
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
In-Reply-To: <1289415550.2084.38.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333680.8661.142.camel@Palantir>  <1289415550.2084.38.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oSww6cs74NbB3M7KW+aZ"
Date: Wed, 10 Nov 2010 23:06:52 +0100
Message-ID: <1289426812.13577.276.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oSww6cs74NbB3M7KW+aZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-11-10 at 19:59 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:28 +0200, Raistlin wrote:
> > +       /*
> > +        * Bandwidth enforcement timer. Each -deadline task has its
> > +        * own bandwidth to be enforced, thus we need one timer per tas=
k.
> > +        */
> > +       struct hrtimer dl_timer;=20
>=20
> This is for the bandwidth replenishment right?=20
Yep.

> Not the runtime throttle?
>=20
Not, that is done on tick basis, or by means of hrtick, if enabled.

> The throttle thing should only need a single timer per rq as only the
> current task will be consuming runtime.
>
Sure, and that's what the hrtick does (again, if enabled).

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-oSww6cs74NbB3M7KW+aZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzbF3wACgkQk4XaBE3IOsQJgwCggRN4Tf+oz6Zq2WbPYxmh2k9J
PSMAnA422s+09uJZ04oQuyWPTI+Yn4Yp
=aNJ3
-----END PGP SIGNATURE-----

--=-oSww6cs74NbB3M7KW+aZ--

