Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab1KCWs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:48:56 -0400
Received: from home.keithp.com ([63.227.221.253]:54179 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab1KCWsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:48:55 -0400
From: Keith Packard <keithp@keithp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 7/7] drm/i915: Remove trailing white space
In-Reply-To: <20111103130349.594aa200@jbarnes-desktop>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-8-git-send-email-keithp@keithp.com> <20111103130349.594aa200@jbarnes-desktop>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 03 Nov 2011 15:48:44 -0700
Message-ID: <yun8vnwrfeb.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Nov 2011 13:03:49 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:

> Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

I've updated the pch-edp-fixes branch with your suggestions and attached
your R-b: to the reviewed patches.

That leaves only the panel power sequencing changes, which could
probably use more testing to make sure no existing systems stop
working. I've got an ILK eDP system here that I haven't tested yet, so I
can do that. I have tested SNB CPU eDP on the MacBook and CPT PCH eDP on
the other system.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrMaTDYtFsjWk68qAQgm+BAAnxb5k/hK606EJAgIACU29XeYtXGzUMhT
X9PWRD0pqQKO7leYz2FFolGz1W5sngfrr932zU3NA9X6k5gnJvjbfbCy3mClso1f
eTcGjv0ivYDVNQ1AOvEuKIX+2UQoLTTVzBtZBBlxodJyFV53KzbviQMmWXeHrnlC
eoQqlVSyMm4svon9dvhbDfmiet3h8+dpUIHzlK4lqlhBUevy9tGr7DhWSQ8l5JtX
LNyE9wdbwbdmZPJhMbUhWiaz8a7OFtnhrEUjJ/khoh1lOGXb7HzNU5vj3+RJicbH
PmEaUUhqYEJc3r+iT9FqZoT+WsvCYpOotaaMJRmwVrwEXkeC+uhzh6UAlxjWqCMZ
E4kaGsAgXx/HpYlrpne1VjLhnfU3ZZyH44pCYThi7jSn3KnsYdBnOOpf/AAkCBZ1
AjLXZh5wVn2OK87BrbKn0qSieqA7NGkkpf07CV2RwpZBiRPFemMK75o7N+McoiZq
ezn9OCpNZvyNmX5mhyc9te08vW5ZFni+c3H/skUkSIg/YkJcFOZYJRLWzorNEl1R
RXKB8TRlua4FBO+Ga5ju6CM9i/mY/CfuR1s8ovB04Pv0Iso9ggCmrKCrGjMAsZkK
wxHIUgCs0L5+CajHjGrgKFnYiqxgb9dAgpgyQLytHEB+ZqdKpcUFhhNOgPFLrCzL
G1ZNtTUMg6s=
=Nyyc
-----END PGP SIGNATURE-----
--=-=-=--
