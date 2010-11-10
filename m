Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab0KJWSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:18:09 -0500
Received: from ms01.sssup.it ([193.205.80.99]:49992 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756610Ab0KJWSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:18:07 -0500
X-Greylist: delayed 718 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2010 17:18:06 EST
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
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
In-Reply-To: <1289410114.2084.23.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>  <1289410114.2084.23.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wEBHLMvTCtru36+JakIz"
Date: Wed, 10 Nov 2010 23:17:56 +0100
Message-ID: <1289427476.13577.285.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wEBHLMvTCtru36+JakIz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-11-10 at 18:28 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:27 +0200, Raistlin wrote:
> > +struct sched_param_ex {
> > +       int sched_priority;
> > +       struct timespec sched_runtime;
> > +       struct timespec sched_deadline;
> > +       struct timespec sched_period;
> > +       unsigned int sched_flags;
> > +
> > +       struct timespec curr_runtime;
> > +       struct timespec used_runtime;
> > +       struct timespec curr_deadline;
> > +};=20
>=20
> It would be better for alignment reasons to move the sched_flags field
> next to the sched_priority field.
>=20
Makes sense, thanks. :-)

> I would suggest we add at least one more field so we can implement the
> stochastic model from UNC, sched_runtime_dev or sched_runtime_var or
> somesuch.
>=20
Ok, no problem with that too.

BTW, as Dhaval was suggesting, are (after those changes) fine with this
new sched_param? Do we need some further mechanism to grant its
extendability?
Padding?
Versioning?
void *data field?
Whatever?

:-O

I'd like very much to have some discussion here, if you think it is
needed, in hope of avoiding future ABI issues as much as possible! :-P

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-wEBHLMvTCtru36+JakIz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzbGhQACgkQk4XaBE3IOsQ90QCfRP8NzibPzbGbQnAf+G3VSHMq
TfcAnj/RosjA+99NqI619zqRfZgaqb0J
=1jaT
-----END PGP SIGNATURE-----

--=-wEBHLMvTCtru36+JakIz--

