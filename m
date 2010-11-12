Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0KLQOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:14:10 -0500
Received: from ms01.sssup.it ([193.205.80.99]:47881 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810Ab0KLQOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:14:08 -0500
Subject: Re: [RFC][PATCH 15/22] sched: add traceporints for -deadline tasks
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
In-Reply-To: <1289505274.2084.187.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334334.8661.156.camel@Palantir>  <1289505274.2084.187.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GJOZCfx2C5IJtIWmv25y"
Date: Fri, 12 Nov 2010 17:13:29 +0100
Message-ID: <1289578409.6525.533.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GJOZCfx2C5IJtIWmv25y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 20:54 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:38 +0200, Raistlin wrote:
> > Add tracepoints for the most notable events related to -deadline
> > tasks scheduling (new task arrival, context switch, runtime accounting,
> > bandwidth enforcement timer, etc.).
> >
> We've already got sched_switch(), better extend that. Same for the next
> patch, we already have a migration tracepoint, extend that.
>=20
> And I recently rejected a fifo push/pull tracepoint patch from Steve
> because the migration tracepoint was able to provide the same
> information.
>=20
Perfectly fine. I'll see how do that without spamming too much the trace
with data that are meaningless for non-deadline tasks.

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-GJOZCfx2C5IJtIWmv25y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzdZ6kACgkQk4XaBE3IOsRr2wCaAlOEYTgNGS2+x36cTJGRONWd
0C4AoKRgbFJ3gp/rO0JRkehR+4wvl/YI
=wi+n
-----END PGP SIGNATURE-----

--=-GJOZCfx2C5IJtIWmv25y--

