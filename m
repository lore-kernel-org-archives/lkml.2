Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab2BFSQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:16:54 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41837 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541Ab2BFSQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:16:52 -0500
X-Sasl-enc: A8ECewo0LS6ZZs68lLQG8pGJFGEJ2Zs1Y7xmrQeqNxyl 1328552210
Date: Mon, 6 Feb 2012 10:15:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.20
Message-ID: <20120206181532.GA27087@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.20 kernel.

It contains one PCI patch, it is up to you to decide to upgrade or not.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
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
      Linux 3.0.20

Matthew Garrett (1):
      PCI: Rework ASPM disable code


--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPMBjEAAoJEDjbvchgkmk+jZsP/AhlvEUk3Byet3/z2eEwYEPy
ibVz0hLmbwNX+SnlnJu1GVOIBPtASVC1WDFA97w3JAJGDsZhYJH31rW8ehh24XMo
pQRBVNX3ualaQTjLt9goxS8d7GQLMPKZclN+JNFI/q0+OB1H57WhUJ4IOhvFCaOM
HZbFue52aDr4J+9RIn9qQ5N6CqkYioTCV3D50dX1U+uNAtshjflCcryWRYA5mHNA
KxRqyrA7HUP2J/fZzaj87qQ0JJxICY9Pwa7Ks5Vvm3nTWumLHfBmCO+zS88fjKLV
cEXuNXksWWuylbZhBTm9Gh//geoRzMcY/pA/r+CXxKXg9qlfiqs8ZnMpEK2oKkSE
fFqQ7MvHWbkxilRpb7Xy1dw8jrJjH93WrF8wYo5cN28c/VlFnXS9qxr8V0xnn5Zy
LopgHf9cf8k+wSfuC5a82M7BjBYMUFB1xb3GaZvruGkVeXsTvjp0DMF21AFe47Xe
7IL9ovKf28iZ19AkYBFjx1RTDkp9uXPGU5JN6t+yPVkbJHQtr+68Pe9oRhAVqDul
BxNuqACnsRZitBMhqwHPE1Dy3lZuKMp/hGOiDaz6TqUPJ4ewXx9Ko9sNgcTiOYeS
bfMWVrx+CQIkJaBTIYzZQk5cAxO03/SYkwjKZ5tTK6PPGo6JHI0y61uvUziNvLbu
skbyMVJdko5nTl4C3I5U
=Ug9Y
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
