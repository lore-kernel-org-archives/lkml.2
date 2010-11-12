Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab0KLQP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:15:59 -0500
Received: from ms01.sssup.it ([193.205.80.99]:51755 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752510Ab0KLQP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:15:58 -0500
Subject: Re: [RFC][PATCH 12/22] sched: add runtime reporting for -deadline
 tasks
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
In-Reply-To: <1289504223.2084.174.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334202.8661.153.camel@Palantir>  <1289504223.2084.174.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eItr7ie7Kq5gkXEjd+vv"
Date: Fri, 12 Nov 2010 17:15:43 +0100
Message-ID: <1289578543.6525.535.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eItr7ie7Kq5gkXEjd+vv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 20:37 +0100, Peter Zijlstra wrote:
> > -#ifdef CONFIG_SCHEDSTATS
> >  struct sched_stats_dl {
> > +#ifdef CONFIG_SCHEDSTATS
> >  	u64			last_dmiss;
> >  	u64			last_rorun;
> >  	u64			dmiss_max;
> >  	u64			rorun_max;
> > -};
> >  #endif
> > +	u64			tot_rtime;
> > +};
> > =20
>=20
> I know we agreed to pull this from the sched_param2 structure and delay
> exposing this information for a while until the base patches got merged
> and came up with a solid use-case,=20
>
Sure! :-)

> but reading this patch makes me
> wonder why tsk->se.sum_exec_runtime isn't good enough?
>
Might be, but what you usually want is something reporting you total
runtime from when you became a -deadline task, which may not be the case
of sum_exec_runtime, is it?

BTW, again, let's postpone this.

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-eItr7ie7Kq5gkXEjd+vv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzdaC8ACgkQk4XaBE3IOsQj1gCgmx4THFD4a7DcFHFetsxj68eV
0j8AnA0juSTdHX1cjAcKTAnN+jrR9ngd
=WB+f
-----END PGP SIGNATURE-----

--=-eItr7ie7Kq5gkXEjd+vv--

