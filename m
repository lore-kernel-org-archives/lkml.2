Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab1DEBCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 21:02:12 -0400
Received: from home.keithp.com ([63.227.221.253]:34667 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab1DEBCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 21:02:11 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
In-Reply-To: <alpine.DEB.2.00.1104050137040.8684@skynet.skynet.ie>
References: <alpine.DEB.2.00.1104050137040.8684@skynet.skynet.ie>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Mon, 04 Apr 2011 18:02:07 -0700
Message-ID: <yun4o6dik8g.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Apr 2011 01:38:31 +0100 (IST), Dave Airlie <airlied@linux.ie> wro=
te:

>       drm/i915: Reset GMBUS controller after NAK

We've got a report of a regression from this patch and have a fix in
review right now. Please don't merge this to master until that fix has
been verified and added to this sequence.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFNmmoPQp8BWwlsTdMRAmk/AKC89qQmWDVVQG0hJVxZUHaQyZ3D9ACgns76
D6gkPUNhgNLOCi8tH0CBq7k=
=+Ugz
-----END PGP SIGNATURE-----
--=-=-=--
