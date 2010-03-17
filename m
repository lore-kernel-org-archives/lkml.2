Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab0CQUay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 16:30:54 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:59397 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab0CQUax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 16:30:53 -0400
From: Eric Anholt <eric@anholt.net>
To: Daniel Vetter <daniel@ffwll.ch>, Dan Carpenter <error27@gmail.com>,
       David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
       maximlevitsky@gmail.com, Chris Wilson <chris@chris-wilson.co.uk>,
       Luca Barbieri <luca@luca-barbieri.com>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] i915: fix small leak on error path
In-Reply-To: <20100306115054.GA3462@viiv.ffwll.ch>
References: <20100306110539.GD4958@bicker>
	<20100306115054.GA3462@viiv.ffwll.ch>
Date: Wed, 17 Mar 2010 13:30:50 -0700
Message-ID: <87k4tak7wl.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 6 Mar 2010 12:50:54 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:
> Oh, dang. Thanks for catching this. Eric, please merge.
>=20
> Cc: stable@kernel.org (for .33)
> Reviewed-by: Daniel Vetter <daniel@ffwll.ch>
>=20
> On Sat, Mar 06, 2010 at 02:05:39PM +0300, Dan Carpenter wrote:
> > We should free "params" before returning.
> >=20
> > Signed-off-by: Dan Carpenter <error27@gmail.com>

Applied.  Thanks!

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuhO/oACgkQHUdvYGzw6vfNQQCfd9iu1hzTfEypRak0IiZ1IQce
eY8AmwcR1UWFehBnP3jmvCjpe8+TKZyA
=XICB
-----END PGP SIGNATURE-----
--=-=-=--
