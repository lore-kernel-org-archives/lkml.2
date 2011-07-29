Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1G2WSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 18:18:11 -0400
Received: from home.keithp.com ([63.227.221.253]:41138 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab1G2WSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 18:18:09 -0400
From: Keith Packard <keithp@keithp.com>
To: Gene Heskett <gene.heskett@gmail.com>,
        Ben Brewer <ben.brewer@codethink.co.uk>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: i915 SSC Patch
In-Reply-To: <201107291801.40049.gene.heskett@gmail.com>
References: <4E32ADC7.3080002@codethink.co.uk> <yunwrf1gc3b.fsf@aiko.keithp.com> <201107291801.40049.gene.heskett@gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 29 Jul 2011 15:18:05 -0700
Message-ID: <yund3gshgte.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Jul 2011 18:01:39 -0400, Gene Heskett <gene.heskett@gmail.com> w=
rote:
> On Friday, July 29, 2011, Keith Packard wrote:
> >On Fri, 29 Jul 2011 13:55:35 +0100, Ben Brewer=20
> <ben.brewer@codethink.co.uk> wrote:
> >> I've added a global SSC (Spread Spectrum Clock) parameter to the i915
> >> driver, since having SSC enabled breaks (distorts) VGA output on some
> >> Core i5/i7 chips (see
> >> https://bugs.freedesktop.org/show_bug.cgi?id=3D38750). SSC is still
> >> enabled by default so the behaviour won't change but setting the
> >> global_use_ssc parameter will turn this feature off and allow affected
> >> devices to function correctly (notably the Dell Vostro 3300).
> >
> >The question I have is why is SSC enabled on the VGA output at all? I
> >don't see any way VGA could ever tolerate it.
>=20
> Something does not make sense here Keith, so I'm with you, and my=20
> background is from about 60 years in tv maintenance and 45 in
> broadcasting.

Right, I think the basic problem is that we aren't switching SSC on and
off based on whether there's an output which can't tolerate it. Making
this user-configurable doesn't make any sense, it clearly needs to be
done in the driver automatically, based on whether there's an analog
output running (VGA or TV).

> Hardware design error in the Dell?

Nope, just a driver bug :-)

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOMzGdQp8BWwlsTdMRAkNnAJ0U6QuuCzakC8t/3qyUnFrfX+s21QCgtGru
5cBVQmwNoouZW1hlUmJWfWw=
=xApM
-----END PGP SIGNATURE-----
--=-=-=--
