Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab1GYE3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 00:29:23 -0400
Received: from home.keithp.com ([63.227.221.253]:52601 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab1GYE3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 00:29:17 -0400
From: Keith Packard <keithp@keithp.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Kirill Smelkov <kirr@mns.spb.ru>, Chris Wilson <chris@chris-wilson.co.uk>,
        Luke-Jr <luke@dashjr.org>, intel-gfx@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>
Subject: Re: Major 2.6.38 / 2.6.39 / 3.0 regression ignored?
In-Reply-To: <alpine.DEB.2.00.1107231847520.4843@tiger>
References: <201105201306.31204.luke@dashjr.org> <BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com> <013811$4lfs6@fmsmga002.fm.intel.com> <201105211123.56053.luke@dashjr.org> <aefc95$1usaq@orsmga001.jf.intel.com> <20110528131920.GA10467@tugrik.mns.mnsspb.ru> <20110712171706.GA18414@tugrik.mns.mnsspb.ru> <CAOJsxLEz-fPnb9oYnLMk9UbGqgsfm-g1d2yH=TrEiEk7HvyQzA@mail.gmail.com> <20110722110806.GA29757@tugrik.mns.mnsspb.ru> <yun7h7atcty.fsf@aiko.keithp.com> <20110722202336.GA14375@tugrik.mns.mnsspb.ru> <yunsjpyrqf7.fsf@aiko.keithp.com> <alpine.DEB.2.00.1107231847520.4843@tiger>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sun, 24 Jul 2011 21:29:07 -0700
Message-ID: <yun4o2bj84s.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Jul 2011 18:55:48 +0300 (EEST), Pekka Enberg <penberg@kernel.org=
> wrote:

> I know I sound like a broken record but I really wish you i915 devs were=
=20
> little more eager to revert broken patches early rather than late. I mean=
,=20
> this particular breakage was already bisected but nobody said or=20
> did anything - and it's not like it's the first time either!

We've switched processes starting with 2.6.39 and I think we're doing
better in this regard. For this particular issue, the regression came
with 2.6.38, and the revert was too large for me to consider merging
just before 3.0 shipped -- I knew reverting it *would* cause problems
for anyone using UMS on newer hardware.

> I suppose I need to bribe Linus somehow to be more strict with you
> folks.

He nicely delivered the message for you a few months ago in person.

In any case, I'm hoping that my smaller fix will resolve the problem and
also not cause regressions for other users.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOLPETQp8BWwlsTdMRAmJtAKDKjDF7qKcLn9qNYlwp8HMUXyXz+QCeN60Z
7sG5FdKvPDUtP2PdZfEy4Cs=
=n82z
-----END PGP SIGNATURE-----
--=-=-=--
