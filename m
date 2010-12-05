Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab0LEVIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 16:08:23 -0500
Received: from home.keithp.com ([63.227.221.253]:43121 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab0LEVIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 16:08:22 -0500
From: Keith Packard <keithp@keithp.com>
To: Florian Mickler <florian@mickler.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 2/2] drm: record monitor status in output_poll_execute
In-Reply-To: <20101205132743.3b3458ab@schatten.dmk.lab>
References: <1290797159-3977-1-git-send-email-keithp@keithp.com> <1290797159-3977-2-git-send-email-keithp@keithp.com> <20101205132743.3b3458ab@schatten.dmk.lab>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Sun, 05 Dec 2010 13:08:18 -0800
Message-ID: <yunpqtgexml.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 5 Dec 2010 13:27:43 +0100, Florian Mickler <florian@mickler.org> wr=
ote:
> On Fri, 26 Nov 2010 10:45:59 -0800
> Keith Packard <keithp@keithp.com> wrote:
>=20
> > In order to correctly report monitor connected status changes, the
> > previous monitor status must be recorded in the connector->status
> > value instead of being discarded.
> >=20
> > Signed-off-by: Keith Packard <keithp@keithp.com>
>=20
> Keith, am I right to assume that these address=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D22672
> and probably:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D23472

Yes, this is part of the patch for that. The other piece is in the 2D
driver which has a matching bug. That patch is already on master.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM+/9CQp8BWwlsTdMRApdvAKDj0FZ6fQxBPt4TLDq9IRdUeZiObQCgxKxX
i1cZ5FtuV5f4V5gQEbiIcsw=
=Lh8E
-----END PGP SIGNATURE-----
--=-=-=--
