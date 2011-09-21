Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1IUTQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:16:24 -0400
Received: from home.keithp.com ([63.227.221.253]:51684 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab1IUTQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:16:23 -0400
From: Keith Packard <keithp@keithp.com>
To: Hugh Dickins <hughd@google.com>
Cc: Francis Moreau <francis.moro@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.1-rc5 is the worst
In-Reply-To: <alpine.LSU.2.00.1109211140170.3200@sister.anvils>
References: <CAC9WiBjoO50H5ZQEShbdZ=64ZXz6Q-OdD+VSD-YrBry3hvdJJQ@mail.gmail.com> <yunbousl9f5.fsf@aiko.keithp.com> <CAC9WiBgn2cr7zY8_9j7SEwQ+rPye9s3cM+Ex4WUxam78qAZhRQ@mail.gmail.com> <yun1uvbf7zp.fsf@aiko.keithp.com> <alpine.LSU.2.00.1109211140170.3200@sister.anvils>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 21 Sep 2011 12:16:19 -0700
Message-ID: <yunzkhxu2nw.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Sep 2011 11:56:31 -0700 (PDT), Hugh Dickins <hughd@google.com> w=
rote:

> I wonder if you're right to disable it just for INTEL_INFO(dev)->gen =3D=
=3D 5.
> On this laptop I have INTEL_INFO(dev)->gen =3D=3D 4, and have had to boot=
 with
> i915.i915_enable_fbc=3D0 since 3.1-rc1 for my xterms to be reliably
> updated.

I should probably just enable it only for newer hardware that appears to
have reliable FBC.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOejgDQp8BWwlsTdMRAs38AJ0TQDegA1lmQ3b3ljiDbRxHvnIIVQCdEiuP
mF1huXkHMyfRFtjL2c8W+W4=
=IzoK
-----END PGP SIGNATURE-----
--=-=-=--
