Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2APUos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:44:48 -0500
Received: from home.keithp.com ([63.227.221.253]:44003 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401Ab2APUor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:44:47 -0500
From: Keith Packard <keithp@keithp.com>
To: Daniel Vetter <daniel@ffwll.ch>, Wu Fengguang <fengguang.wu@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        "intel-gfx\@lists.freedesktop..." <intel-gfx@lists.freedesktop.org>,
        Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Lemaire <rlemaire@suse.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: set AUD_CONFIG N_value_index for DisplayPort
In-Reply-To: <20120116202618.GG3627@phenom.ffwll.local>
References: <20120109131717.GA4713@localhost> <86y5tgx02g.fsf@sumi.keithp.com> <20120110054519.GA27257@localhost> <86ty404yhd.fsf@sumi.keithp.com> <20120116080252.GA18538@localhost> <20120116202618.GG3627@phenom.ffwll.local>
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 16 Jan 2012 12:44:43 -0800
Message-ID: <86obu31io4.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jan 2012 21:26:18 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:

> Keith, does this address your concern and this patch is r-b: Keith or do
> we want an
>=20
> } else {
> 	I915_WRITE(aud_config, 0);
> }
>=20
> for paranoia?

I think we want this added, just to be sure we set the configuration
correctly in all cases; it's easy to imagine moving from DP to HDMI and
leaving this bit set.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTxSMOzYtFsjWk68qAQj03A/9GBY0spPMAgmJdZ3q+GH1CI4+8c59FXPA
kEcAdF1yfWLoKPwg9ymKHY2u3kPAuhV9cYzn46h2lJwLTw8cKDy47ofqV4SgqokQ
TQDKnyMcgz1atBkoufKmRhYPo5c47GZ2desuSHJwlBHzj/c7zsbaCZ8Is8Ggu5c1
hXydqOmIo2vP6dFu5OZoPSGjPYlcaCS1xSzpWQ5rHWoXhM2+hNynP2p763RQtDvw
1XN84erp2k36BUij843xEodlGNZ9S6bVw5tgGXHv4KblR8v4IHGDdw8RhvKJckzs
kTlR91FZaZyX6PgayC4LZJEmxOPjVBu6bvC5BXlthB7DpzrHPVdQxR01xjbLw19y
21/reIDT0YCDkj5l4qUJbRcSl3ajVhdNv3fZWktq+EeFmatmxvkqNuwBJ306nffq
0KgUkhUGOWJE0CZehpcVz1odI5uxYTio4he/tGOYBKdF1pwPkV2aJXmvA0YL0/U+
UDEiju2O5BUE/uZ/Vrd23sSv3CYwVgQfbkaS5IdwEirTQHVLkr/30VrZR+idZjIN
GiSTxkVwFr8D7OOHVS8yPbPQh2CcezayckJBMRgwKum1j2/KqK4R5G25sU5s03nS
37H2OESXn1sjXWqIUv+XcrLPCKWw4/OyTfIJenKj3MPO1/xL2R+u21nnNVJ1qI6h
6ExBbOHfNPM=
=Bhp7
-----END PGP SIGNATURE-----
--=-=-=--
