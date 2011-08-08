Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab1HHSZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:25:22 -0400
Received: from home.keithp.com ([63.227.221.253]:41301 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab1HHSZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:25:19 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 2/4] drm/i915: Leave LVDS registers unlocked
In-Reply-To: <20110808093010.487c4559@jbarnes-desktop>
References: <1312653248-3487-1-git-send-email-keithp@keithp.com> <1312653248-3487-3-git-send-email-keithp@keithp.com> <20110808093010.487c4559@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 08 Aug 2011 11:25:16 -0700
Message-ID: <yunwrenu5f7.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Aug 2011 09:30:10 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> Yep, looks fine.  The only think we might want to sprinkle about are
> checks for panel off so we can avoid visible corruption if we whack
> timing or fb stuff while the panel is on.

Yeah, could do. Would be nice to somehow get the LVDS code ripped out of
the middle of intel_display.c; everything in intel_lvds.c is nicely
bracketed by prepare/commit, which turn the panel off and back on.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOQCoMQp8BWwlsTdMRAntZAKDo9jpPVwKimY7dkn6U4XZYx6o8bACePgQ8
js3Q2TBzNnS0pVusKrpcKB8=
=uXsd
-----END PGP SIGNATURE-----
--=-=-=--
