Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1JATCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:02:00 -0400
Received: from home.keithp.com ([63.227.221.253]:44965 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab1JATBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:01:53 -0400
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 14/21] drm/i915: Correct eDP panel power sequencing delay computations
In-Reply-To: <20111001095908.GB2807@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220> <1317344993-24945-1-git-send-email-keithp@keithp.com> <1317344993-24945-15-git-send-email-keithp@keithp.com> <20110930181644.GR2859@phenom.ffwll.local> <yunoby15qwu.fsf@aiko.keithp.com> <20111001095908.GB2807@phenom.ffwll.local>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 01 Oct 2011 12:01:49 -0700
Message-ID: <yund3eg5yea.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 1 Oct 2011 11:59:09 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:

> So while you bang your head against this, can you add the backlight power
> sequencing delays for lvds panels, too? The lvds panel power sequencing
> should be imo safe - we just msleep-spin with wait_for until the power
> sequencer has completed the request.

That should be a separate patch set, probably by someone with a
reasonable range of hardware to actually test it. Somehow I've managed
to get rid of all of my non-PCH hardware...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOh2OdQp8BWwlsTdMRAnxZAJwNyq7dsT0f3UsjODLn4oW7JbekNACdFO4U
VGdCYBptaleeoWn+9mq+48E=
=77YT
-----END PGP SIGNATURE-----
--=-=-=--
