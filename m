Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab2KEKKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:10:54 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53701 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2KEKKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:10:51 -0500
Date: Mon, 5 Nov 2012 11:08:38 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.51
Message-ID: <20121105100838.GA24443@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.51 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/feature-removal-schedule.txt |    8 ------
 Makefile                                   |    2 -
 arch/x86/include/asm/system.h              |    7 -----
 arch/x86/kernel/process.c                  |   24 ------------------
 drivers/block/floppy.c                     |   37 -----------------------------
 drivers/gpu/drm/nouveau/nv04_dac.c         |    8 +++---
 drivers/gpu/drm/nouveau/nv04_dfp.c         |    6 ++--
 drivers/gpu/drm/nouveau/nv04_tv.c          |    4 +--
 mm/rmap.c                                  |   21 ++++++++++++----
 9 files changed, 27 insertions(+), 90 deletions(-)

Ben Skeggs (1):
      drm/nouveau: silence modesetting spam on pre-gf8 chipsets

Greg Kroah-Hartman (1):
      Linux 3.0.51

Herton Ronaldo Krzesinski (1):
      floppy: do put_disk on current dr if blk_init_queue fails

Jan Kara (1):
      mm: fix XFS oops due to dirty pages without buffers on s390

Len Brown (1):
      x86: Remove the ancient and deprecated disable_hlt() and enable_hlt() facility


--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQl5AmAAoJEDjbvchgkmk+sa0QANAgiE33Bhrg9cqxaVlWtH9y
Fj86k/ZiaeV/UJquuMFVDkcrqnTBtjvhUbuhqW1F8fkHnr5MmqpJXjy4jc9Zgt1M
36E5FtlIkxrpWwFUIznAUPcVLZ/Cn2HjHKihldQbS/M3cnPPOIEbOjpA0UObwm+D
C7xflF9SpyBh4leLrq7rO9tZBObK6SGBmpV22r2rIoPTxGYKyS4qe98I9G2+5QTf
RuF4MCn5CGXveGxDX8fhN+1BYVQMr5yBoZbXwG2WCbGr1LTrzgTlVNGuou/MBkc/
AZfZzXGXu/r3o1+AhswXVo8C8PIFIl2omjF1+/viDIzRZILF2cZVEqc92LYXhKLM
+zi6pS5TTlyzdIoz9XisW9+YGNdViqbNCSYWisCqLd+GcstZD7R/cmCTjdOdv5U0
oOn+j9oYNTYb9m0ddrUi/iOb1qmwBfcqdIjIJeC01a2dBq5XDjFv5fYObXKygHcX
IYJq81Syo+nhqMfi/7vwlRlwcovfYEjU4hyQC1k/TF217M2kMsB0aQzNxr9H2JAR
EUj63urfd0769etsnrzcXAdv2DtNgR64EPaiIWUkPo4BP3zacHF8V6Nvd1KdKyPi
U/1b6sjeYw7Pzr2QUZpwF8ox1OUElDHrvRvj4aJxpxZ9BHxWLJoWoJsTAxs7oGBS
qjZezQxLpTx3JXtvt6aD
=6jXZ
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
