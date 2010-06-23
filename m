Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab0FWJwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 05:52:08 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:55028 "EHLO
	archlinux.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750967Ab0FWJwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 05:52:06 -0400
Message-ID: <4C21D941.9030904@archlinux.org>
Date: Wed, 23 Jun 2010 11:52:01 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.10) Gecko/20100617 Shredder/3.0.5
MIME-Version: 1.0
To: David Woodhouse <David.Woodhouse@intel.com>, linux-kernel@vger.kernel.org
Subject: linux-firmware tree vs. linux-firmware-from-kernel tree
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig4CD3FF5F7708BCFE74760936"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4CD3FF5F7708BCFE74760936
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hello David,

After switching from 'make firmware_install' to using the firmware files
from the linux-firmware tree, I received a bug report about missing
firmware files. While investigating, I noticed that the following
commits are in linux-firmware-from-kernel, but not in linux-firmware:

Ken Kawasaki (1):
      pcnet_cs: add cis of KTI PE520 pcmcia network card

Michael Chan (2):
      bnx2: Update firmwares and update version to 2.0.8.
      bnx2: Update 5709 MIPS firmware and version to 2.0.15.

Vladislav Zolotarov (1):
      bnx2x: Use firmware 5.2.13

Is there a specific reason why they are missing? Can you merge these
commits into linux-firmware (I did it locally and it went fine, apart
from a minor conflict in the WHENCE file).

Regards
Thomas


--------------enig4CD3FF5F7708BCFE74760936
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEAREIAAYFAkwh2UEACgkQEda5KzHP/VDWAQCeOY/4W1UbO9D33u22ywxufA0N
DsMAn2YUZPccpgDQcHVjEgIoDEhWdUw8
=QrxN
-----END PGP SIGNATURE-----

--------------enig4CD3FF5F7708BCFE74760936--
