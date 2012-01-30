Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2A3Rnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:43:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34330 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603Ab2A3Rns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:43:48 -0500
Date: Mon, 30 Jan 2012 17:43:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: Regulator update for 3.3
Message-ID: <20120130174345.GN4882@opensource.wolfsonmicro.com>
References: <20120130134223.GG4882@opensource.wolfsonmicro.com>
 <CA+55aFyoTP3G_x9KzN_cdDYUxRGTBBdoRVT56nFODkqukog7aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N/GrjenRD+RJfyz+"
Content-Disposition: inline
In-Reply-To: <CA+55aFyoTP3G_x9KzN_cdDYUxRGTBBdoRVT56nFODkqukog7aQ@mail.gmail.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N/GrjenRD+RJfyz+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2012 at 09:14:56AM -0800, Linus Torvalds wrote:
> On Mon, Jan 30, 2012 at 5:42 AM, Mark Brown

> > are available in the git repository at:

> > =A0git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git =
for-linus

> "Already up-to-date."

> Forgot to push?

Not quite, I had pushed a new signed tag but I hadn't deleted the old
for-linus branch (which you had merged).  Since git prefers branches
to tags when pulling it was looking at the old branch and ignoring the
signed tag.  Should be cleaned up now, at least I deleted the branch and
everything looks OK in gitweb.

I actually noticed this with some other things I was doing, what I think
I want git to do when working with signed tags is allow me to have a tag
with the same name as the branch and prefer the tag rather than the
branch.  That way I can tell people to pull from a given name and it'll
do the right thing if they're using a git that understands pulling from
tags or not.  Either that or complain bitterly and mock me if I'm so
foolish as to have a tag and branch with the same name.

--N/GrjenRD+RJfyz+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJtbKAAoJEBus8iNuMP3dcKAP/RqoiHJcS68ua1SOkXmeySdo
sPQuFC2kfVzs3HltCBIV3lmY5sdzL+z7FGSWOGDj0CzUYk3WI7fDPYs2cBnh0e7K
bEpMkgjvC3bOr+f1I+R71ZaPiRfxkDnMDJA+R73TB21PrgU2utIFSEXMeIu4BSbG
J37z+g0aWH6LA/vL9/y1bg+bsCCo8uGYzfI8h0p9umytaCqXSHhRDexZkSWIsS2S
N78wT11SxFl6Fh3OsgKhJjFiUVsq5nlJ8dDFC4doLuB1KvOEMerOGzXy2zHdfSMx
881rliBJcVVbJewIw4t2Aw1H0gHK23eD2TE3FW+nPp7If1WwjD8Ek4ZzH4T+dTQ2
+DGnjFJg/jQt3NB22y0nqDdAVMuu7Jb1P6r1PWzNnfqt6qVrNC1TKmvF19HGDBRx
YCIg6Qhx1nafy9xLEO1azabwP1GwWXUGPrZPq25A9K/vM/V7P8tVzed3UVZYAZVY
YhIC6xQGpYdAmB9Fsfua6wSJbbnAnm7o2gTbUq0P4l7wDZ+ofHACLACBDWMrwFr9
2SPG9YCf0NUt/McYNYOEVjVa8iwYINJxcHhEv2h5vrsAlVthWUSkcPhmJW0FpDxH
BunlkamzV7Kp+985nGBGLkVB4CmadgFTYToH14Zj/Epg3ns3VZv6uaijtSbqcI32
L5gCjMisAihab1rpvCoP
=eCTy
-----END PGP SIGNATURE-----

--N/GrjenRD+RJfyz+--
