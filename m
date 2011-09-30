Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab1I3Sag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:30:36 -0400
Received: from home.keithp.com ([63.227.221.253]:47369 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756018Ab1I3Saf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:30:35 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 12/21] drm/i915: Ensure eDP powered up during DP_SET_POWER operation in dp_prepare
In-Reply-To: <20110930174502.GL2859@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-13-git-send-email-keithp@keithp.com> <20110930174502.GL2859@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 11:30:32 -0700
Message-ID: <yunhb3t7uif.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 19:45:02 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> If I understand things correctly we don't need the vdd_on/off on dpms off
> because the panel is running and has power.

Yes, that's correct; the aux channel works with either full power or
with the force VDD bit turned on.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhgrIQp8BWwlsTdMRAgpbAJ4oF2YM2xgdagVWUFmPkl1eFFi9lgCguGJh
1V0kQCg2OWiIRR8+wCom9F8=
=qaZ3
-----END PGP SIGNATURE-----
--=-=-=--
