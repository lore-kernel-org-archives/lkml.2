Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab1FFXYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:24:52 -0400
Received: from home.keithp.com ([63.227.221.253]:59894 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab1FFXYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:24:51 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel@lists.freedesktop.org,
        "drivers\, Intel" <Intel-gfx@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: drivers/drm/i915 maintenance process
In-Reply-To: <20110606133618.478fc5d9@jbarnes-desktop>
References: <yunipskolss.fsf@aiko.keithp.com> <20110606133618.478fc5d9@jbarnes-desktop>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 06 Jun 2011 16:24:46 -0700
Message-ID: <yun39jm1r29.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Jun 2011 13:36:18 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> Can you keep drm-intel-next fairly up to date with respect to the fixes
> branch?  I.e. keep it a superset of drm-intel-fixes for the most part?

Yes, I wanted to do that now, but -fixes is not a fast-forward from
=2Dnext and I thought I shouldn't be doing rebases.

> In PCI-land, this means re-basing my -next tree periodically before the
> merge window opens (though not right before the merge window unless
> something unexpected happens, like a patch needing to be dropped; in
> that case I'll delay the merge window push a bit to allow for more
> testing).

If a rebase around -RC1 is reasonable, then I'll do that now and move
changes over to that.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN7WG+Qp8BWwlsTdMRAsSCAJ0XP1prBpeQmG7YYkV0zoq4uWkd5gCgoR1E
A6J+XqUUIroEF4IyI8KdPsE=
=jq7b
-----END PGP SIGNATURE-----
--=-=-=--
