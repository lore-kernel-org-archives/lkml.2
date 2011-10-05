Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab1JEG3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 02:29:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56870 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab1JEG3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 02:29:50 -0400
Date: Tue, 4 Oct 2011 23:29:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.1-rc9
Message-ID: <20111005062944.GA31646@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://github.com/dtor/input.git for-linus

to receive a fixup to wacom driver.

Changelog:
---------

Jason Gerecke (1):
      Input: wacom - revert "Cintiq 21UX2 does not have menu strips"


Diffstat:
--------

 drivers/input/tablet/wacom_wac.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

--=20
Dmitry


--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOi/lXAAoJEH70+W8r6ZYqA9EP/RPOHA8Al6+mtacHFGp4KSm/
ZHAjKCE1qjb1+aFm1UL4VFWe9g5b1khwRFK5CsgIOR2/04zqA2iOQ0Wdrk4s5PKy
uv3/lP5gIBAdUzAF8ew54IV7hpzV3ABUl7yGaaLBJjRL1srCcdOVH9FEqgAXm5RG
/lTYi7E83Aw2wDah/xAqaXyx3JdNmG5sTOKcbkAo+8zx+nKfOpXgB/biLSokBjdu
KSJeGO7lBSGxttQ/aq6Tybwdr1Q1ORb+uYVS1/Bpvi6AgFNrYHcOTP9qS9/DpOuW
REf40yDfSivgrd1qZlB0VTtbfxULBNyn1+3nA2POsD2+Op2lxFISgZDXm1TFsPKa
KXl+mldRUhWyzrcbwi2ETo6t9MtvF8H92hhYV33anKUxSHPyFhfH0cyWDgHSgdzq
T62/AB7ORYnv773sJZAsGUMiUZnADkQVRq4lXXcb8VpCBBNGLtXaCQjO5rinkS+y
lfb6CR/v41WXJO4x29OO8GCUdd+LtqgMG/8goxb3GpjJPxM4vbiu9sMgoyhxATRG
7j3bYCkIziKnAWoAfAwVcL2WsogIXa453waLdtdKzyPF+SHeKG9RsrI2cwJDU9ML
lIn7Fo/Eb8yezEbE7DDGL10hB5wwB6nBvDpEQfFLbKF/qQ6P4VCwtprmv8pW9QUE
yf2HXSXLMuJAyG1Sb6Tf
=QJ/y
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
