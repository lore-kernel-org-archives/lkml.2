Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1GVUuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 16:50:13 -0400
Received: from home.keithp.com ([63.227.221.253]:53066 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067Ab1GVUuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 16:50:11 -0400
From: Keith Packard <keithp@keithp.com>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Pekka Enberg <penberg@kernel.org>, Chris Wilson <chris@chris-wilson.co.uk>,
        Luke-Jr <luke@dashjr.org>, intel-gfx@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>
Subject: Re: Major 2.6.38 / 2.6.39 / 3.0 regression ignored?
In-Reply-To: <20110722202336.GA14375@tugrik.mns.mnsspb.ru>
References: <201105201306.31204.luke@dashjr.org> <BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com> <013811$4lfs6@fmsmga002.fm.intel.com> <201105211123.56053.luke@dashjr.org> <aefc95$1usaq@orsmga001.jf.intel.com> <20110528131920.GA10467@tugrik.mns.mnsspb.ru> <20110712171706.GA18414@tugrik.mns.mnsspb.ru> <CAOJsxLEz-fPnb9oYnLMk9UbGqgsfm-g1d2yH=TrEiEk7HvyQzA@mail.gmail.com> <20110722110806.GA29757@tugrik.mns.mnsspb.ru> <yun7h7atcty.fsf@aiko.keithp.com> <20110722202336.GA14375@tugrik.mns.mnsspb.ru>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 22 Jul 2011 13:50:04 -0700
Message-ID: <yunsjpyrqf7.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Jul 2011 00:23:36 +0400, Kirill Smelkov <kirr@mns.spb.ru> wrote:

> What kind of a workaround are you talking about?

Just reverting the commit -- that makes your machine work, even if it's
wrong for other machines.

> Sorry, to me it all looked like "UMS is being ignored forever".

You're right, of course -- UMS is a huge wart on the kernel driver at
this point, keeping it working while also adding new functionality
continues to cause challenges. We tend to expect that most people will
run reasonably contemporaneous kernel and user space code, and so three
years after the switch, it continues to surprise us when someone
actually tries UMS.

> I'm out of office till ~ next week's tuesday, and on return I'll try
> to test it on the hardware in question.

Let me know; I've pushed this patch to my drm-intel-fixes tree on
kernel.org in the meantime; if it does solve the problem, I'd like to
add your Tested-by: line.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOKeJ9Qp8BWwlsTdMRAvXYAKDF8zwWU1IKmoVNqi3fMFN96yOt3QCg5+Uh
yGztqg30t/EFCeuZ6/HjcdM=
=R+VG
-----END PGP SIGNATURE-----
--=-=-=--
