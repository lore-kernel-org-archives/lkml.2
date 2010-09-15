Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab0IOICi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 04:02:38 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:46725 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab0IOICe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 04:02:34 -0400
Date: Wed, 15 Sep 2010 10:03:26 +0200
From: Nico Schottelius <nico-linux-20100709@schottelius.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Nico Schottelius <nico-linux-20100709@schottelius.org>,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        peterz@infradead.org, flo@xssn.at, lenb@kernel.org,
        jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] x86, tsc: Fix a preemption leak in
 restore_sched_clock_state()
Message-ID: <20100915080326.GB2666@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100709@schottelius.org>,
	Jeff Chua <jeff.chua.linux@gmail.com>, Ingo Molnar <mingo@elte.hu>,
	mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
	a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
	peterz@infradead.org, flo@xssn.at, lenb@kernel.org,
	jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
	tglx@linutronix.de, rjw@sisk.pl, linux-tip-commits@vger.kernel.org
References: <1284150773.402.122.camel@laptop>
 <tip-55496c896b8a695140045099d4e0175cf09d4eae@git.kernel.org>
 <20100913074233.GA2674@schottelius.org>
 <20100913084619.GC23741@elte.hu>
 <AANLkTikN5AxqmdHhkkrE9SmhaMxkFjRXnOSguyeJDtXM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <AANLkTikN5AxqmdHhkkrE9SmhaMxkFjRXnOSguyeJDtXM@mail.gmail.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.36-rc3-00464-g84e1d83 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Jeff Chua [Tue, Sep 14, 2010 at 06:56:42AM +0800]:
> On Mon, Sep 13, 2010 at 4:46 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Nico Schottelius <nico-linux-20100709@schottelius.org> wrote:
> >
> >> Good morning,
> >>
> >> tip-bot for Peter Zijlstra [Sat, Sep 11, 2010 at 07:49:07AM +0000]:
> >> > Commit-ID: =A055496c896b8a695140045099d4e0175cf09d4eae
> >> > Gitweb: =A0 =A0 http://git.kernel.org/tip/55496c896b8a695140045099d4=
e0175cf09d4eae
> >> > Author: =A0 =A0 Peter Zijlstra <peterz@infradead.org>
> >> > AuthorDate: Fri, 10 Sep 2010 22:32:53 +0200
> >> > Committer: =A0Ingo Molnar <mingo@elte.hu>
> >> > CommitDate: Sat, 11 Sep 2010 09:47:07 +0200
> >> >
> >> > x86, tsc: Fix a preemption leak in restore_sched_clock_state()
>=20
> > Might make sense to bisect it ... as long as you remember to do this at
> > every bisection step that has the hung-suspend bug:
>=20
> Have you tried just running "echo mem >/sys/power/state" to see if that w=
orks?

I'm using pm-suspend, which probably does nothing else.

The strange thing though is that I cannot reproduce the bachlight off
situation anymore :-/

Will keep an eye on it and report back if I see anything not working.

Regarding suspend: No crash so far! (after about 10-15 suspend & resumes)

Cheers,

Nico

--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyQfc4ACgkQ19zI5DGHffCzTgCeKJGLomfesoB3iI1kCPVdO2HT
7aIAn2NsOTqSs33Hh6p/Lkbc9fnXwxwz
=B4ZG
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
