Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1ADScS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:32:18 -0500
Received: from ms01.sssup.it ([193.205.80.99]:43574 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751099Ab1ADScR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:32:17 -0500
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
In-Reply-To: <AANLkTiks650aGw+SZzTYbKvMcn4w56XwQ+h+qT5V5hGD@mail.gmail.com>
References: <1294156524.6169.147.camel@Palantir>
	 <AANLkTiks650aGw+SZzTYbKvMcn4w56XwQ+h+qT5V5hGD@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3GFhFdL0TdmbuCJBaIbR"
Date: Tue, 04 Jan 2011 19:31:43 +0100
Message-ID: <1294165903.6169.215.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3GFhFdL0TdmbuCJBaIbR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-01-04 at 14:18 -0200, Lucas De Marchi wrote:=20
> Hi Dario
>=20
Hi there,

> > Suggestions on how to deal with that will be appreciated.
> >
>=20
> In fact I created the patchset but I didn't have time to finish,
> polish, test and send.=20
>
Heh, I know that feeling! :-)

> There are several corner cases that must be
> treated that made me think if it was really worth the work.
>=20
Ok, again, while git-clone and git-push do their jobs, feel free to
share some of these concerns of yours with me, because I'm not sure I'm
getting here...

> In this repo you can find a greatly outdated branch that treats some
> of the troubles you'll need to think about:
>=20
> git://git.profusion.mobi/users/lucas/linux-2.6.git schedentity
>=20
Ok, this is mine (it'll be ready in a while, I'm pushing it up):

  git://gitorious.org/sched_deadline/linux-26.git schedentity


Right now I'm pushing my schedentity branch and cloning yours! :-D
Unfortunately, both seems to be quite long operations... :-(

> And this was a rebase I did, but irc it was not working well:
>
Well, I'll be very busy in the next days, but I plan to keep this
updated enough, so feel free to comment and/or use it as a basis for
further patching if you think it could help.

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-3GFhFdL0TdmbuCJBaIbR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0jZ48ACgkQk4XaBE3IOsTFwACfXJWnXpCpMgon73feOGkPheFA
OHIAnRFb1JfcfAXSwg6Hx2D4UYth2cad
=JUd/
-----END PGP SIGNATURE-----

--=-3GFhFdL0TdmbuCJBaIbR--

