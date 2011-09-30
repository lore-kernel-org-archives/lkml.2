Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab1I3U5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:57:43 -0400
Received: from home.keithp.com ([63.227.221.253]:52423 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab1I3U5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:57:42 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 19/21] drm/i915: Asynchronous eDP panel power off
In-Reply-To: <20110930185524.GW2859@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-20-git-send-email-keithp@keithp.com> <20110930185524.GW2859@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 13:57:39 -0700
Message-ID: <yun1uux7np8.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 20:55:24 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> If it's not too annoying to do, can you move this to the previous patch?
> Dito for the s/panel_vdd_work/panel_work/.

Yeah, that was a bit of sloppy patch mangling.

> Same comment as in the previous patch: I think the
> intel_dp->want_panel_power check belongs into the work queue. We don't
> want to hide the fact that we properly handle that race ;-)

Oh, I see your point. Yeah, either the check needs to be moved, or the
function name changed. I'll move the check.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhi1DQp8BWwlsTdMRAvUfAJwO60fDceOfuKIgDlZ55sUAjpoTiwCfUO9Y
9jukjoi2pGugS0K6NEJ/b2I=
=F/op
-----END PGP SIGNATURE-----
--=-=-=--
