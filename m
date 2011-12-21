Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1LUT7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:59:37 -0500
Received: from home.keithp.com ([63.227.221.253]:59593 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1LUT7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:59:35 -0500
From: Keith Packard <keithp@keithp.com>
To: Udo Steinberg <udo@hypervisor.org>, intel-gfx@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: GPU hung with Linux-3.2-rc6
In-Reply-To: <20111221195410.5e4c065a@x220.fritz.box>
References: <20111221195410.5e4c065a@x220.fritz.box>
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 21 Dec 2011 12:00:37 -0800
Message-ID: <864nwty9sq.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Dec 2011 19:54:10 +0100, Udo Steinberg <udo@hypervisor.org> wrot=
e:
> Hi,
>=20
> With Linux-3.2-rc6 I'm frequently seeing GPU hangs when large amounts of
> text scroll in an xterm, such as when extracting a tar archive. Such as t=
his
> one (note the timestamps):

Can you try with semaphores disabled?

i915.semaphores=3D0

And, you should be able to remove the explicit rc6 argument now; if it
will work, the kernel should turn it on automatically.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTvI65TYtFsjWk68qAQhOSRAAwvLU/dNPJdnX1vNqpWML0yQGLGYSHR0B
2w+71NfyRZCXrcQlpdFNAaNNvw4a0ZHty0ZrEYh2BRQ9ZUhcxlpHFxu2uN7c+hs1
bNhN3tt/xdBhR3DqwurkOixhRDxwdX8UFCsH5p4gCjrof1ffrDmhCufgxkJl2w9h
8dA+N+T7BhF3aQ8E/rk7c/eK8WvaYBU4cX9968OittGoEVIse2DxM1FgVPLejo88
vmjVFnK9NUcXc6J6aBMWtaZHRPVS6JrXVJfI8t9ZG/70KWDLFnojAwOl4wku92Ps
65I+80nKyH1KBjA2jnllZ3PRoU+eFyPH0jhXKfL9viXLQgtorG2cNGzPiWVQgy7R
0d3IX+6x8gvFdCraBbQ3ujyb33JmEzm9+G3l93xtL1g1Ll7HOEiedPWC0Ln084xZ
EbHCM8c6hHh5+i658bsezRY8wtFvZrQteiD5VpWYTq/h3EG5clR2YABbQA5q4m5O
NjDMuR2zeR52wsWd0XsR4z0/nZoBCwYa8ptR5R9Q36Swb62l02liXTYChUznD8w/
BOLT2b6K2JItjTseIZHyPGtTWeqNChgeWVV68ZjvDdsxmB1ll89+Oyj19INy/hQd
K2IgqeILhctDvc6q+7OCM4kVNCXvC79RUlYraw/JWtzmHQc/kqEuce8MkybTtfs5
JEqDHGwnuFQ=
=5Vud
-----END PGP SIGNATURE-----
--=-=-=--
