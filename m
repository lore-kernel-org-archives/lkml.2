Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1K1X0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:26:24 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51501 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754445Ab1K1X0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:26:23 -0500
X-Sasl-enc: WyGCTNzBbr11lYehM1+exv40rFa45TeeGKlN7e5qO1Ii 1322522781
Date: Tue, 29 Nov 2011 08:24:51 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.12
Message-ID: <20111128232451.GA21106@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.12 kernel.

It reverts a USB patch that was broken.  If you don't have USB
isochronous devices (i.e. webcam, audio, or other streaming devices),
you don't need to upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                      |    2 +-
 drivers/usb/host/ehci-sched.c |   15 +++++----------
 2 files changed, 6 insertions(+), 11 deletions(-)

Greg Kroah-Hartman (2):
      Revert "USB: EHCI: fix HUB TT scheduling issue with iso transfer"
      Linux 3.0.12


--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJO1BhDAAoJEDjbvchgkmk+OTwP/26Al3geN+LKXKiWFHHQMOfR
2EKQ1qdnbICdllxHXqbyj2hyiUMAF3ivKmmL9MXj+Rxq6r7WJ4FJnJf4a3HhYZBX
veIQOmK82bZJtDZY+KDJl87P6dcBUbcGxc06g6hfy3Y937FYfqTbM993t6XCsPve
zg/Qt2hS/4PTbzib5yvEf3+/Eswsek0iP9PbCnRjtxhLtUi0jiIInnbMMZkOc4j2
xy0Y0gAs8yI3aZcyJ0zwgAEwravSK4+Orb33DGjFCaHPMGktRmWkOH6jO44Gf0y3
1SsAfvuGsgGuDOZ52y/oWXRa0TUQlYIbC+ZM9Z9hTDPEv4pNcVO9Vn/D6w9Eovng
W7fiBbPCngf7RVToqpEQW2eRQ7DBzyex0q5M/PNepEj3kJXzqz7U5jEyrh1/4Qzv
zb2+5nfrI/l2Fi4BrYDtdoDhA5/Mh1xv4V1Ktzhq/GxpD52ZLao5o5vrCQnq//ZA
Vb+8m2hwlLB4+G7FZqld0MEI3PY3vV/Ri3GL60ZQodxyOXJpnuEQf8/fyWhkkvtD
4LbPud+d0yyskLnu6hLYsbKm739gws79Nqw4sew7E8A2cekH4rei+Sh/JZILOGcQ
UhDyr7qzTk7lcGxe6X3EzIyA08StFU5IN9wkJjJ+DHANRtekGUr+dc1dmsL/tKkd
UkDOB1zAjaIlGy4KdTOW
=Q4/g
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
