Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab1KBQNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:13:48 -0400
Received: from home.keithp.com ([63.227.221.253]:37035 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932955Ab1KBQNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:13:42 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 1/7] drm/i915: Move common PCH_PP_CONTROL setup to ironlake_get_pp_control
In-Reply-To: <20111102090255.09fa9a61@jbarnes-desktop>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-2-git-send-email-keithp@keithp.com> <20111102090255.09fa9a61@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 02 Nov 2011 09:13:38 -0700
Message-ID: <yunty6mwlhp.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Nov 2011 09:02:55 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> Can't we just set UNLOCK_REGS at load time and have asserts sprinkled
> here and there?

I think we'd need it at resume time as well; it seemed easier to just
set it every time we touch the register.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrFsMzYtFsjWk68qAQgdwBAA0mDi0q/aLvpEA16dpy5d5kux5GR/0iLv
OKsUYn++Xps9KGP/DrqbChwumVAP3RzgcVzReQL8znu+sIlYSjPFF3nt3l+4Yj+Q
vq1RkhX2BPuYix0Jv/Cx68i8vWzpiEu3AmlW/L25UnMOZ0l+eNHIMkgjzJG3IQsx
wJohxir1uchSq8bdzZIevkOAgfDz9O9alhkTUGKkqYKvDrCKL6W/ajIXsqFJlJCk
um0xZXuEOp5N0QPUklw2bgAEcvjKoEDTVpkqM1ATa/5Uh80o1ogwlYaTQ3aEYk+I
sbNLH+62NUHIVKRdBLCNQWZBni/u2utdsiK2JDCGWQarPOPpENKQ6PH1SDmrA1f4
lc8WPmQXlYFvUTNk6M3nS8NA5irnbxsnRbxGSL14JUW/FIU1fb4DTihKoljsx0Ck
k7Jg6ChSDHefWljYy5m2vUXlS56Axd6Qim9JQdnpU/W9sAPqKqe5228Q/lA1zsV4
MrnUJeMgXPITtZYNd926g06eobYxFjFtBDoz7uh/anVDu7ocF0hTf+WMdjolUBtL
htbWeYvUrTBZm2n2yJInDBMaEwjFEs4Tf/Pbk/bSFc/jSRqIBr3Ht4aLnnmmWY5T
2UxYsKlo9sTCdQP3HlaqmY5FvBwnhA0fD+24x++XfRGG2VC0q3Q2oaOUjnIhk2o2
b0DX8doE9rc=
=ZH/q
-----END PGP SIGNATURE-----
--=-=-=--
