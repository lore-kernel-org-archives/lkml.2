Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab1I3SBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:01:12 -0400
Received: from home.keithp.com ([63.227.221.253]:41779 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967Ab1I3SBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:01:10 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 05/21] drm/i915: Check eDP power when doing aux channel communications
In-Reply-To: <20110930170242.GE2859@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-6-git-send-email-keithp@keithp.com> <20110930170242.GE2859@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 11:01:06 -0700
Message-ID: <yun1uux9afx.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 19:02:42 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> Use pp_control instead of re-reading?

Could, but you'll note a later patch eliminates both pp_status and
pp_control local variables, so I didn't bother to clean this up when
refactoring.

> dp_aux_ch does the low-level io for the below, so either this one or the
> below three hunks look a bit redundant.

Yeah, probably not necessary. I just added checks everywhere I could
think of to try and figure out where power was not being applied when
needed.

Should I bother to include this patch in the series at all? It's purely
for diagnostics to make sure the panel is powered during all aux channel
transactions.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhgPiQp8BWwlsTdMRAnjdAJ0X2w10KVBOrd37FC3WZvMiWldP/QCgwuq7
FFD0FmKGs5jjqLBm36y8Z2Q=
=2szm
-----END PGP SIGNATURE-----
--=-=-=--
