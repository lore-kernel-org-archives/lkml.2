Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836Ab1IOOXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:23:09 -0400
Received: from home.keithp.com ([63.227.221.253]:34458 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685Ab1IOOXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:23:07 -0400
From: Keith Packard <keithp@keithp.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] i915 KMS dual head broken on DELL latitude E6420 in 3.1-rc*
In-Reply-To: <20110915081259.GB4877@type.bordeaux.inria.fr>
References: <20110914232717.GA5410@type.famille.thibault.fr> <yunobym743b.fsf@aiko.keithp.com> <20110915074106.GA4544@type.famille.thibault.fr> <20110915081259.GB4877@type.bordeaux.inria.fr>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 15 Sep 2011 09:22:48 -0500
Message-ID: <yunlitp7umf.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Sep 2011 10:12:59 +0200, Samuel Thibault <samuel.thibault@ens-ly=
on.org> wrote:

> At home only. At work, with a different VGA screen, I'm still getting
> the issue.

You're still having a problem with the LVDS screen at work with FBC
disabled? Can you send along a kernel log with drm.debug=3D5?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOcgo4Qp8BWwlsTdMRAr1BAKCvrCeKi2W2SjhP4E1GAwmHOj7J3gCfQ/EF
SDxsVR2pDze60dt4bQ3YsOg=
=8rog
-----END PGP SIGNATURE-----
--=-=-=--
