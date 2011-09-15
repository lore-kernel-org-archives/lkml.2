Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1IOFnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 01:43:55 -0400
Received: from home.keithp.com ([63.227.221.253]:45768 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469Ab1IOFny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 01:43:54 -0400
From: Keith Packard <keithp@keithp.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] i915 KMS dual head broken on DELL latitude E6420 in 3.1-rc*
In-Reply-To: <20110914232717.GA5410@type.famille.thibault.fr>
References: <20110914232717.GA5410@type.famille.thibault.fr>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 15 Sep 2011 00:43:36 -0500
Message-ID: <yunobym743b.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Sep 2011 01:27:17 +0200, Samuel Thibault <samuel.thibault@ens-ly=
on.org> wrote:
Non-text part: multipart/mixed
> Hello,
>=20
> I'm trying to upgrade from 3.0 to 3.1-rcsomething on a DELL latitude
> E6420, but dual head is broken. Here is the scenario:
>=20
> - Turn computer on with VGA1 connected. Both LVDS1 and VGA1 show the
>   text console fine.
> - Start X. VGA1 shows X fine, but LVDS1 (1600x900 resolution) shows an
>   odd screen: completely black on the left part (about 1060x900), sort
>   of gray on the right part (about 540x900). Playing with xrandr doesn't
>   help, I can at best make it completely black with --off, and not get
>   it back again with --auto or anything else.

Can you try disabling frame buffer compression?

i915.i915_enable-fbc=3D0

I'm about to send a patch to disable this by default; I've gotten two
people saying that this helps them already.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOcZCIQp8BWwlsTdMRAuzwAKCdGZYbx8Wipsl/lgW1+3SWvxp4QACdHNUv
FXjT0sNv41C76Q6ZeEPloXU=
=i691
-----END PGP SIGNATURE-----
--=-=-=--
