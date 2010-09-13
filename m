Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0IMHl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 03:41:56 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:41186 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0IMHlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 03:41:55 -0400
Date: Mon, 13 Sep 2010 09:42:33 +0200
From: Nico Schottelius <nico-linux-20100709@schottelius.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, nico-linux-20100709@schottelius.org,
        torvalds@linux-foundation.org, peterz@infradead.org, flo@xssn.at,
        lenb@kernel.org, jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, rjw@sisk.pl, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] x86, tsc: Fix a preemption leak in
 restore_sched_clock_state()
Message-ID: <20100913074233.GA2674@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100709@schottelius.org>,
	mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
	a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
	peterz@infradead.org, flo@xssn.at, lenb@kernel.org,
	jbarnes@virtuousgeek.org, suresh.b.siddha@intel.com,
	tglx@linutronix.de, rjw@sisk.pl, mingo@elte.hu,
	linux-tip-commits@vger.kernel.org
References: <1284150773.402.122.camel@laptop>
 <tip-55496c896b8a695140045099d4e0175cf09d4eae@git.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <tip-55496c896b8a695140045099d4e0175cf09d4eae@git.kernel.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.36-rc3-00464-g84e1d83 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Good morning,

tip-bot for Peter Zijlstra [Sat, Sep 11, 2010 at 07:49:07AM +0000]:
> Commit-ID:  55496c896b8a695140045099d4e0175cf09d4eae
> Gitweb:     http://git.kernel.org/tip/55496c896b8a695140045099d4e0175cf09=
d4eae
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Fri, 10 Sep 2010 22:32:53 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 11 Sep 2010 09:47:07 +0200
>=20
> x86, tsc: Fix a preemption leak in restore_sched_clock_state()

running 2.6.36-rc3-00464-g84e1d83 now, which includes that fix.

So far no resume issues, but the backlight does not power on again,
if the lid is opened.

Manually triggering display backlight increase (via fn-home)
changes it to 100% though.

I've not seen that behaviour for a very long time and never on the
X201. It has been an issue on the X200, which means probably around
2.6.30.

Cheers,

Nico

--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyN1egACgkQ19zI5DGHffB1RwCgsMTzp71S/F1S4fFqoeNxbps0
X68AoOyQXZmy8R3McHsbM6B6hC/mDf2t
=hFk1
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
