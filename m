Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab2CMRNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:13:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56043 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab2CMRNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:13:43 -0400
Date: Tue, 13 Mar 2012 10:13:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Ben Guthro <ben@guthro.net>
Subject: Linux 3.2.11
Message-ID: <20120313171333.GA18203@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.2.11 kernel.

It fixes a single build error in the 3.2.10 release.  If you had no
problems building that release, no need for you to update to this one.

Many thanks to Ben Guthro for pointing out the problem with 3.2.10, it
wasn't triggered by my test .configurations here.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                  |    2 +-
 drivers/mfd/wm8994-core.c |   14 --------------
 2 files changed, 1 insertion(+), 15 deletions(-)

Greg Kroah-Hartman (2):
      Revert "mfd: Test for jack detection when deciding if wm8994 should suspend"
      Linux 3.2.11


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPX4A9AAoJEDjbvchgkmk+/1YQAL68LFDDIZ5jqwhsZRSmUrVp
MdN2gl3aORJVbtIbjvR55Pil2RoOSaL3pHmNZ/kQzY/Yl8jFvRMwSAnmXWm8DyKJ
of3kwU56R9MsDyc3fK3ZQ6+hxrKwL2n+pbp246xQo3whnenevAZHTClv/yuvEVcJ
IQJ1lbUSdTrDtABx+I90T1wiYD0RxCqor+kUR4aDQ6BarQycqnchapti/j/4ZGvL
HjhB1QbI5tFEqT8SPcwErYADgeyeTTJfIlWaM+2MCJVBFc31XHu4mH1ubHiwJmhb
TpWL94lzXNmDwq55qLJLEq8GHihPdBefqNr8IDGirGUhxRXv7FzgYQ24mDoc40T0
PFQsqEik98L1VT8LjVx0XE17INKD5UYRL9twwKmANA9Dt+qMtmwlsN5Ax67D+agD
yZ59fXmZnghrxVH5mUz0HcuWy4H4Bdz4dRf7GKKcK82B2Up6c5bNFr+oobMetnkx
JYKuBuziG5vxhRlhrdG/VBEgM0LViCLl9sgiyGJUX6ZmuEJP8oGPsM4YbKiqj5WY
AHOv6Sqs3QNd0jNAeLaaq4YU7y6H0jq67QHhDaCVGWuBopgyYcCJa7feua87wMC0
vAON99yNR+QRcIfbDlasz2WQpCuvO6kNmMEtPm5mlMMgDCrBy94rGmOnEKltswGf
7rhrg5njgl2nT5GvV+tc
=NI1/
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
