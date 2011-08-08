Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1HHSnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:43:01 -0400
Received: from home.keithp.com ([63.227.221.253]:36270 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab1HHSnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:43:00 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 2/4] drm/i915: Leave LVDS registers unlocked
In-Reply-To: <20110808093010.487c4559@jbarnes-desktop>
References: <1312653248-3487-1-git-send-email-keithp@keithp.com> <1312653248-3487-3-git-send-email-keithp@keithp.com> <20110808093010.487c4559@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 08 Aug 2011 11:42:56 -0700
Message-ID: <yunr54vu4lr.fsf@aiko.keithp.com>
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

So, I'd like to know if we could unlock the panel registers on pre-PCH
hardware as well at init time; that way I could remove the unlock code
From=20intel_lvds_prepare too. Should it be possible to set the
PANEL_UNLOCK_REGS bits for pre-PCH hardware without having the target off?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOQC4wQp8BWwlsTdMRAuWZAKC0UDhVxYacTD4d0OD+t6chjYtuGwCfRadF
PUoO+2+s4MSXnJ6Z4ImbcFQ=
=5DH9
-----END PGP SIGNATURE-----
--=-=-=--
