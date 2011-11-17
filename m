Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab1KQPRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:17:47 -0500
Received: from home.keithp.com ([63.227.221.253]:44945 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab1KQPRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:17:45 -0500
From: Keith Packard <keithp@keithp.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Mack <zonque@gmail.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, harald@redhat.com,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Fix invalid backpanel values for GEN3 or older chips
In-Reply-To: <s5hlirgm1kg.wl%tiwai@suse.de>
References: <s5hlirgm1kg.wl%tiwai@suse.de>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 16 Nov 2011 22:15:41 -0800
Message-ID: <yunsjlnl1f6.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Nov 2011 18:14:55 +0100, Takashi Iwai <tiwai@suse.de> wrote:

> While refactoring of backlight control code in commit [a95735569:
> drm/i915: Refactor panel backlight controls], the handling of the bit
> 0 of duty-cycle was gone except for pineview.  This resulted in invalid
> register values for old chips like 915GM.  When the bit 0 is set, the
> backlight is turned off suddenly.

I'm looking at the mentioned patch and I don't see how that managed to
correctly handle bit 0; is this the patch that managed to break this?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsSmjjYtFsjWk68qAQjSvRAAqkEtCdoEeR1cjy3bWsOhBe13cKxvHw/r
EfAceq3cwptp3LkpujhKXYTT3UCGqI24T4+saXO31UpcziuB6qf98nX8waNEiP/h
0bcg45OsjsDSh52VtHQGTSk66GhPq0EKgi9W9PuEp1i5FX7+1qVU2rCkuZmOgZ0P
nHTrMatet84wFx5A/WOQ1RwDxb4L1hDOaaXDuWNI8jjeJoSmvyc8RnfsYNwcvY7l
4E1E/2aSB52qPS6b/LsqAS20D3D0ww3nLb2U6HMTc93Y7ZLW0epyHtYE/rpfT/3s
8y2H9fPM9jtQAXZzKMAG/JDx/mVW8Cezp/cVnyLnVSFqDTNtc0ZbVu0/gtMxjS2L
P0lkM0Kb8uHeuTTBaOha6GYOc2yRSclb8pz2bohqxoAUAs4DxjvarfIt2PZEZ6gs
Xy5y+a8bHZg/V8woBfr+EBmRjqohP21MsanbwepxncjQ4cUkvmacOFwAtSnUW8S0
e/ymwge1ZF7Bin9mKTLDeQtm701ig8UBxW/OLFBDmnvlPB2nO0vJtGP1Xse+j3sg
jZ1ulvILdvekKEI+eynWM+Lpi5YVis6qKDOj9oCsAuZY2lrZQw4J+RBA1LenwKKA
/3zM8pw7dgRVuoL6lqEGZVSpGHWPuKkNGmfDscLi+iLFdfmX2oaPmsKg4EmJQACy
HnSNIzwj/qc=
=3+i6
-----END PGP SIGNATURE-----
--=-=-=--
