Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab0KLTID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:08:03 -0500
Received: from ms01.sssup.it ([193.205.80.99]:60663 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932261Ab0KLTIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:08:01 -0500
Subject: Re: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline
 tasks
From: Raistlin <raistlin@linux.it>
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Cc: Luca Abeni <luca.abeni@unitn.it>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
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
        Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <4CDD8279.1020803@sssup.it>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334546.8661.161.camel@Palantir>  <1289513573.2084.199.camel@laptop>
	 <1289576177.6525.509.camel@Palantir> <1289577841.2084.302.camel@laptop>
	 <4CDD7C65.9090400@unitn.it>  <4CDD8279.1020803@sssup.it>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1DNn6lh8IKbWsyml7Cco"
Date: Fri, 12 Nov 2010 20:07:46 +0100
Message-ID: <1289588866.6525.709.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1DNn6lh8IKbWsyml7Cco
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-12 at 19:07 +0100, Tommaso Cucinotta wrote:
> Let me underline a few key points, also about the technique suggested by=20
> Zijlstra:
>
> [...]
>
> I can see 2 major drawbacks:
>    a) you need to compute the "\psi" in order to use the "Corollary 10"=20
> of that paper, but that quantity needs to solve a LP optimization=20
> problem (see also the example in Section 6); the \psi can be used in Eq.=20
> (36) in order to compute the *expected tardiness*;
>
> [...]
>
Wow man! You really know what "give us details" means, don't you? :-PP

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-1DNn6lh8IKbWsyml7Cco
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzdkIIACgkQk4XaBE3IOsQ5rACfYzhfhYexfpGi1DKUmbWN8Zpe
ZYIAmwbNWb3hHXojo3w6YNdLkDa8xrJv
=D6gV
-----END PGP SIGNATURE-----

--=-1DNn6lh8IKbWsyml7Cco--

