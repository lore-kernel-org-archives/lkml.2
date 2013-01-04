Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3ADI4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 03:56:51 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:44486 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3ADI4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 03:56:48 -0500
Date: Fri, 4 Jan 2013 00:56:44 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.8-rc2
Message-ID: <20130104085644.GA29725@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Just a couple of driver
fixes this time.

Thanks!

Changelog:
---------

Christophe TORDEUX (1):
      Input: sentelic - only report position of first finger as ST coordina=
tes

Dmitry Torokhov (1):
      Input: gpio_keys - defer probing if GPIO probing is deferred

Gabor Juhos (1):
      Input: gpio_keys_polled - defer probing if GPIO probing is deferred


Diffstat:
--------

 drivers/input/keyboard/gpio_keys.c        | 13 ++++++++++++-
 drivers/input/keyboard/gpio_keys_polled.c | 13 ++++++++++++-
 drivers/input/mouse/sentelic.c            |  2 +-
 3 files changed, 25 insertions(+), 3 deletions(-)

--=20
Dmitry


--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ5plMAAoJEH70+W8r6ZYqUYwP/jXM3wMwIA3pZdKvGq8DuWiq
giGPY53XP67MxIeC6VvVVeXMAGL5Y3LXegW1P6pguN6ISx7jGIm/Aj4mO8ocXRv3
T5zTiEOfJSXdyr+c9Ae4Lc4TcQZg6wlMZ+b5UelYAJhjQu4JjuaOyOr87aD2bXDb
fGYeTG+6PhebErR2ZSzg0rSP6uPjnc4U6JWJsZfzlpgKmd7ySxRkc7ufe/rhnG7n
dSVEhRC0x8Y8rTm2uflsF+H49GYNFalVotnKewa9lM8ro/rXv/fjK8L7YzBS5/xY
HFGaygFeXAPRw49kDHP/LSzylDteuYWkRJeRM9CwkjfaPFaYoY8lFt5AJbCghUSe
NQR/qjxSKx4Nw7tSWXVqAAJKwcbsjx0zP001N7HUrUTjg5oYRGRdT3S0DrgHaO0U
wQU6FVc2K1U3dLBElON7ktwl0+wtSAOM3NevpoD12ZYY/pCu6YplRS4Zj6PGzoh/
lNBjYbbPePDju8uc9iiLEtnktRTWs24Tpl2D+iMMBJD3YzNmMvuKNi6anXpyMnAk
JrLlD0TL1kvgtpDJnvbhcwSWcV0WzFrxiyjlC6fKGrK125BQPTTZyjdNmCzsIRcK
LKB/9iqusDac2kLOruff6KdELo3GYjxdxHKASEtGSimS2fDIhcpiBTFQSOP/imPS
gbd1ni9kQgxJOE53J0Vi
=ksdY
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
