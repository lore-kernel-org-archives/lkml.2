Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab2JVPoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:44:19 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54454 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab2JVPoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:44:12 -0400
Date: Mon, 22 Oct 2012 08:44:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.48
Message-ID: <20121022154408.GA21144@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.48 kernel.

This reverts one patch from 3.0.47 that could cause problems.  Feel free
to skip this release if 3.0.47 is working, it's up to you.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile         |    2 +-
 block/blk-core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Greg Kroah-Hartman (2):
      Revert "block: fix request_queue->flags initialization"
      Linux 3.0.48


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhWnIAAoJEDjbvchgkmk+YsEP/jj6xqVWn1a/69uq4MVwAOEt
a81JUzbJm8UHV1jS1MVS1QOLXJ0V8Tm3cKSBonNe8dLOGIHBNPK/I0SnH2+POUga
cOIiKDWVQ74CwSJ0iaQUOY+ZUDtPhAIKjYfuvnI8tiM9bBxm8bTcHPwMtsXGvxEW
GOpkNK+p88yfsd+GVB99q3tvwvrS9LaUf1UOcZjZ0SibsXbF4WTssIzjgrw5htPf
Y8JTwBcxxg0j3u5bkEPjuiFPGH9eIa1VdGZjlgI0X8BVTYO3/NMJxvzpjymq/maY
X7qPy4ngr5bltTOHtWP2JGYHNi0rc3O3AssYFX/CqgFfVk4QcQHUkiz0jmGe7pGy
GJKmT7Q7GUGD1r1w/7cVxZECNAyjn3y1aQmTGM/8lLDr6n9lEXcdg6eP35KgWpEA
T6owJXK2COjO0HyyEi+FqzKEWJhoPD7422Zw1vZM7da86f3XEF6VEBJ858FqCgqY
ApmbDn2skQx1OJFoqTMPNv0FmP1Sa4yh/4b8WmS0oJEd61NeH6Q5iZ6E2bBnkvaC
Gpx4Ng3/MioHE1wP39IS2A+6aPVpgf4OAUmQxNedsDOa04AdGs45Vn4MkqHbVgvh
QGjhy3Vv8Ma9DeKicKBa7k5VQ55+lkEAsA4shqIKfSnRLqOlPwSidoe5m5j5iMiJ
k5OTbuhOnC9ptqtMyune
=rP++
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
