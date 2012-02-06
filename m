Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2BFSQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:16:56 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58850 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754872Ab2BFSQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:16:54 -0500
X-Sasl-enc: tQHChqrVunxm6I7doOH89DyTK95z6sZVK6ykS3LasBQo 1328552213
Date: Mon, 6 Feb 2012 10:16:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.2.5
Message-ID: <20120206181622.GA28811@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.5 kernel.

It contains one PCI patch, it is up to you to decide to upgrade or not.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                 |    2 -
 drivers/acpi/pci_root.c  |    7 +++++
 drivers/pci/pci-acpi.c   |    1=20
 drivers/pci/pcie/aspm.c  |   58 +++++++++++++++++++++++++++++-------------=
-----
 include/linux/pci-aspm.h |    4 +--
 5 files changed, 47 insertions(+), 25 deletions(-)

Greg Kroah-Hartman (1):
      Linux 3.2.5

Matthew Garrett (1):
      PCI: Rework ASPM disable code


--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPMBj1AAoJEDjbvchgkmk+Oq0P/01KqjMrb65qrISz+YWAPqkG
zylRRARHOE9P22heknhaMnSuKYp2Gy9OV2ICp5dWHUMzsKiSPhINuRB3Qtacn2vq
zRucOfTfyNh181cU7fCUTTRVr3zuPPsJ9bjR1dm6OP4vB47JQh6qX8Easc86R11M
x/iuA5BVuw28DqyG4T2g2/m4gBjh1l9lrmDYRgj4NaO5BdCcuwzeATM0b3gy2iwF
2fegN+yt8bAW9IsdZlghhTGVaSgY2OQGp/bzJac9+NbhgmwTCNCnsL1Z+wdCemz2
ndj7y/NKgN2yMSjDTB6ZYoFDiu3oqHmKhbP9APm2MHcOSQSTfmuFWtpEU2y1M2hl
F3vjAno3GE9XBwgIqr0Y1S1eQm2AIW5qaf2dTNeJ48vYh7LAkChxG/m3of2gt8wt
G5eFP1bZ/1bms6DFIqukzz7M5NFghxuH8pDwGpKf2CdiHUXQzHp4iQEyR3RMq+0j
UyymkDZ02Oeq3bCqqIeAq8V32VbCiBvwY8bT++Z9rzqFLedgfIjPb4s9nvXpeQAM
aB6ZnKfWkyP2jLGXpF88d4Hn2zEs22YNqtOa6WnRAX+HxUZGfn7HGqgzxSp09uQ9
2tNtomlm7YaeYbyzmDYwDnhlSVP+50396Gf5968e1JEBBEDhPTE5bBqwBIMNCrqn
eqbTYdjCX7hguFA9D6Eq
=rORu
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
