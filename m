Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab1IJPLQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 11:11:16 -0400
Received: from home.keithp.com ([63.227.221.253]:33973 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933138Ab1IJPLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 11:11:15 -0400
From: Keith Packard <keithp@keithp.com>
To: Francis Moreau <francis.moro@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.1-rc5 is the worst
In-Reply-To: <CAC9WiBjoO50H5ZQEShbdZ=64ZXz6Q-OdD+VSD-YrBry3hvdJJQ@mail.gmail.com>
References: <CAC9WiBjoO50H5ZQEShbdZ=64ZXz6Q-OdD+VSD-YrBry3hvdJJQ@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 10 Sep 2011 08:11:10 -0700
Message-ID: <yunbousl9f5.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 10 Sep 2011 11:57:06 +0200, Francis Moreau <francis.moro@gmail.com>=
 wrote:

> 3/ video: Intel Corporation Core Processor Integrated Graphics
> Controller (rev 18) drived by 'i915': sometime after resuming or after
> leaving the black screensaver, the screen seems to be frozen and I
> need to switch to tty1 and switch back to the graphic screen in order
> to make the screen refreshed again.

Can you try disabling fbc and see if this helps?

i915.i915_enable_fbc=3D0

We've gotten a few minor regression reports that this fixes; we're
working on isolating the cause if possible.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOa34OQp8BWwlsTdMRAtmmAKClrw/u5XgJWutM/MLVJVuM256OJwCffi+g
exJYyscfTnSV7HEIzgj5z4A=
=+Upl
-----END PGP SIGNATURE-----
--=-=-=--
