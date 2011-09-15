Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968Ab1IOO7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:59:49 -0400
Received: from home.keithp.com ([63.227.221.253]:57331 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab1IOO7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:59:47 -0400
From: Keith Packard <keithp@keithp.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-dev@lists.linaro.org
Cc: "Clark\, Rob" <rob@ti.com>, Archit Taneja <archit@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
In-Reply-To: <1316088425.11294.78.camel@lappyti>
References: <1316088425.11294.78.camel@lappyti>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 15 Sep 2011 09:59:32 -0500
Message-ID: <yunboul7sx7.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Sep 2011 15:07:05 +0300, Tomi Valkeinen <tomi.valkeinen@ti.com> =
wrote:

> This was a very rough and quite short proposal, but I'm happy to improve
> and extend it if it's not totally shot down.

Jesse Barnes has put together a proposal much like this to work within
the existing DRM environment. This is pretty much the last piece of
missing mode-setting functionality that we know of, making DRM capable
of fully supporting existing (and planned) devices.

Here's a link to some older discussion on the issue, things have changed
a bit since then and we had a long talk about this during the X
Developers' Conference this week in Chicago. Expect an update to his
proposal in the coming weeks.

http://lists.freedesktop.org/archives/dri-devel/2011-April/010559.html

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOchLUQp8BWwlsTdMRAm8uAJ9sgDb5o2PVt4z7BF94byaVY4P8jACgpvFP
8CNUnoiylJ9Phg6SI0fLegU=
=aRky
-----END PGP SIGNATURE-----
--=-=-=--
