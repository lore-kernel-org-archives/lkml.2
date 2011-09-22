Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab1IVEgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 00:36:03 -0400
Received: from home.keithp.com ([63.227.221.253]:59081 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab1IVEf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 00:35:59 -0400
From: Keith Packard <keithp@keithp.com>
To: Woody Suwalski <terraluna977@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: i915 blank issue on kernel 3.1.0
In-Reply-To: <4E7A6CED.5000501@gmail.com>
References: <4E7A6CED.5000501@gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 21 Sep 2011 21:35:54 -0700
Message-ID: <yun4o05xkgl.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Sep 2011 19:02:05 -0400, Woody Suwalski <terraluna977@gmail.com>=
 wrote:

> Chris, I do not know if it is i915 driver or X'drm or what..
> Problem exists on 3.1.0, no problem on 3.0.3

Any way you could narrow it down a bit more? A bisect should sort it out
pretty quickly, given that you've got working code in 3.0 and
not-working code in 3.1-rc. You can start by manually bisecting across the
3.1 release candidates, and then narrow it down from there by bisecting
only across the drivers/gpu/drm/i915 directory.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOersqQp8BWwlsTdMRAqu7AJ9vGz/TVkm67aG7DKulUo1BiATE5gCeKFL1
p9XqLyOAA4LUx4+3o2kbL+0=
=LUuL
-----END PGP SIGNATURE-----
--=-=-=--
