Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab1I3SdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:33:17 -0400
Received: from home.keithp.com ([63.227.221.253]:47256 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab1I3SdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:33:15 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 14/21] drm/i915: Correct eDP panel power sequencing delay computations
In-Reply-To: <20110930181644.GR2859@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-15-git-send-email-keithp@keithp.com> <20110930181644.GR2859@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 30 Sep 2011 11:33:12 -0700
Message-ID: <yunbou17udz.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Sep 2011 20:16:44 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> Awesome patch description and the code agrees with what I've cross-checked
> on bspec. The only fear I have is that we currently ignore the backlight
> on/off timings and some panel probably relies on use waiting for backlight
> on/off + panel on/off in total. But that's material for another patch.

Thanks for all of your review. I'm off to lunch and some meetings, but
I should get the changes suggested merged into an updated patch sequence
this afternoon.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOhgtoQp8BWwlsTdMRAmllAJ9LiuiV366HcB+GFe9vBptYTq1p4ACeKqgl
AgiYp0pQB7V35qKGxkE7znE=
=+KsS
-----END PGP SIGNATURE-----
--=-=-=--
