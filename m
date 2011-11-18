Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1KRRq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:46:59 -0500
Received: from home.keithp.com ([63.227.221.253]:49735 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab1KRRq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:46:58 -0500
From: Keith Packard <keithp@keithp.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang\, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "dri-devel\@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] drm/i915: hot removal notification to HDMI audio driver
In-Reply-To: <20111118093740.GA2799@localhost>
References: <20111116132004.299754849@intel.com> <20111116132221.374839261@intel.com> <20111116133548.GA23804@localhost> <20111118093740.GA2799@localhost>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 18 Nov 2011 09:46:44 -0800
Message-ID: <86aa7tmigr.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Nov 2011 17:37:40 +0800, Wu Fengguang <fengguang.wu@intel.com> w=
rote:

> However when in X, ->mode_set won't be called at all.  Only
> ->get_modes and ->detect are called...

The desktop software will call mode_set when it configures the
monitor. Otherwise, it's not being used (and so shouldn't have audio
routed to it by default).

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsaaBDYtFsjWk68qAQh+yg/9HYDzKrR2p6fRysWcrHhYe91f+qX8wFDn
BfRlB1WUBwhJ7EZkWhzxSWo310wexvUlk+DuF40MLPPl1oIefUP4lBk+zXQ5b7X/
R/zp6ONb1I30L9M+arcXJJP/rdz/vrS7dh0EekjGAhbDDtGdMI0e8vIhz9RU01ST
j7scpDrxd0gxyHUoAdlVGkcxhlH8ABgoDLRXV8TlwbkobZjFJJZF0uaVDzkXPNaW
UGismdvOof6Q2YBWOrJhnvimS/c51aKKXpZHlHtN5yuvvyE6cuuNqGhM1kna5L5q
pFnxR8Fg2kkZhiRaWjQsz1A4Ha7mNsjcug+eClFF2McoOjJ4ME8VLXuj1CVixiFr
SPRHTP2GAk6jyBte/ma+lXYbQPH/o2lYbpH5/tgfwf8hV/InqcodoJlR9+lBaou4
Wjg4DOgQQ7bV+uXGSDoZrybCBpCmwqY1UTUpqdr7dI7932YnmULZc91+PmdMYoIA
XygInnxxyLpjOmVL4kWM7z9DaeNFET0m8A/quKl6932OA+x/eKmz/Lu1WmGpfdYR
mGJCVyOx5gum5wD86wapQA7MPH7NAblGk0uomZ4yRPro6yqYo7kH1hxY8hC7MoWG
eUBpSHWFstH8R8ow/+on1vmhVi4yAXNL7/7+dYQbeAFNo4QFejcfLqBNi9J6PgnJ
KQfYRq9Nm0g=
=wBi+
-----END PGP SIGNATURE-----
--=-=-=--
