Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab1LSGWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 01:22:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50287 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab1LSGWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 01:22:16 -0500
Date: Sun, 18 Dec 2011 22:22:10 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.2-rc6
Message-ID: <20111219062210.GA5086@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Chris Bagwell (1):
      Input: wacom - add product id used by Samsung Slate 7

Dmitry Torokhov (1):
      Input: synaptics - fix touchpad not working after S2R on Vostro V13

Xi Wang (1):
      Input: cma3000_d0x - fix signedness bug in cma3000_thread_irq()


Diffstat:
--------

 drivers/input/misc/cma3000_d0x.c |    4 ++--
 drivers/input/mouse/synaptics.c  |   11 +++++++++++
 drivers/input/tablet/wacom_wac.c |    4 ++++
 3 files changed, 17 insertions(+), 2 deletions(-)

--=20
Dmitry


--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO7tgSAAoJEH70+W8r6ZYqbiIP/A53xLMwW/mVWzbs1Xb76Xf4
nESGc9N7Y6FbL5OFtAFVGI043x5RRMZ3Rfvg5cQVUB1uOwe7/RU0lZumJu9Jda5T
AKFugjY6PYk6Nmho3r8aw9VM+Ejex8vPRDMFx9b/9Fg9Ntgje6U84LdIXU6Dl9Q1
seIMJ32Sa7Ni7jb+K5pkrHNcQn0TYNc2kJALz/v/jCMVlczLtzJNnnKvwO/yQia6
eCtkr6huBMRsFzouC7pql7EtmLIU2WnOSFByP8a3Koogh+w3Dr3s97cqRhYNr2cO
VYtpN4mBzpfoCIdySD6dNxlOnV741tHOAUkAc9HHSm9lmTvgVKltMqC0uxoSWLq/
S6TfpaTyHyRyU8pyWP+38wmUug02DM4USJuUBPFZEba5BIZWR30kiHSKQ8B65JxE
exYc+WW09t1zbGrelEx4LpXCdu7ZqMh7GBf/HZnZ6yE5GdFuO5bNTHmU1CMGATkt
R3zHw7pfUBgt2jyrfZTcOUF5X+ngY3Vll4loDwMM4ZLrLmwulk3ZEOgLHFNh15+W
1KC5CT5zo8Fl+iK63qauOBxdU+t/K7PMyasirvwz/LEv8pWntiRJvRW/rWIBsAp9
Kpc825ZGZ5VS3Q7IwpnVTdhEGdL9yiFrooj+0rViWfIWv+YnODawItsJlsxe8SuO
yhjAmTDPtKL7dvPKEjXi
=IcQP
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
