Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1K1RcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:32:04 -0500
Received: from home.keithp.com ([63.227.221.253]:50601 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab1K1RcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:32:02 -0500
From: Keith Packard <keithp@keithp.com>
To: Patrik Kullman <patrik.kullman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915: 3.2 rc1/2 KMS regression
In-Reply-To: <CAGPN=9Tk69_-oNZpabY+9pWnjdLR=AdMY1N7s9iCkRsonCsotQ@mail.gmail.com>
References: <CAGPN=9THOv-M4Td4haE94uDcsAjW3eGMG7ioLeu+p8xUOBPd7w@mail.gmail.com> <861usye0og.fsf@sumi.keithp.com> <CAGPN=9ROa_Pf242jxPy-6XfmFNW3+sCMj6M+pFbw+wgCX3tu1Q@mail.gmail.com> <86sjlccchg.fsf@sumi.keithp.com> <CAGPN=9SLsESVPdwhBwJN9G+nkENcFDqhrcva8GC-VTnx_E=apg@mail.gmail.com> <86pqge96z1.fsf@sumi.keithp.com> <CAGPN=9RZgCJy9hF4RqY1BLmC7cA7QWavWfRM26U3czWZ6RBNMQ@mail.gmail.com> <CAGPN=9Tk69_-oNZpabY+9pWnjdLR=AdMY1N7s9iCkRsonCsotQ@mail.gmail.com>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 28 Nov 2011 09:32:14 -0800
Message-ID: <86d3cc5f1d.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Nov 2011 11:28:53 +0100, Patrik Kullman <patrik.kullman@gmail.co=
m> wrote:
> Ok, so attached are:
>=20
> 3.1.rc6+.dmesg: dmesg from last working commit (before
> dc22ee6fc18ce0f15424e753e8473c306ece95c1) booted with drm.debug=3D4
>=20
> 3.2.rc3+.dmesg: dmesg from 3.2 rc3 with
> dc22ee6fc18ce0f15424e753e8473c306ece95c1 reverted, booted with
> drm.debug=3D4

Thanks. I'm heading to London shortly, but I'll take a look at these
when I've got a few minutes to spare.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTtPFnjYtFsjWk68qAQhwzhAAi/ALprkBGz0b5th3tdayANWm0yTAKLUz
C1M8CyuqxWjl8W+GBZwCufrSDE+MmOx+013mSuTgsXp/w0kMsLT6LLxMXgQ+zpkD
2c9DCfU4JaZgNj8wD7EjTIj+KhCYKEOhxMCqGp+1hv6h8wwQFxlRNUBNI3iyEUvt
nuIGctBSaerjr7cxwxubjW/jWanBr1L6hey+qYiA+cfLouMWJqxEQFa4AuVPiLCD
5O7DDk5jHqsWnBJQam4ge1kENghE0vyWVRVAWmpkqQR/gb3uKXd86gJXhzibv/HE
LS6+Y5Ot7ln79ki1VR0XY+bO1/YmIG3GlmsftSjahPegOKlyrsbq7EGhReT5Lku1
MbudeXEtYMCic5A0FP2hTjzLclA9+qA429Le5rOfHQzgZK/E6WS/4opEvGXbFToc
WjXxf4N6axITbgVbkE3PkAmx/RmFbL1e5PA7G+wRcpZf6RcEvuCFeq1PoTQJNiCC
WOcQW0lEXYzZ19tpF/vk1MX1rIsjWmDrzpZpz0WgjHfD7/ejJojIqU7Yl0BxMwfB
fehUMqlj/n3hbFBsInhKHKI8zOa9Od+mw1igLrG01s5w4HYLZCtjjGJJLjARmuwn
kdqeVUl86tNTY/OjJodyz0tRjLGZknC888Z1wm4i3QuDEiI63g3zk+ednkJGobUH
svW/wkrE27w=
=EjrY
-----END PGP SIGNATURE-----
--=-=-=--
