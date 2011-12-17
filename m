Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1LQE26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 23:28:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37587 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901Ab1LQE2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 23:28:53 -0500
Message-ID: <1324096119.2825.310.camel@deadeye>
Subject: [PATCH linux-firmware 0/4] Complete source for GPL'd firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Dec 2011 04:28:39 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-wleZHEGLMukLPGlQOtvU"
X-Mailer: Evolution 3.2.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wleZHEGLMukLPGlQOtvU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Some of the source code for firmware licenced under the GPL is not
included in the linux-firmware repository or has incomplete or
inaccurate build instructions.  This series adds the missing pieces.
With the appropriate tools installed, these makefiles produce identical
binaries to those already in the repository.

Ben.

Ben Hutchings (4):
  dsp56k: Add makefile for building from source
  dvb-ttpci: Add source code and makefile
  keyspan_pda: Fix parse error with as31 version 2.3.1
  keyspan_pda: Add makefile for building from source

 WHENCE                     |   10 +++-
 av7110/Boot.S              |  109 ++++++++++++++++++++++++++++++++++++++++=
++++
 av7110/Makefile            |   11 ++++
 dsp56k/Makefile            |    6 ++
 dsp56k/concat-bootstrap.pl |   33 +++++++++++++
 keyspan_pda/Makefile       |   12 +++++
 keyspan_pda/keyspan_pda.S  |    7 ++-
 7 files changed, 185 insertions(+), 3 deletions(-)
 create mode 100644 av7110/Boot.S
 create mode 100644 av7110/Makefile
 create mode 100644 dsp56k/Makefile
 create mode 100644 dsp56k/concat-bootstrap.pl
 create mode 100644 keyspan_pda/Makefile

--=20
1.7.7.3



--=-wleZHEGLMukLPGlQOtvU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATuwad+e/yOyVhhEJAQqg3xAAsoeJvkDCY+SmF/wUGpzRSITJhSQ8vHjY
EvUXf3J2p4zT2UrazRx+O5J+MMiulrjmqCkASTLWtS+wg2L8zMdc7fYtXOgozszG
NJVWeMqMQ4ps5T2Dom0wna+XFyEbjWZ25qwRqnuh0TAHFZb7YmVEAwoeu5Gz2Fgs
jo4KodeZlzTKrB+zPgyKVvLTfw3yeQ11G9cuwfExdpJtn95MHwn9dCCsQd4dTUKH
6nMxBXcYKTnuZrwmSFAuEFCLLfTBR3TnIaVZUU+MCwzEdk+cmPNlhIwm+XIkTM4T
+/pEroP5LG84ETOWkD+7Z0/EvCqnm6rCIVMB3zG1ibijUwWTNlv5AxE6HGNXA7fS
R1NjyYbJdKXp/opz5ubOMM78pLyx0hzxeqbnYobZq3sWwtHwv5Pm+CUK6x6cWnHs
RAmHFiYWFehrVNLRCHvRjg1l0a0Vt5uwWmGvq/n8i20sblLIbb2I8CBrGkpMwYXL
C1mSXUqCf517WLmnXLJLK0v1DoRM6w3cx4yKe9bFZs0u6UlTg655F/4rsF5xEOYd
2UlyFMBHC0emvW3CAJzohsUc9nQnI66YaIhcJOUufh5NmYcVWovGhzVKIrTp5L71
ckeKjxJWOX9D5ML1uBALeL1CbGQDpLS6SI/YtmCs390tJW6q3y/y+3CZcyViFSKb
/WoIJhp9glc=
=qIPq
-----END PGP SIGNATURE-----

--=-wleZHEGLMukLPGlQOtvU--
