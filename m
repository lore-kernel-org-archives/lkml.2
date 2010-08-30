Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab0H3WDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 18:03:12 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:51576 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0H3WDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 18:03:11 -0400
From: Eric Anholt <eric@anholt.net>
To: Meelis Roos <mroos@linux.ee>, Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] fix i915 compile in 2.6.36-rc2
In-Reply-To: <alpine.SOC.1.00.1008231332460.14284@math.ut.ee>
References: <alpine.SOC.1.00.1008231332460.14284@math.ut.ee>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Mon, 30 Aug 2010 15:03:10 -0700
Message-ID: <87iq2ru5b5.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Aug 2010 13:38:27 +0300 (EEST), Meelis Roos <mroos@linux.ee> wro=
te:
> Commit 6ef3d4278034982c13df87c4a51e0445f762d316 introduces seq_file=20
> usage in intel_overlay.c but does not include the header and now=20
> compilation fails on i386. Fix it by including the necessary header.
>=20
> Signed-off-by: Meelis Roos <mroos@linux.ee>

Applied.  Thanks!

(sorry for the delay on this, guys.  I swear someone had sent one of
these to Linus directly, and every time that happens and I apply it
anyway, he's already pulled it.  So I've been off in userland work
instead).

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkx8Kp4ACgkQHUdvYGzw6vdNoACgkXjHfiQ7iUUajmhRGDkgAk7l
zZAAoI9HdpO9x4yPbpLbkn7kvpXhbYRJ
=ECGM
-----END PGP SIGNATURE-----
--=-=-=--
