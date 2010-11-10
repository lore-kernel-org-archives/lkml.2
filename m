Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab0KJWpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:45:49 -0500
Received: from ms01.sssup.it ([193.205.80.99]:40605 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757010Ab0KJWps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:45:48 -0500
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
From: Raistlin <raistlin@linux.it>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        Luca Abeni <luca.abeni@unitn.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <AANLkTing2SPvnHUg4tHtn4rp9XYhq3Wip5nFWNVg16W3@mail.gmail.com>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir> <20101110160004.GA9092@gondor.retis>
	 <AANLkTing2SPvnHUg4tHtn4rp9XYhq3Wip5nFWNVg16W3@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tJ3lVUplMNasOE5oX8Yf"
Date: Wed, 10 Nov 2010 23:45:35 +0100
Message-ID: <1289429135.13577.303.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tJ3lVUplMNasOE5oX8Yf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-11-10 at 17:12 +0100, Dhaval Giani wrote:
> >> + *  @curr_runtime       task's currently available runtime
> >> + *  @used_runtime       task's totally used runtime
> >> + *  @curr_deadline      task's current absolute deadline
> >> + *
> >> + * Given this task model, there are a multiplicity of scheduling algo=
rithms
> >> + * and policies, that can be used to ensure all the tasks will make t=
heir
> >> + * timing constraints.
> >> + */
> >> +struct sched_param_ex {
> >> +     int sched_priority;
> >> +     struct timespec sched_runtime;
> >> +     struct timespec sched_deadline;
> >> +     struct timespec sched_period;
> >> +     unsigned int sched_flags;
> >> +
> >> +     struct timespec curr_runtime;
> >> +     struct timespec used_runtime;
> >> +     struct timespec curr_deadline;
>=20
> Can we expose soem of these details via schedstats as opposed to a syscal=
l?
>=20
Actually, good point... schedstats seems very reasonable to me... What
do the others think?

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-tJ3lVUplMNasOE5oX8Yf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzbII8ACgkQk4XaBE3IOsTVRQCglhkXiMchvjHxKvSQss3O/ML/
SZoAmwRI8kRMSvZEnOYYw2C6m8j6nxuK
=O0I2
-----END PGP SIGNATURE-----

--=-tJ3lVUplMNasOE5oX8Yf--

