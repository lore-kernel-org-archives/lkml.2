Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368Ab0EZUua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:50:30 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:54732 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934128Ab0EZUu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:50:27 -0400
From: Eric Anholt <eric@anholt.net>
To: Daniel J Blueman <daniel.blueman@gmail.com>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc: Dave Airlie <airlied@linux.ie>
Subject: Re: [2.6.34, patch] i915: fix lock imbalance on error path...
In-Reply-To: <AANLkTimb489PFFsC96b00jeuqv0OOEk8NbwpTHu9K3Cl@mail.gmail.com>
References: <AANLkTimb489PFFsC96b00jeuqv0OOEk8NbwpTHu9K3Cl@mail.gmail.com>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Wed, 26 May 2010 13:50:24 -0700
Message-ID: <87iq6a1j73.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 17 May 2010 14:23:52 +0100, Daniel J Blueman <daniel.blueman@gmail.=
com> wrote:
> While investigating Intel i5 Arrandale GPU lockups with -rc4, I
> noticed a lock imbalance.
>=20
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

Applied.  Thanks!

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv9iZEACgkQHUdvYGzw6vck/QCfbbsgRyHIZLN7V8WTjHsfNWEg
jVYAn2IQ3RZur5NneJPCn+IQmC3LTTsV
=dTVg
-----END PGP SIGNATURE-----
--=-=-=--
