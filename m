Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab1JCUhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:37:01 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35291 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932313Ab1JCUgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:36:46 -0400
X-Sasl-enc: NMVqI/JtarCI2zCZHOwG14aRCyGIFSMEE3S4IOU5ESE8 1317674205
Date: Mon, 3 Oct 2011 13:35:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.6
Message-ID: <20111003203537.GC22113@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NklN7DEeGtkPCoo3"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.6 kernel.

There was a build error in the radeon driver of the 3.0.5 kernel, so
this update is only needed if you have problems building that kernel.

The updated 3.0.y git tree can be found at (NOTE THE ADDRESS CHANGE):
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                      |    2 +-
 drivers/gpu/drm/radeon/r100.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Dave Airlie (1):
      Revert "drm/radeon/kms: fix typo in r100_blit_copy"

Greg Kroah-Hartman (1):
      Linux 3.0.6


--NklN7DEeGtkPCoo3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOihyZAAoJEDjbvchgkmk+qIUP/2hoX93BrOPWpgAzfdFoHuFF
aRN5WC4TAJ4xUD+cODBLh4pAQVEyYxBZAoYRQFf7nnsLoOQa35wDS7SYrc32MSMM
lqO0RBMjhesiTMHcV0aRNQXlC2aGsaaHbNZ8oC6brVBdazz4HMC2QJSUEDPsNSxd
327Mrf8ynvqbq6vjtahVSDBjVIvb8V42kL4orRLfUR19velO+hGVYt0rHuPbp0jS
K3dsMgRQ7/OgAdVekWx3DxDnQRTaK6c/rQ8SI45Ye3xhWX53gEAFcwmsDkGww9rY
1cIV5L6Xwcz7k8odNkYQmuf+pwM+32lDiwh1WsImjFZWBfyFkT6pkMKC2s2ddyHV
IX6HTCOE7vHvVlHgScBd/FqKzR6yknrxqzMD7jEpnk7s2hi3tt1R61h4JnOBXmSz
WBkxKMkllJcIOJqmRGcsdLXMSrNAImPOx8M3tJNWAqv65L/CpT3xWzSAoHm5bIvR
ADyxaptgUpvydlhiitOIQBVG8j0b4yh3y/ESnXoRhiksLh4renJ0MHEjL+o2EvYD
zKEMJ/xlsXu2r0pKjQyjOPB8suzxMYinXm9jpdZdkmYpsL33P1zS5/jyiMnEtoHp
hOKZg2ahLRQhd6pTLLWkn1GrAGdrduJ/+gNJ0Q44mvhVNoHdl6+qbcpteiyzTKRL
q8qPV3ycwPiFH4smkD7+
=QorO
-----END PGP SIGNATURE-----

--NklN7DEeGtkPCoo3--
