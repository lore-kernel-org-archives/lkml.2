Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab0LWLgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:36:46 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33635 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab0LWLgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:36:44 -0500
Date: Thu, 23 Dec 2010 22:36:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: linux-next: build failure after merge of the final tree (ux500-core
 tree related)
Message-Id: <20101223223634.8c92ef31.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Dec_2010_22_36_34_+1100_/VQl5OvtmOBhJKmS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Dec_2010_22_36_34_+1100_/VQl5OvtmOBhJKmS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

drivers/input/keyboard/tc3589x-keypad.c: In function 'tc3589x_keypad_enable=
':
drivers/input/keyboard/tc3589x-keypad.c:239: error: 'keypad' undeclared (fi=
rst use in this function)
drivers/input/keyboard/tc3589x-keypad.c: In function 'tc3589x_keypad_disabl=
e':
drivers/input/keyboard/tc3589x-keypad.c:268: error: 'keypad' undeclared (fi=
rst use in this function)
drivers/input/keyboard/tc3589x-keypad.c: At top level:
drivers/input/keyboard/tc3589x-keypad.c:448: error: expected ',' or ';' bef=
ore 'static'
drivers/input/keyboard/tc3589x-keypad.c: In function 'tc3589x_keypad_init':
drivers/input/keyboard/tc3589x-keypad.c:460: error: 'tc3589x_keypad_driver'=
 undeclared (first use in this function)
drivers/input/keyboard/tc3589x-keypad.c: In function 'tc3589x_keypad_exit':
drivers/input/keyboard/tc3589x-keypad.c:466: error: 'tc3589x_keypad_driver'=
 undeclared (first use in this function)
drivers/input/keyboard/tc3589x-keypad.c:466: warning: 'return' with a value=
, in function returning void

Caused by commit 1967733650dac41c93954a187246c91430c4a94f
("input/tc3589x: add tc3589x keypad support").

I have not taken any action as I am not releasing linux-next today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Dec_2010_22_36_34_+1100_/VQl5OvtmOBhJKmS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNEzRCAAoJEDMEi1NhKgbsrwkH/3wU6blFLZWEYoGJXsc6nvkK
Z6X08tIPkKeJ6JFQC0xB4sgFwnp6vbEp+0QQwcWtgUZ2hxYQq/9PNu/wewnSBj9b
UiPFrJHe17nb5r+b/WoEVYPXValMwzgXYUHTXK5e4vbyEFBFuDs0ojsSTxR1N5JT
9iTERb9c2DSPNYzaabwE3LMDYtIq1O5hFt6F2JGuQV/tqhnl3I24vRoWKqHJ6sOX
1DXOBtqgb/UNqqPQ8sFWifL/31RXQWz2rUOTgiA6F0QJU6nFwIXGQyRE2um0ZX12
5oINydsQvuAK+kYD+FklE8lcPrplh0Jdrqp1AUUq0MFHDT6fOCvQXdFVJkrfGWU=
=X+Js
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Dec_2010_22_36_34_+1100_/VQl5OvtmOBhJKmS--
