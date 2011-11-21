Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1KUGhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 01:37:14 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43408 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1KUGhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 01:37:10 -0500
Date: Sun, 20 Nov 2011 22:36:58 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.2-rc2
Message-ID: <20111121063658.GA20521@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Aaro Koskinen (1):
      Input: ams_delta_serio - include linux/module.h

JJ Ding (1):
      Input: elantech - adjust hw_version detection logic

Tomas Miljenovi=C4=87 (1):
      Input: i8042 - add HP Pavilion dv4s to 'notimeout' and 'nomux' blackl=
ists


Diffstat:
--------

 drivers/input/mouse/elantech.c        |   26 ++++++++++++++++++--------
 drivers/input/serio/ams_delta_serio.c |    1 +
 drivers/input/serio/i8042-x86ia64io.h |   14 ++++++++++++++
 3 files changed, 33 insertions(+), 8 deletions(-)

--=20
Dmitry


--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOyfGKAAoJEH70+W8r6ZYqzsEP/i6TsKi/ncR0fL4wQXhXL17K
6wq2Upn6TabB+Eo/TVA6Sk0x3b3QkTVde1hE3i84UFfZ/2YllmwemHmVT7FMS3+I
e3gwwrukPriyJej2cnFg2jLJ3yvVkTux7Mzk2ZuclP+gD73jF4CC23WCeNkL5liH
D1WUGKHJlOxFVMgNo3YzW5uxtFT4zxc28FwfZ+WNzbZiZfo9zcz7tUtwAq29YOmM
DojsRmZrkLLe1o3SRJcs9aAyTRu+K6cwGysag7ps6HcNSXDmI6WW7ATYIV7Og0Xi
aBZg5XOhooybMi3Fyecuz4irNSE+V674Xs+0egxMr27tJaksagy7IkmIh93mu2TN
sV5PMte10Qt0i0gzd0FuhERDTKZTPmnlqwJ853riUrCPN7eih44AZqc5ACrQw8F5
2S0RMFtmXKnxcwaaJTtD2H4976oaYwl7OqnfGe4fxUyBb61o2F4kaA1DnrOcnbng
zPx43YH3QjvowN7yNzLZ9TvrQCQkBv1prJtQgMPkXubBp2V5WiUwBWsfaYe/woiI
NLkyoM8kdSjPUDwAJE6lwBgSZqcyF2cmfrsuqxIzmzdwnel3c705fceMougau6GD
GU4jGJB7vj0UeEuRvzLvXgu1/cP76nX699hyaXMuNMtfbSpYY9ElmfOFBOJBagAT
CkLZEW+HehsXhhx41cew
=xZCq
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
