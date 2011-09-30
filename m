Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab1I3SCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:02:35 -0400
Received: from home.keithp.com ([63.227.221.253]:41810 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626Ab1I3SCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:02:34 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 07/21] drm/i915: Check for eDP inside intel_edp_panel_vdd_on/off
In-Reply-To: <20110930171355.GG2859@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-8-git-send-email-keithp@keithp.com> <20110930171355.GG2859@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 11:02:30 -0700
Message-ID: <yunvcs97vt5.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 19:13:55 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> Why not also move the id_edp check into edp_panel_on|off like for the vdd
> functions? This way it looks a bit inconsistent ...

Yeah, I can do that. May mean a few redundant checks, but they're cheap.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhgQ3Qp8BWwlsTdMRAhK7AKCrZ2qRmBiGwPe7dwD+f9sUvgtVGgCgwCab
hm4Yv12zNdGnVFwjAH1VBiI=
=AzkG
-----END PGP SIGNATURE-----
--=-=-=--
