Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab1EQO3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:29:13 -0400
Received: from home.keithp.com ([63.227.221.253]:34360 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab1EQO3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:29:12 -0400
From: Keith Packard <keithp@keithp.com>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [BUG][2.6.39-rc7]
In-Reply-To: <4DD1AAF2.7030502@t-online.de>
References: <4DD0D4CC.9070401@t-online.de> <yunei3y1g9u.fsf@aiko.keithp.com> <4DD1AAF2.7030502@t-online.de>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 16 May 2011 21:18:26 -0700
Message-ID: <yun62pa0xkd.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 17 May 2011 00:53:38 +0200, Knut Petersen <Knut_Petersen@t-online.d=
e> wrote:

> Nice to know that .39 will have the feature to lock screen and all input =
devices
> on exotic hardware like i915GM.

The alternative is to try to include a patch which has seen limited
testing and insufficient review into code which is shipping in a matter
of days. Yes, leaving your machine broken isn't ideal, but the risk of
breaking many (many) other machines which currently work OK is not good
either.

We'll get the patch tested, reviewed and merged shortly, at which point
it will be included in a stable .39.x release, which Linux distributions
are generally happy to pick up.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN0fcSQp8BWwlsTdMRAqNzAKDgcO1sbmd0x8R3BF9CifZwNTgPLgCgront
OHywd+KSSw/9blrL9I7CYiw=
=nW7M
-----END PGP SIGNATURE-----
--=-=-=--
