Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab0IFREc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 13:04:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56577 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab0IFREZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 13:04:25 -0400
Date: Mon, 6 Sep 2010 19:04:21 +0200
From: Frank Becker <fb@alien8.de>
To: Jens Taprogge <jens.taprogge@taprogge.org>, Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@vger.kernel.org, bp@alien8.de
Subject: commit 7b2bfdb broke sound card detection on my Lenovo T400s
Message-ID: <20100906170421.GA2957@alien8.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
Organisation: private
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Please always CC me since I'm not subscribed to the mailing lists.

I have a problem since commit id 7b2bfdb (about 2.6.35-rc2) up to the
latest HEAD on my Lenovo T400s laptop. Just found out while testing Ubuntu
10.10.

Problem is: Headphones don't work any more, internal Microphone doesn't
work any more. However, if I load snd-hda-intel with the option
model=3Dideapad the mic and the headphones work perfectly well again. For n=
ow
that is an acceptable work around. However, before the aforementioned
commit I didn't have to provide any module parameters.

Before rev 7b2bfdb I had:
=E2=94=94[a8@t4]-~=E2=86=92find /proc/asound/card* -type f | grep codec | x=
args grep \
    "^Codec\|^Vendor Id\|^Subsystem Id\|^Revision Id"
Codec: Conexant ID 5069
Vendor Id: 0x14f15069
Subsystem Id: 0x17aa2132
Revision Id: 0x100300

Starting with rev 7b2bfdb I get:
=E2=94=94[a8@t4]-~=E2=86=92find /proc/asound/card* -type f | grep codec | x=
args grep \
    "^Codec\|^Vendor Id\|^Subsystem Id\|^Revision Id"
Codec: Conexant CX20585
Vendor Id: 0x14f15069
Subsystem Id: 0x17aa2132
Revision Id: 0x100300

BTW, all the bisecting is done out of the linus.git tree.

Thank you for looking into that. I'm happy to provide more information or t=
est
patches.

Thanks,

    Frank


--=20
Frank Becker <fb@alien8.de> (jabber|mail) | http://twitter.com/41i3n8
GnuPG: 0xADC29ECD | F01B 5E9C 1D09 981B 5B40 50D3 C80F 7459 ADC2 9ECD
SILC-Net: a8 | Home: http://www.alien8.de | <<</>> http://www.c3d2.de
"> Freedom is just chaos, with better lighting. <"  Alan Dean  Foster

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyFHxEACgkQyA90Wa3Cns0h7ACggYWl5IadRhl+zAoA1EaxEn+u
RSAAniMc5MRCb9TXc1YrT084Hwm0Gepr
=HwLg
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
