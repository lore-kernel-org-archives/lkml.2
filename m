Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1DAIF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 04:05:59 -0400
Received: from ms01.sssup.it ([193.205.80.99]:50398 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752005Ab1DAIFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 04:05:42 -0400
Subject: Re: Minimum time slice for relaible Linux execution
From: Dario Faggioli <raistlin@linux.it>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: limp <johnkyr83@hotmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110331151214.GB14441@home.goodmis.org>
References: <SNT111-DS16E628E3B6501DBCF9E19CA7BF0@phx.gbl>
	 <20110331151214.GB14441@home.goodmis.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2tgcjCEWuuagYnwlnscr"
Date: Fri, 01 Apr 2011 10:05:10 +0200
Message-ID: <1301645110.4331.17.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2tgcjCEWuuagYnwlnscr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-03-31 at 11:12 -0400, Steven Rostedt wrote:=20
> On Thu, Mar 31, 2011 at 01:13:55PM +0100, limp wrote:
> > Dear all,
> >=20
> > I have developed a framework similar to a hypervisor that switches betw=
een
> > Linux and a RT domain.
> > As RT priority is of highest importance, I want to give more time to th=
e RT
> > domain *but* I also want to give Linux adequate time for being able to
> > operate.
> >=20
> I'm not sure there is any requirement. The only problem I guess that can
> happen is if you give such little time that the timer interrupt can't
> finish, or that every time you schedule Linux back in, the timer
> interrupt goes off and nothing else gets done.
>=20
Right. Moreover, what you're doing seems very very similar to what these
guys do: https://www.rtai.org/ , http://www.xenomai.org/ .

I've never checked if (and if yes how) they do such thing as you're
thinking, but maybe they do... Have you already looked at them?

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-2tgcjCEWuuagYnwlnscr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk2Vhy8ACgkQk4XaBE3IOsRuKQCeK0BaE3TOW49G1jOVLil56sq2
iDgAni+1JduItKqSRnxJj7EZ6J4tU4bA
=4SA+
-----END PGP SIGNATURE-----

--=-2tgcjCEWuuagYnwlnscr--

