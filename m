Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab1I3S2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:28:14 -0400
Received: from home.keithp.com ([63.227.221.253]:47333 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab1I3S2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:28:13 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        "Barnes\, Jesse" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 03/21] drm/i915: Remove extra 300ms delay during eDP mode setting
In-Reply-To: <20110930180959.GP2859@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-4-git-send-email-keithp@keithp.com> <20110930162728.GC2859@phenom.ffwll.local> <yun7h4p9ay5.fsf@aiko.keithp.com> <20110930175821.GN2859@phenom.ffwll.local> <20110930180959.GP2859@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 11:28:09 -0700
Message-ID: <yunk48p7ume.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 20:09:59 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> On further strolling through bspec to review later patches I've noticed
> that PCH_PP_ON_DELAYS and PCH_PP_OFF_DELAYS seem to have values for
> power on->backlight on and backlight off->panel off delays. Maybe we
> should use these?

Yeah, I must have missed those. For backlight on, I think I'll make it
asynchronous with a delayed work proc so that the rest of the boot/dpms
process doesn't block behind turning the light on.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhgo5Qp8BWwlsTdMRAtsrAKDZ63YyzZwvWFTZsAJ2h60TbrwsdACgwzSW
KKUc5lSg4NwGWv5kFB02D5k=
=zwU/
-----END PGP SIGNATURE-----
--=-=-=--
