Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab2JFQYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 12:24:20 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37265 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab2JFQYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 12:24:16 -0400
Message-ID: <50705B1D.503@gmail.com>
Date: Sat, 06 Oct 2012 18:23:57 +0200
From: Andrzej Giniewicz <gginiu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Sound got mute in kernel 3.5.4 (Fast Track Pro USB Sound Card),
 found commit that causes it - how to proceed?
References: <505B455D.2040603@gmail.com> <505D816B.4080902@gmail.com> <50605A88.8060503@gmail.com> <20120928130034.GF28937@mwanda>
In-Reply-To: <20120928130034.GF28937@mwanda>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4B120C23BF5E0D6B5244FF41"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4B120C23BF5E0D6B5244FF41
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 28.09.2012 15:00, Dan Carpenter wrote:
> I've filed a bugzilla entry for this.  Shouldn't be hard to fix now
> that you've bisected it, thanks for that.
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D48051

in 3.5.5 USB soundcards work again, thanks to commit "ALSA: snd-usb: fix
next_packet_size calls for pause case"

http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dc=
ommit;h=3D8dce30c89113e314d29d3b8f362aadff8087fccb

The bug can be closed now (also added comment on bugzilla that its fixed)=
=2E

Thanks,
Andrzej.



--------------enig4B120C23BF5E0D6B5244FF41
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQEcBAEBAgAGBQJQcFsqAAoJEED1V7cxSWEGlzQH/0T7UgTi3v9P6dRgY1XNJaI4
2Xr6xOqaCKQI4VEZPD446ZR7i21pPrpze6Kv/Lyen1Fj61ysD2jecGCluY0Z/X89
wGdCg9QoDN4bWReasZS3U1e9W8ND+ea1YHDeDYIWGnFLzLxM3pVPryHHhRaRoRfS
0kwSVtqPPtq3VDqCsnIKKY5YZ0gGzdjB827OUsiIxVeJyBAny5UpyYQIa5rOf2Ci
u+VFKM0RYr3wteEK/7LIiJpsd0ncnH6sYP5tbg8EPOWoByrj2y/7+ohOKKfpYtJe
02TKNPpRunZ2gOTu5J+hpvzSacZZofz7rnd69CTJw/JMmmoh6RyDfUYgY+vIrEg=
=9cXP
-----END PGP SIGNATURE-----

--------------enig4B120C23BF5E0D6B5244FF41--
