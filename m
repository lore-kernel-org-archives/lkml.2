Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab1ERBXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 21:23:04 -0400
Received: from home.keithp.com ([63.227.221.253]:51039 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932571Ab1ERBXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 21:23:02 -0400
From: Keith Packard <keithp@keithp.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, Mihai Moldovan <ionic@ionic.de>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915/sdvo: Reorder i2c initialisation before ddc proxy
In-Reply-To: <1305637430-16026-1-git-send-email-chris@chris-wilson.co.uk>
References: <4DD2648C.6020309@ionic.de> <1305637430-16026-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 17 May 2011 18:22:52 -0700
Message-ID: <yunei3wssyb.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 17 May 2011 14:03:50 +0100, Chris Wilson <chris@chris-wilson.co.uk>=
 wrote:
> The ddc proxy depends upon the underlying i2c bus being selected. Under
> certain configurations, the i2c-adapter functionality is queried during
> initialisation and so may trigger an OOPS during boot. Hence, we need to
> reorder the initialisation of the ddc proxy until after we hook up the i2c
> adapter for the SDVO device.

I'd love more explanation here about how this code ever worked -- what
are these 'certain configurations' of which you speak?

(on the surface, this patch seems sane, but I'd love to review with
specific knowledge about what configurations would have worked and which
would have triggered this bug).

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN0x9sQp8BWwlsTdMRAgdmAKCMfWFYNKoU9qC1IZHx1ZdatANnfQCgtv0J
+G313+YEM0vLaRCBZ2t/iZk=
=1NaO
-----END PGP SIGNATURE-----
--=-=-=--
