Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1FRHV1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 03:21:27 -0400
Received: from home.keithp.com ([63.227.221.253]:50150 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab1FRHV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 03:21:26 -0400
From: Keith Packard <keithp@keithp.com>
To: Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>,
        Daniel J Blueman <daniel.blueman@gmail.com>, stable@kernel.org,
        Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH] drm/i915: Fix gen6 (SNB) missed BLT ring interrupts.
In-Reply-To: <1308335539-13952-1-git-send-email-eric@anholt.net>
References: <1308335539-13952-1-git-send-email-eric@anholt.net>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 18 Jun 2011 09:21:04 +0200
Message-ID: <yunoc1v8v1b.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Jun 2011 11:32:19 -0700, Eric Anholt <eric@anholt.net> wrote:

> v1->v2: Moved to prior interrupt handler installation and RMW flags as
> per feedback.
> v2->v3: Removed RMW of flags (by anholt)

Acked-by: Keith Packard <keithp@keithp.com>

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN/FHgQp8BWwlsTdMRAursAKDONQeHbW63N9hIQ+Br3TEUmd3tOwCfSx+H
+zjxg+ILE+X4ChQsssI5XrI=
=m3Yg
-----END PGP SIGNATURE-----
--=-=-=--
