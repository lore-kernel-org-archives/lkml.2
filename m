Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab1G0JVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:21:30 -0400
Received: from home.keithp.com ([63.227.221.253]:34787 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab1G0JV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:21:28 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hold struct_mutex during hotplug processing
In-Reply-To: <20110726121225.3ae7acce@jbarnes-desktop>
References: <1311613829-4990-1-git-send-email-keithp@keithp.com> <CAKMK7uHO1jqUNrnqC9sd=JJ9Vr=hmAjnJ06eDYxfeyTTFAMK1w@mail.gmail.com> <yunsjpt2hi6.fsf@aiko.keithp.com> <20110726121225.3ae7acce@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 27 Jul 2011 02:21:24 -0700
Message-ID: <yunk4b43wq3.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Jul 2011 12:12:25 -0700, Jesse Barnes <jbarnes@virtuousgeek.org>=
 wrote:

> I'd like to amend my reviewed by and say the lock shouldn't be held
> around the call to the drm helper function.  It queues some work that
> also takes the mode config lock, which will break.  So you can drop it
> before that...  Previously I had only checked our internal driver
> callbacks but missed that the lock was held across the helper too.

So the work may get executed immediately rather than being run later at
some point?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOL9iUQp8BWwlsTdMRAqyHAJ0QLh3DySZk2fy6o+ydMe4eqI36kgCdF/6l
7VDX4ZpidHAFFgLErfv/gVE=
=mu5I
-----END PGP SIGNATURE-----
--=-=-=--
