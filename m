Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0KZSjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 13:39:22 -0500
Received: from home.keithp.com ([63.227.221.253]:33952 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab0KZSjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 13:39:21 -0500
From: Keith Packard <keithp@keithp.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, Michal Hocko <mhocko@suse.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, intel-gfx@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: i915: display doesn't get on back after returning from standby in 2.6.27-rc*
In-Reply-To: <20101126084538.GC12939@bicker>
References: <20101123123234.GA3791@tiehlicka.suse.cz> <20101125155828.GC9754@tiehlicka.suse.cz> <20101125161058.GA5831@elliptictech.com> <yunr5e9qjyf.fsf@aiko.keithp.com> <20101126084538.GC12939@bicker>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Fri, 26 Nov 2010 10:39:09 -0800
Message-ID: <yunipzkq69e.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Nov 2010 11:45:38 +0300, Dan Carpenter <error27@gmail.com> wrote:

> Where are the patches?  I pulled drm-next but I don't see them.

Looks like he hasn't merged them. I'm building drm-intel-next with this
and another patch.

I've pushed my bits to

git://people.freedesktop.org/~keithp/linux-2.6 drm-intel-next

and will re-post my patches shortly.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFM7/7OQp8BWwlsTdMRAlDWAKCSeGd+RXpHn6LXmM4rA1Djl38XxQCgyU1F
NUrUidWOY2aYUrvP5mknxis=
=Wmny
-----END PGP SIGNATURE-----
--=-=-=--
