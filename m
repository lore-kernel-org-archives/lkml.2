Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1KAG6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 02:58:30 -0400
Received: from home.keithp.com ([63.227.221.253]:40736 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab1KAG63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 02:58:29 -0400
From: Keith Packard <keithp@keithp.com>
To: Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Cc: Eric Anholt <eric@anholt.net>, stable@kernel.org
Subject: Re: [PATCH] drm/i915: Fix object refcount leak on mmappable size limit error path.
In-Reply-To: <1320128181-3161-1-git-send-email-eric@anholt.net>
References: <1320128181-3161-1-git-send-email-eric@anholt.net>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 31 Oct 2011 23:58:25 -0700
Message-ID: <yunsjm8pbvy.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Oct 2011 23:16:21 -0700, Eric Anholt <eric@anholt.net> wrote:

> I've been seeing memory leaks on my system in the form of large
> (300-400MB) GEM objects created by now-dead processes laying around
> clogging up memory.  I usually notice when it gets to about 1.2GB of
> them.  Hopefully this clears up the issue, but I just found this bug
> by inspection.
>=20
> Signed-off-by: Eric Anholt <eric@anholt.net>
> Cc: stable@kernel.org

Reviewed-by: Keith Packard <keithp@keithp.com

I wouldn't mind having someone audit the driver for more places where
drm_gem_object_lookup might not be paired with drm_gem_object_unreference...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTq+YkTYtFsjWk68qAQgyZRAA2frTtZcXkooIgaLiao5OjG42flmu1l9Q
vyBu4fPkFT2Kxl5KOegZfVneU2cusYIRnXJidAKzBWuTtrBTBWoje/L92/1kFXZ5
L4TnZwR1SgrOJxO057zuWYwLFSQHgTCu+QXdfNgGGxg4T2fHk+Am0Gm7XZptOlE+
LvSximS6VLlr4fQjq8RXWRfbMQeu7m86x8/5VPBuFTRr8jrjqmuAMkEZTf70GsxR
xJmYXRaGNbv4D7WKQE8Ww2VbwN8vz3Jiww+av1zVqEcJ0jgbB1w3cqEAYoAO+FtG
Ukxo3tKqCqe0IsPw1nNRnpMpptk2vYFZZyUczjwJCe8GVneD39t1FQgYiPtQ5Acy
CzSoiQqTkfIdihMCsyuVTdt+SI/YTPsTbQ9jqPVKyfB4ii6gibif9/yF2dGwFuZM
VHcKhGahJTlWg7Hi9OtE4XaSqqHdb977LLT6bYR7DGfZLdoLAb8vIQDreoBji7Z9
ONEYzDTYKvpFPV/bqZHWWnD8KCwRcoBg4FbEgdEf16c2ZmLiYFXWCyzA+5E6Pw2L
uaHM36JQwRdHffE1uZI3sTR4wCWen5/dQXQRf6JetxRUmvYbkvWocZgG2lJW0oD7
TDImozBp6ID/Ugu8K7Wuc45pfGYfsSuepJu/u4DZndTcJDdxaHPo1+huZ4sLkmsP
tGS214MFQ8k=
=h79L
-----END PGP SIGNATURE-----
--=-=-=--
