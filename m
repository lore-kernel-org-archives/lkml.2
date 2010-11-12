Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab0KLTT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:19:26 -0500
Received: from ms01.sssup.it ([193.205.80.99]:35537 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932089Ab0KLTTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:19:25 -0500
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
From: Raistlin <raistlin@linux.it>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
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
In-Reply-To: <1289580772.12418.405.camel@gandalf.stny.rr.com>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>
	 <1289579924.12418.404.camel@gandalf.stny.rr.com>
	 <1289580222.2084.318.camel@laptop>
	 <1289580772.12418.405.camel@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EBNn8xH5RpDQf3AsO8ml"
Date: Fri, 12 Nov 2010 20:19:09 +0100
Message-ID: <1289589549.6525.720.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EBNn8xH5RpDQf3AsO8ml
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-12 at 11:52 -0500, Steven Rostedt wrote:
> > No, some of the bits in 18/22 come near, but I'd prefer not to add such
> > things until we've got a convincing use-case.
>=20
> I'm fine with that, but I would like to know if the ABI would be able to
> add such an extension in the future if we find a convincing use-case.
>=20
Scared about ABIs' stability eh? :-PP

BTW, in this case everything should be fine, since the very exact
behaviour you described was triggered by a (couple of) flag(s), which
can be added and dealt with during sched_setscheduler2() at any time.

As Peter was saying, see patch 18 for details.

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-EBNn8xH5RpDQf3AsO8ml
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzdky0ACgkQk4XaBE3IOsQ7IQCfd3v3Avn68mqDsyJ5aIVBFyyE
wYQAn2gy1HBT+TSREYjQQu1Wun4SPmR5
=yutQ
-----END PGP SIGNATURE-----

--=-EBNn8xH5RpDQf3AsO8ml--

