Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab0KKOdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:33:21 -0500
Received: from ms01.sssup.it ([193.205.80.99]:38021 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753188Ab0KKOdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:33:20 -0500
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
In-Reply-To: <1289485509.2084.120.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333814.8661.146.camel@Palantir>  <1289485509.2084.120.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8dUUMKEa5KjwLiSIybv/"
Date: Thu, 11 Nov 2010 15:33:11 +0100
Message-ID: <1289485991.6525.14.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8dUUMKEa5KjwLiSIybv/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 15:25 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:30 +0200, Raistlin wrote:
> > +static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p=
,
> > +                                 int flags)
> > +{
> > +       if (!dl_task(rq->curr) || (dl_task(p) &&
> > +           dl_time_before(p->dl.deadline, rq->curr->dl.deadline)))
> > +               resched_task(rq->curr);
> > +}=20
>=20
> every moment now a patch will hit -tip that ensures
> ->check_preempt_curr() is only called when both the current and waking
> task belong to the same sched_class.
>
Again, I saw your fix to this, which is later than this patchset... :-)

I'll take care of this while rebasing right in these days.

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-8dUUMKEa5KjwLiSIybv/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzb/qcACgkQk4XaBE3IOsRnCwCfb6tScCoXsz80up/9/y7dUhmw
1LUAoJ07vaVIHdZUUwgUtrt0xUKxJxi+
=jOHn
-----END PGP SIGNATURE-----

--=-8dUUMKEa5KjwLiSIybv/--

