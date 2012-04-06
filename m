Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2DFKlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 06:41:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60658 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753845Ab2DFKlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 06:41:07 -0400
Date: Fri, 6 Apr 2012 11:41:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap fixes
Message-ID: <20120406104103.GH3172@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YrlhzR9YrZtruaFS"
Content-Disposition: inline
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YrlhzR9YrZtruaFS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-3.4-fixes

for you to fetch changes up to c04c1b9ee8f30c7a3a25e20e406247003f634ebe:

  regmap: prevent division by zero in rbtree_show (2012-04-04 23:22:15 +0100)

----------------------------------------------------------------
regmap: A couple of small fixes for 3.4

Two more small fixes:
- Now we have users for it that aren't running Android it turns out that
  regcache_sync_region() is much more useful to drivers if it's exported
  for use by modules.  Who knew?
- Make sure we don't divide by zero when doing debugfs dumps of rbtrees,
  not visible up until now because everything was providing at least
  some cache on startup.

----------------------------------------------------------------
Mark Brown (1):
      regmap: Export regcache_sync_region()

Stephen Warren (1):
      regmap: prevent division by zero in rbtree_show

 drivers/base/regmap/regcache-rbtree.c |    8 +++++++-
 drivers/base/regmap/regcache.c        |    1 +
 2 files changed, 8 insertions(+), 1 deletions(-)

--YrlhzR9YrZtruaFS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfsg4AAoJEBus8iNuMP3dhqUQAIVBJoGRdppSOMbPzZUGOb1K
Ya3DxxYlMsowm4ru8pDGgphVOsaeOFTv916ydkOT5tj/g61O+pJrfPliTh7UWi3d
nLMPj00gGgPYq2/lYIF3IJcvUWaGFhOf5KffV8G274RibaKBX7HxnEoPeSZMqOye
AHHtCfGRB4BoLDGc42el4TRZCkVq01mr7Vu9AZ6OCACx4+EfgRxASPa9dikms3Fe
tq1QyNKW8y7IZmBKmaufVkMW4mk0gEtpM2MxMiLktsxmDPCFWcTv6JX6hp4k7Rwa
Qv/4xa3P+mXnD2kEZd6NREHs9IGTCLf6KbJmHKtXjpCAOj5cpkqP76pnFRkuY6Vc
POqcfrdVnKGC97cgbkfiJ6dfyyUAVzve6X1QAqpe9Qsk9FNKjU/6WeGwqt3Mzfyj
LX3uNmyxYeTSlvWClezPaNXhqE0muLxRUdxvzRDFqT8VLJEdmWeV+611oFKkojlf
FS1I1GEm0o93jrfkn9KRyiW4czgHrn/qv2xY5BAy8IXZ7GBC0+804PAW1WwxRvSg
xnZuPJRYAbUdyGOPypPnV2Uw6jfZsd85tywbK5sphsNDn58+a6cKSeVgFNCVVHvE
4Epea5aMYJQfXBQ0/3r0tE0yQgNhvDeEIPAY3X+3oExdEP+OzsXqhHOAKQLDM0fS
RrcEuJu4cyUhIYmW/O3s
=EGk7
-----END PGP SIGNATURE-----

--YrlhzR9YrZtruaFS--
