Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512Ab2HYBUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 21:20:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40221 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754629Ab2HYBUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 21:20:06 -0400
Message-ID: <1345857554.4840.43.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 00/11] rcu: Add missing RCU idle APIs on idle loop v2
From: Ben Hutchings <ben@decadent.org.uk>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Chris Zankel <chris@zankel.net>,
        "3.2.x.." <stable@vger.kernel.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Parisc <linux-parisc@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        m68k <linux-m68k@vger.kernel.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Cris <linux-cris-kernel@axis.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>,
        Michael Cree <mcree@orcon.net.nz>
Date: Sat, 25 Aug 2012 02:19:14 +0100
In-Reply-To: <20120824212647.GU2472@linux.vnet.ibm.com>
References: <1345733915-20040-1-git-send-email-fweisbec@gmail.com>
	 <20120824212647.GU2472@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5MPYMRsub3HMuVkiL842"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5MPYMRsub3HMuVkiL842
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-24 at 14:26 -0700, Paul E. McKenney wrote:
> On Thu, Aug 23, 2012 at 04:58:24PM +0200, Frederic Weisbecker wrote:
> > Hi,
> >=20
> > Changes since v1:
> >=20
> > - Fixed preempt handling in alpha idle loop
> > - added ack from Geert
> > - fixed stable email address, sorry :-/
> >=20
> > This time I built tested everywhere but: h8300 (compiler internal error=
),
> > and mn10300, parisc, score (cross compilers not available in
> > ftp://ftp.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/)
> >=20
> > For testing, you can pull from:
> >=20
> > git://github.com/fweisbec/linux-dynticks.git
> > 	rcu/idle-fix-v2=20
> >=20
> > Thanks.
>=20
> I have queued these on -rcu branch rcu/idle:
>=20
> 	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
>=20
> This problem has been in place since 3.3, so it is hard to argue that
> it is a regression for this merge window.  I have therefore queued it
> for 3.7.

I don't follow that; I would expect any serious bug fix (serious enough
for a stable update) to be acceptable for 3.6 at this point.

If the regression occurred in 3.3, then the cc lines should be something
like:

    Cc: <stable@vger.kernel.org> # 3.3+

and not the current:

    Cc: 3.2.x.. <stable@vger.kernel.org>

(Note, version annotations should be on the right of the address, not in
the 'real name' position on the left.)

Ben.

--=20
Ben Hutchings
Experience is what causes a person to make new mistakes instead of old ones=
.

--=-5MPYMRsub3HMuVkiL842
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUDgoEue/yOyVhhEJAQof1w//WDePj4uPLfrD988WfwP4LVTVb2q8sVJV
jDuR71fBG3TJab9OoWW0ltebxCuVPu+662PJoqq/yxyszzpVBOvn9QTSgxjAW77G
hH3mM+uppxmuXk8TOGYhJ+Xxr9QVZ6A6wEP+t7ksBDoLnXhzerKRRy6/2QCn2s3A
YdZb9xQE4uMIXyjOFdNV23BSvhqSCn5jf60RUonUKpjMz41HURfSagbNm49+7vqk
fLMOyAD3gPtM1M17mVoBK7THEYPIRTZ3+zM4T1NzI7+aU6wWtxXkh+m1LFg6jzIn
Qw11M7h0nfErVotHbrX7lgvyScC0xBOHAjpxeN3uuuXLAKcaRep84l1CFQ6J2nc7
LNyKSf8TRugzXu/UamcrsHG7bbr8FR5bzc2+COmIJyhzr2qN2vwCidw2NQG9STOh
6LLvUqu/ICVZAVl1sK6ueI7mgJYpu5G7UBuuiV0eDZVlVAh9ik9crNg/HHJWYYWZ
/1/WfgCOBDczRSTmKK2TNR+iD+c8domANqxXDvEndB6/1GL0tAGYsQNSnB16lPZW
mLMMA+tErYh92ZMnBiVtmCqlfSE5kup/fhB+5snEGgj5zvWpk1z/z+aSudvKlT2j
fFJ67EK3np0y0MCOMaqAzsgDtZz/9LzwAa9MgcxMsInhiSzql25rdcM0yg7AWvCJ
N6wo1sqtKUE=
=CPsq
-----END PGP SIGNATURE-----

--=-5MPYMRsub3HMuVkiL842--
