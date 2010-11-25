Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab0KYV67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 16:58:59 -0500
Received: from wrar.name ([109.74.195.39]:55461 "EHLO haley.wrar.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab0KYV66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 16:58:58 -0500
X-Greylist: delayed 2443 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Nov 2010 16:58:58 EST
Date: Fri, 26 Nov 2010 02:18:03 +0500
From: Andrey Rahmatullin <wrar@wrar.name>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [BISECTED] 2.6.36 regression for ALC892
Message-ID: <20101125211803.GA4236@belkar.wrar.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
X-Operating-System: Debian Sid
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello. I have an Intel H55 motherboard (ASUS P7H55-M PRO) with ALC892
sound codec and a 3.5" front panel which doesn't support newer HDA pinout.
So the panel is connected in "AC97" mode and this mode is set in the BIOS
setup. In 2.6.35 and earlier the panel's headphones jack was working. Now
it isn't. I've bisected this down to
ce503f38bdb59c9175a9076215a3ba579fad4e64 (which is present in 2.6.36),
reverting it helps. I've got "Too many connections" messages without this
commit, indeed, but I had no problems (though I use only a pair of
speakers connected to the rear panel and headphones in the front panel).

--=20
WBR, wRAR

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBCAAGBQJM7tKDAAoJEOih81koZvPBMOMH/1gyvCfqG4XOv6OR0DXtTSaS
UA5q87SKRKYrWaPNB8VtutQ6feAwO//tBxHos0grtuD1OTKcDyktMZcmSWdeT17h
TE33Nom/ynQeZ1OLMiJKV9j0/3MGsH6wDnTClVqUHL5hVaIjDSMCFHGWDxBW0voE
Kylpa1PBouykl8x03fPCZ8+uX748L/+ZkmNYpW2Yx1h4YExmaIsSPKs3jkq+l8+X
suMmS6GZnKRMOT03Qe3eA03WHNPO89CJMvdl1YZctvDxPPW3gBF3vK0eSKhnO1i3
y9/Zb+4C0aYpxvkj5glguLWYlcAPYxfDXpt5Z+VzTgyiy/UGUlO8SDLF5mo/REU=
=+vo2
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
