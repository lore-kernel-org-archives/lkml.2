Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab2D3Gj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 02:39:26 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:65070 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2D3GjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 02:39:24 -0400
Date: Sun, 29 Apr 2012 23:39:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.4-rc5
Message-ID: <20120430063919.GA22582@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive a simple fix for a recent regression in Synaptics driver.

Changelog:
---------

Benjamin Herrenschmidt (1):
      Input: synaptics - fix regression with "image sensor" trackpads


Diffstat:
--------

 drivers/input/mouse/synaptics.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

--=20
Dmitry


--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPnjOXAAoJEH70+W8r6ZYqaOcQAIgzTaIghQoVTAMAyOexLb8y
oOtcDoAsDHtUtnl1nbQr/5VQlBSzvb/WooAiGhATKnJTNWwkHVvVxKhf9xvOebEJ
D7bSpcTqzedbFXBluemu5PSHvY/1880PGZjz1PvHTGXZJ6an1oHFNaLgjysJtUtN
kDyoVYHh1zs6KSlVOfIL7AAyWoz+hqXoQdfzQM7lQ9MY8cV7eDbPHapjywIdScDr
Z7lYyvG5/WlV3RJkhNr3rud9n28Qo9TCgkVMjqvUo6rfCGommwP/sXC6KBxC+vGQ
YCeBuwU+z4jIN3PhKkdwPmMZg2ADksLT3diDSmB/d4vEmaL3PIQ3z+rs13crujH5
Sw1SMaVrzy2qs3uDAb63X8LALxHOs2WqO/SGWPy0RlmT7V/m67zTwUFrYqOCRQvJ
ofn4QahFdZPoX6Zc2NLi2h1F13vh6LZhqSV9Nt2ZT5VgWgTlVhRf+NctTAW3M847
60+tiRAzh5nx7M/PounXTO38S39MCk5sBSbBScRO4oFLbl+eAn7EKu4aYdYj9QsT
PdoBHHSTWOnsA1/z5O3zLwIYr25DqwftMx9L6KknT7Gkz70jRmHuQjXjbFnumiRH
6k1zWP0e1ZYsfnFZazBYqG6DYRmITuN/yBrnDD18lxRXOOVg2wNc7crb6r9MQwHp
deQJqfLHREhNYQqDnqwd
=3nhY
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
