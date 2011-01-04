Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab1ADR6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:58:43 -0500
Received: from ms01.sssup.it ([193.205.80.99]:43748 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750886Ab1ADR6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:58:42 -0500
Subject: Re: [RFC][PATCH 0/3] Refactoring sched_entity and sched_rt_entity.
From: Dario Faggioli <raistlin@linux.it>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Dhaval Giani <dhaval@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Darren Hart <darren@dvhart.com>, oleg <oleg@redhat.com>,
        paulmck <paulmck@linux.vnet.ibm.com>, pjt@google.com,
        bharata@linux.vnet.ibm.co
In-Reply-To: <AANLkTi=wCmetef0tjfvdHtZMS9x4eswhL_xAM5Ybdwq+@mail.gmail.com>
References: <1294156524.6169.147.camel@Palantir>
	 <AANLkTi=wCmetef0tjfvdHtZMS9x4eswhL_xAM5Ybdwq+@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fOziwINEVu09uVWwZIx0"
Date: Tue, 04 Jan 2011 18:58:17 +0100
Message-ID: <1294163897.6169.172.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fOziwINEVu09uVWwZIx0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-01-04 at 14:37 -0200, Lucas De Marchi wrote:=20
> > Suggestions on how to deal with that will be appreciated.
>=20
> Don't forget the PI case too. You will need to change
> rt_mutex_setprio() to keep a copy of sched_cfs_entity in struct
> rt_mutex_waiter.
>=20
Mmm... do I? While I'm cloning your git, could you elaborate a bit on
why, because I don't seem to see that... :-P

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-fOziwINEVu09uVWwZIx0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEABECAAYFAk0jX7kACgkQk4XaBE3IOsRgHgCWOlMNP3QIqtcXELh2/NBA0IB6
HwCfc9HQ1We68/0rolTQAkrC8fNsJ+4=
=fFbS
-----END PGP SIGNATURE-----

--=-fOziwINEVu09uVWwZIx0--

