Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1HERua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 13:50:30 -0400
Received: from home.keithp.com ([63.227.221.253]:43173 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab1HERu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 13:50:28 -0400
From: Keith Packard <keithp@keithp.com>
To: Pekka Enberg <penberg@kernel.org>, Dave Airlie <airlied@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Francesco Allertsen <fallertsen@gmail.com>
Subject: Re: [git pull drm fixes
In-Reply-To: <CAOJsxLF+QposjZjPcPMQMfQ9Z0Fj_uZMU2c9miF_HDqYdejhzQ@mail.gmail.com>
References: <alpine.DEB.2.00.1108051019200.14655@skynet.skynet.ie> <CAOJsxLHAQGNWN8-jnAFh=bOXqEZbXQsBucqETOSwoCXbuL9wBw@mail.gmail.com> <CAPM=9tykT0Y6ehRJ-=oOj-SGbS8TyrXQzS2iTDZ1Ukf4-LES1Q@mail.gmail.com> <CAOJsxLF+QposjZjPcPMQMfQ9Z0Fj_uZMU2c9miF_HDqYdejhzQ@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 05 Aug 2011 10:50:24 -0700
Message-ID: <yunk4arn3xb.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 5 Aug 2011 12:51:42 +0300, Pekka Enberg <penberg@kernel.org> wrote:

> See the last email from Francesco. I don't know why you insist pushing
> patches that are known to be fragile in the past without getting broad
> Tested-by tags from people who have been affected in the past.

Yeah, we had several reports that it fixed similar situations, but I
hadn't heard back from Francesco before I sent the pull request.  I'll
work directly with Francesco to try and get the last problems resolved.

His machine appears to be 'special' (it's identical in every way to one
that I have, except that his breaks and mine works...)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOPC1gQp8BWwlsTdMRAkhHAJ0eWDiO9AKw93JQnK8XbgbNgVsrEACeJUAE
ZGRWx/S6lMpy2rjGLQgmBBU=
=Lh7W
-----END PGP SIGNATURE-----
--=-=-=--
