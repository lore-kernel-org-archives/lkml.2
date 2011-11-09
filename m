Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1KIRz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:55:27 -0500
Received: from home.keithp.com ([63.227.221.253]:36110 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab1KIRz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:55:26 -0500
From: Keith Packard <keithp@keithp.com>
To: Michel Alexandre Salim <salimma@fedoraproject.org>,
        intel-gfx@lists.freedesktop.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] drm/i915: Prioritize SSC quirk table when determining SSC settings
In-Reply-To: <1320848955.5081.7.camel@fauix11.informatik.uni-erlangen.de>
References: <1320848955.5081.7.camel@fauix11.informatik.uni-erlangen.de>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 09 Nov 2011 09:55:22 -0800
Message-ID: <yuny5vpxjsl.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 09 Nov 2011 15:29:13 +0100, Michel Alexandre Salim <salimma@fedorap=
roject.org> wrote:

> the quirk table unreachable if i915_panel_use_ssc is set. This patch
> reorders the tests so that the quirk table is checked first, the
> i915_panel_use_ssc next and the original per-device setting last.

The requirement is that the command line options override any internal
configuration.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTrq+ijYtFsjWk68qAQispA/7BnrckXZg4sEQi4zZRQ0Zl3aqXQ5FZyrB
UYj1qxJJIhZyCwbqc1aud6+xo3oXcWl7JFh3eIP+Htl5BQnoPo66+/l7zmt1MR/R
4wW99aZVL8knnlhKisTK2oE3Y554lBMTB1SBdGvMmprv4RldVZRbH9p9H8ojDEQV
M6XUoEw9ki4S4VzmLz6HF9l+qzg7o9J6aVYpJosTMEQLlBRzos3ilIfzlN+4uv/m
D5Wajib44wcObU9VRA+kyt93udlIymARJz91JqUejg/htlLUsy+LUayOVP3aSXFc
xjV+huJRXGn6K+tW2PRIvhBUkr2Oe18F1l/+ZbHK8aNhfzMYklhQwF+htmEQi8uP
mFbgSMxu4NTE3/+n+frUpUdKTN+6zvzMdAt6+YxL+Wh51x/7IsLTVjtPO0wkm5IH
Pfk0g+ZsNC6CXgqmA+Yem9m3GDNU3GEyo3uYWte67b6BGz5gFHPeffMmLCt33S7W
TD53m6VIkhumRcYEPM+n4j6P/AXdehaQLt+KTtj1sldfmPsx6lWbTVck5SjNtXTr
Cjzq4Z+5YrHyW+5X28XMOylekqPtZd3drbhY9ds1pk9Zl6d0BONgeZaI1OWF5X0S
4+RLSoGrvts1fpIriG24s2LeTByx4LxDZRE1vU9Vqa1iL3Fqjdg+ZaxNNl3M5gsO
Ku9JTlHvLIE=
=D1ad
-----END PGP SIGNATURE-----
--=-=-=--
