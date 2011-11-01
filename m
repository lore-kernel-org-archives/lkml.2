Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1KARFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 13:05:23 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:57957 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1KARFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 13:05:22 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Nov 2011 13:05:22 EDT
From: Eric Anholt <eric@anholt.net>
To: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: Re: [PATCH] drm/i915: Fix object refcount leak on mmappable size limit error path.
In-Reply-To: <yunsjm8pbvy.fsf@aiko.keithp.com>
References: <1320128181-3161-1-git-send-email-eric@anholt.net> <yunsjm8pbvy.fsf@aiko.keithp.com>
User-Agent: Notmuch/0.5-277-ge59eaa5 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 01 Nov 2011 09:57:27 -0700
Message-ID: <87pqhb232g.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Oct 2011 23:58:25 -0700, Keith Packard <keithp@keithp.com> wrote:
Non-text part: multipart/signed
> On Mon, 31 Oct 2011 23:16:21 -0700, Eric Anholt <eric@anholt.net> wrote:
>=20
> > I've been seeing memory leaks on my system in the form of large
> > (300-400MB) GEM objects created by now-dead processes laying around
> > clogging up memory.  I usually notice when it gets to about 1.2GB of
> > them.  Hopefully this clears up the issue, but I just found this bug
> > by inspection.
> >=20
> > Signed-off-by: Eric Anholt <eric@anholt.net>
> > Cc: stable@kernel.org
>=20
> Reviewed-by: Keith Packard <keithp@keithp.com
>=20
> I wouldn't mind having someone audit the driver for more places where
> drm_gem_object_lookup might not be paired with drm_gem_object_unreference=
...

I went ahead and finished the read-through, and everything else looks
good.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6wJPcACgkQHUdvYGzw6vdtcACglXUFBx6P+8pBBB8YtqLNbo+F
Ea4AoIHaH1vkQrkfUf/cnd1cGxlHQM6z
=vs+r
-----END PGP SIGNATURE-----
--=-=-=--
