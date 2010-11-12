Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab0KLVNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:13:00 -0500
Received: from ms01.sssup.it ([193.205.80.99]:46181 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755384Ab0KLVNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:13:00 -0500
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
In-Reply-To: <1289579251.2084.316.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334202.8661.153.camel@Palantir>  <1289504223.2084.174.camel@laptop>
	 <1289578543.6525.535.camel@Palantir>  <1289579251.2084.316.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EU8d/XT4o/dbfZ8MRkQv"
Date: Fri, 12 Nov 2010 22:12:45 +0100
Message-ID: <1289596365.6525.768.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EU8d/XT4o/dbfZ8MRkQv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-12 at 17:27 +0100, Peter Zijlstra wrote:
> > Might be, but what you usually want is something reporting you total
> > runtime from when you became a -deadline task, which may not be the cas=
e
> > of sum_exec_runtime, is it?=20
>=20
> Correct, it wouldn't be. However since I expect a user to be mostly
> interested in deltas between two readings, in which case it really
> doesn't matter, does it?
>
Good point. So we won't need this new stat anyway.

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-EU8d/XT4o/dbfZ8MRkQv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzdrc0ACgkQk4XaBE3IOsR58gCdHNV3SOmryoBHy/g1qQSaGC/A
ky0AoIE6v49X40ommh0x3u9JeGMDUFmf
=BF/f
-----END PGP SIGNATURE-----

--=-EU8d/XT4o/dbfZ8MRkQv--

