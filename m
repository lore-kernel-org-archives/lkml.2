Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1GHGNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 02:13:40 -0400
Received: from home.keithp.com ([63.227.221.253]:38233 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab1GHGNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 02:13:39 -0400
From: Keith Packard <keithp@keithp.com>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@redhat.com>
Subject: Re: [026/107] drm/i915: Fix gen6 (SNB) missed BLT ring interrupts.
In-Reply-To: <20110708001655.280182108@clark.kroah.org>
References: <20110708001655.280182108@clark.kroah.org>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 07 Jul 2011 23:13:33 -0700
Message-ID: <yun4o2xti42.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 07 Jul 2011 17:15:58 -0700, Greg KH <gregkh@suse.de> wrote:

> 2.6.39-stable review patch.  If anyone has any objections, please let
> us know.

Note that there's a follow-on patch to this which fixes similar hangs
with the BSD ring:

ec6a890dfed7dd245beba5e5bcdfcffbd934c284

    drm/i915: Apply HWSTAM workaround for BSD ring on SandyBridge
=20=20=20=20
    ...we need to apply exactly the same workaround for missing interrupts
    from BSD as for the BLT ring, apparently.
=20=20=20=20
    See also commit 498e720b96379d8ee9c294950a01534a73defcf3
    (drm/i915: Fix gen6 (SNB) missed BLT ring interrupts).
=20=20=20=20
    Reported-and-tested-by: nkalkhof@web.de
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=3D38529
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    Signed-off-by: Keith Packard <keithp@keithp.com>

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOFqANQp8BWwlsTdMRAhuHAKCsIL3e29YMYvug+TruzhpebBB78QCguNAC
YtjJamF1g31piVwYbanYDBs=
=pvXr
-----END PGP SIGNATURE-----
--=-=-=--
