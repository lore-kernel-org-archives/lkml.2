Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1IYW6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 18:58:24 -0400
Received: from home.keithp.com ([63.227.221.253]:56510 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1IYW6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 18:58:23 -0400
From: Keith Packard <keithp@keithp.com>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: drm/i915: problems after closing/opening lid
In-Reply-To: <gibou8tkk4.fsf@mx10.gouders.net>
References: <gibou8tkk4.fsf@mx10.gouders.net>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sun, 25 Sep 2011 15:58:06 -0700
Message-ID: <yunk48wkz5t.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Sep 2011 22:48:43 +0200, Dirk Gouders <gouders@et.bocholt.fh-gel=
senkirchen.de> wrote:

> I bisected this to commit 9aa73a51c91cb0d0af4caaa9823969c1a1179a12.
> I played with the params that were inverted in that commit and if I
> change both or one of them via command line, there is no problem, the
> problem only occurs if both of them have the new values.

You should be good if you run the drm-intel-fixes branch of my repo at

        git://people.freedesktop.org/~keithp/linux

That disables FBC on your Ironlake GPU.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOf7H+Qp8BWwlsTdMRAk1UAKCpsxPJUHvUqBSrEavOX6LJeA6GYACfSWwo
e+zjEGFEUWgFNys/sW0o/9c=
=oCAB
-----END PGP SIGNATURE-----
--=-=-=--
