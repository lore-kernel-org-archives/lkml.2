Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab2ITQdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 12:33:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34576 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2ITQdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 12:33:50 -0400
Message-ID: <505B455D.2040603@gmail.com>
Date: Thu, 20 Sep 2012 18:33:33 +0200
From: Andrzej Giniewicz <gginiu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Sound got mute in kernel 3.5.4 (Fast Track Pro USB Sound Card), found
 commit that causes it - how to proceed?
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6828E5B967850DFFD3A67D5C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6828E5B967850DFFD3A67D5C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

today I updated kernel to 3.5.4 and noticed, that all my sound from Fast
Track Pro USB Sound Card got mute. I haven't noticed any error reports
or messages, all seems to work, the card is just silent. I downgraded to
3.5.3 and applied patched from usb sound module one by one and found
out, that 3.5.4 minus " ALSA: snd-usb: fix calls to next_packet_size "
works fine:

http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dc=
ommitdiff;h=3Dca150f7ade5973c3bce19261bca6174d5c3cc342

Does this change require some update of configuration I missed?

There are some informations about device from lsusb:
http://pastie.org/private/odiuw0ve3iszdat9mwpa
My system runs 64 bit Arch Linux, there is config used by it:
https://projects.archlinux.org/svntogit/packages.git/plain/trunk/config.x=
86_64?h=3Dpackages/linux&id=3D59ae346478ff01f0d2dc47b04a3a1297046b1900

How can I proceed with this issue? Any more information I can provide to
help in solving this?

Thank you,
Andrzej Giniewicz.


--------------enig6828E5B967850DFFD3A67D5C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQEcBAEBAgAGBQJQW0VpAAoJEED1V7cxSWEG0BoIAL3Mq5GMVwsEi7YwiEG7YkKo
on+LU4FnMNtQyD4Qzve3goI2TanPpfgWwS1w2zx8v2pSzxtJtUjJ4BxJz6UkFNCc
drYY+h03AIk73J/okQhkYNFDMruc/Gr1zcI/okLX8O/vfEZK4nYEI9epsCwc0DXe
VyV67kOobVCx4e1ZxwY7XX7dt4TLHM1+nwZAZF899x0BK4xY8XyL8fEhi/cA5rly
SpkvX6pbP2N5DcDixf0pvVPMBi8QqHgbMlLhbQZc6HFD4hmt5G0VnP7TexN6vLNJ
gJTHNcEFUCgRuC6aiXEpko7KiJgVAoqL7mgcRvu84ek2WBorTmBVsY8Nx2D8leQ=
=p5HG
-----END PGP SIGNATURE-----

--------------enig6828E5B967850DFFD3A67D5C--
