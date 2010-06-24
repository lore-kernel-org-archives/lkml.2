Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0FXDDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:03:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50457 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab0FXDDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:03:50 -0400
Date: Thu, 24 Jun 2010 13:03:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>
Subject: linux-next: build failure after merge of the sound tree
Message-Id: <20100624130341.0ccf9102.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Jun_2010_13_03_41_+1000_bWHMXGc_.j4QfxU="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Jun_2010_13_03_41_+1000_bWHMXGc_.j4QfxU=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

After merging the sound tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/usb/mixer.c: In function 'get_ctl_value_v1':
sound/usb/mixer.c:308: error: 'struct usb_mixer_interface' has no member na=
med 'ctrlif'

Caused by commit 3d8d4dcfd423b01ef7ea7c3c97720764b7adb6df ("ALSA:
usb-audio: simplify control interface access").  Grep is your friend ...

I have used the sound tree from next-20100623 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Jun_2010_13_03_41_+1000_bWHMXGc_.j4QfxU=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwiyw0ACgkQjjKRsyhoI8xDyACfaP/+jM6uNmUcXpyoyGddoHav
OZMAn0vIjIBnV5lH2qTzw2n06eW18Nbe
=qKdH
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Jun_2010_13_03_41_+1000_bWHMXGc_.j4QfxU=--
