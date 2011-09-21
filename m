Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab1IUOsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 10:48:11 -0400
Received: from home.keithp.com ([63.227.221.253]:53560 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab1IUOsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 10:48:09 -0400
From: Keith Packard <keithp@keithp.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.1-rc5 is the worst
In-Reply-To: <CAC9WiBgTwuQOi0B43kROSN0+cS9bTqLuiKyCxA6DGeTLTfzkcw@mail.gmail.com>
References: <CAC9WiBjoO50H5ZQEShbdZ=64ZXz6Q-OdD+VSD-YrBry3hvdJJQ@mail.gmail.com> <yunbousl9f5.fsf@aiko.keithp.com> <CAC9WiBgn2cr7zY8_9j7SEwQ+rPye9s3cM+Ex4WUxam78qAZhRQ@mail.gmail.com> <yun1uvbf7zp.fsf@aiko.keithp.com> <CAC9WiBhofPXDy+=aMiV4K+LyXMu76vvwGxx-w7biQd8_=WpW5A@mail.gmail.com> <CAC9WiBgTwuQOi0B43kROSN0+cS9bTqLuiKyCxA6DGeTLTfzkcw@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 21 Sep 2011 07:47:52 -0700
Message-ID: <yunpqiueyuf.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Sep 2011 09:57:25 +0200, Francis Moreau <francis.moro@gmail.com>=
 wrote:

> Booting with patch applied, it seems to fix my issue.
>=20
> Futhermore:
>=20
> $ cat /sys/module/i915/parameters/i915_enable_fbc
> -1
>=20
> Hope that helps.

Yup. I'll get it pushed to stable. Thanks very much.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOefkYQp8BWwlsTdMRAqBaAKCAoj8UeDUEmIObqV6wt6TYvrvuqgCdHiSu
eU1z2UmH/hjEoCsnrET3ZY0=
=NLMF
-----END PGP SIGNATURE-----
--=-=-=--
