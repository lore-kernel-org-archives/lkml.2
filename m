Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1LLDaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:30:55 -0500
Received: from home.keithp.com ([63.227.221.253]:39356 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab1LLDaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:30:52 -0500
From: Keith Packard <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed address is invalid"
In-Reply-To: <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
References: <1323648762-2148-1-git-send-email-keithp@keithp.com> <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
User-Agent: Notmuch/0.10.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sun, 11 Dec 2011 19:31:30 -0800
Message-ID: <867h22jwj1.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 11 Dec 2011 18:59:43 -0800, Linus Torvalds <torvalds@linux-foundati=
on.org> wrote:

> Interesting. Current -git works for me on my 11" Macbook Air. Which
> should be identical to yours. This is the 4GB RAM, 128GB disk version,
> no?

Mine does have the larger disk (256GB), otherwise they should be identical.

> But I'm running OpenSUSE, and you're running Debian, right? And our
> kernel configs are probably wildly different, since I tend to try to
> boot a fairly minimal set.

I've got an ancient kernel config that has been culted along for several
years; I do build a ton of useless modules, but I boot without an
initrd, so it seems like there shouldn't be many differences by the time
this crashes.

> That said, if you've verified that if fails for you, I guess we should
> revert regardless. Matt, any suggestions for tests to do?

Of course I'd be willing to do whatever tests someone would like to
suggest; just that I don't know how to get a netconsole on this machine,
which makes it pretty hard to figure anything out before the screen
lights up.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTuV1kjYtFsjWk68qAQhfSxAAt2gkvNBzAF5AU8FrKL0odayF3BrfD7QJ
5pN2AAQjcWoK93x+TgbjoOVIaCtzTRJ/sHTMSxGpEKamQSOEbvuKw5Vh6NZalETT
ZZEjUIhTz87tUuXi9v9kUhZblLpwpAuzv4HzoIDJazyTnZw8q0LB6Bc1hoBcffYl
G7X8zumenqUQZulKiEeqoffITN01QB6zwWAIOPjAiprEvrgdERD7XNyZpjbKAkXK
+NNLOrxExY5GF7ZeD6GvcASgmDR519ie6+xFDi8IbTMmESqQYq3QvfMzvT4mgIMO
1F3SPnbnNdFS2ntH2hKdb0G7qODHRsvZZq4qpcw+EGdVGzryZ8RPQdmJxzONJsc8
sf1R65TSn2C3uwGHdJttgaWSC04zdd67Hjd99SQNnlhNIbtTpTy1OpD40IBED/Ck
Vfw7/K25qDbyrSyAHaXjIzEAtHZNsxcKYY7TpIe54WbYon8e4bnHK+46Y2hZ4ZUA
SpIjBwr9lMl43JEs99SowAtoFI9qZpfNlzN6tLP1uH7r4NStKHnyy7gG/4LSz7Eb
NwEoYzdb2Rkr4vj/jfIpy8y5JZbO7Hhy9+qahL7cQ6934YwD072we5dV4V9Qk1kM
KPv8dNi8ZEGcg5n9yfthPVEegoRWRK4DtHu3ERldNCkIkoHV1gCC9Mc/i3KOzXFM
znSzS7jL7Xc=
=5mi0
-----END PGP SIGNATURE-----
--=-=-=--
