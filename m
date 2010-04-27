Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab0D0T43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:56:29 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:50593 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab0D0T41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:56:27 -0400
X-Greylist: delayed 1151 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Apr 2010 15:56:27 EDT
Subject: [ANNOUNCE] upstart 0.6.6 released
From: Scott James Remnant <scott@netsplit.com>
To: upstart-devel@lists.ubuntu.com
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-miXh/zXmUCk09iixvIT6"
Date: Tue, 27 Apr 2010 12:37:06 -0700
Message-ID: <1272397026.1617.13.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-miXh/zXmUCk09iixvIT6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The main change in this release is that Upstart now takes care of
mounting /proc and /sys on boot in the case where they haven't already
been mounted by an initramfs or initrd.  This corrects the long-running
"chicken and egg" due to Upstart's use of /proc/self/fd to execute shell
code, and allows Upstart to use /sys in future as well.


0.6.6  2010-04-27  "No, she's dead, this is her son"

        * Upstart will automatically mount /proc and /sys on boot if they
          have not already been mounted by the kernel or initramfs.
          (Bug: #426263)

        * Fixed double-quoting issue with the --with-local-libnih configure
          option.  (Bug: #530385)

        * libnih 1.0.2 is now required.


The tarball can be found here:

        http://upstart.ubuntu.com/download/

For more information on upstart:

        http://upstart.ubuntu.com/


Scott
--=20
Have you ever, ever felt like this?
Had strange things happen?  Are you going round the twist?

--=-miXh/zXmUCk09iixvIT6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkvXPOIACgkQIexP3IStZ2x3egCgh7laFVTr8kXZ0Bx80w1l1hBL
GKMAn1gL3+fIRhRi9zTrZ2Yg1PeH19+/
=41GF
-----END PGP SIGNATURE-----

--=-miXh/zXmUCk09iixvIT6--

