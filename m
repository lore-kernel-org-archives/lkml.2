Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab0KJXGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:06:10 -0500
Received: from ms01.sssup.it ([193.205.80.99]:43568 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756496Ab0KJXGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:06:09 -0500
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
In-Reply-To: <1289415017.2084.32.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>  <1289415017.2084.32.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kCpOmpq8c7T/fH9D6pyu"
Date: Wed, 10 Nov 2010 23:05:53 +0100
Message-ID: <1289426753.13577.275.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kCpOmpq8c7T/fH9D6pyu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-11-10 at 19:50 +0100, Peter Zijlstra wrote: =20
> > +int sched_setscheduler_ex(struct task_struct *p, int policy,
> > +                         const struct sched_param *param,
> > +                         const struct sched_param_ex *param_ex)
> > +{
> > +       return __sched_setscheduler(p, policy, param, param_ex, true);
> > +}
> > +EXPORT_SYMBOL_GPL(sched_setscheduler_ex);=20
>=20
> Do we really need to pass both params? Can't we simply create a struct
> sched_param_ex new_param =3D { .sched_priority =3D param->sched_priority =
};
> on stack and pass that?
>=20
We can. I'll do that way.

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-kCpOmpq8c7T/fH9D6pyu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzbF0EACgkQk4XaBE3IOsQjnwCfVXH+FaG6+bH44iYJHOrqcrzk
HssAoK5V1gegadqd92hjeJg+oBOu4Hts
=n/6v
-----END PGP SIGNATURE-----

--=-kCpOmpq8c7T/fH9D6pyu--

