Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab2BCUuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:50:50 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34388 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757596Ab2BCUus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:50:48 -0500
X-Sasl-enc: XOFvrxtdqyVEPHPto95q0O1BxZtQezGVQV5+QHPZ9+5y 1328302248
Date: Fri, 3 Feb 2012 12:50:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.2.4
Message-ID: <20120203205027.GA1042@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.2.4 kernel.

This fixes a build failure in the 3.2.3 kernel.  If you didn't hit the
build problem in that kernel, there's no need for you to upgrade to this
release.

Many thanks to Tim Gardner for pointing this problem out to me, sorry I
didn't catch it sooner.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                  |    2 +-
 sound/soc/codecs/wm5100.c |    3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

Greg Kroah-Hartman (3):
      Revert "ASoC: Mark WM5100 register map cache only when going into BIAS_OFF"
      Revert "ASoC: Don't go through cache when applying WM5100 rev A updates"
      Linux 3.2.4


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPLEiTAAoJEDjbvchgkmk+3ysP/jI80lZefB/N7BP27JwlwLdv
hym4qt2ofuCV/eNNSWYKq1dFwGL2KcZa12aTvl3xl8FeHX9G0ReafwBxYOIqgLQM
VlY0s4UXwRCKybIR0LJ6vXW2ECzUHcTaDJPuQ3EHPjYRdp0Hw4jf9CnIdjAM579H
omFxC7iZz9E+Ed3NtDqNv9giqvhj/4Z+tkFvmGPp6ry0CHTohwcPt297xUCYLXQD
GZqIOjHSUw1B8qR9bK2DHg4KwKeEPXpQqmIOhWSXYcbr7Bu/odEJTbtXWM0589cW
esnIBwELH6YuNPqsbxcpzTz4M8LvbneNTIXxFH4/BsS/l73LInWMkIx8NwiM5H+z
7qzZSPw7cKrb0wd6TTGhOsBJH/SB8VxUYxKko2vknt1oddxaFTZnsBTF+xgs4WVM
VEG5Rjzoo9mYXYc6bF8YF2U6/f0E5C9EO620a/KYNBKho+g5/ilaFT5fHx64DoPS
JK4DXwsQLfPPPkStCi7tyczh54Ae+aoVuyoPmAz8ezLpjSb+B4fB3saMaLkhVYw9
xw6P5gjusEm9yPB9CzHvAarJT9F52AGc8ikNdg3XcDu6lf5DFnqszN51EYaBjH9Z
P9xDHJdtZLiqB33M8E1Kp/SYE7gYUBTt8gtqTo54km0/urGuJRa5V9E0T7/JxLTT
Pari7Wg1ivflKA+VntD6
=VQh9
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
