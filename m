Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab1BALxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 06:53:19 -0500
Received: from smtp208.alice.it ([82.57.200.104]:44413 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab1BALxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 06:53:17 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Feb 2011 06:53:16 EST
Date: Tue, 1 Feb 2011 12:47:30 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Alan Ott <alan@signal11.us>
Cc: Jiri Kosina <jkosina@suse.cz>, Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Poole <mdpoole@troilus.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Bastien Nocera <hadess@hadess.net>
Subject: Re: [PATCH v5 0/4] Adding HID Feature Report Support to hidraw
Message-Id: <20110201124730.ac1faf74.ospite@studenti.unina.it>
In-Reply-To: <1295337880-12452-1-git-send-email-alan@signal11.us>
References: <1295337880-12452-1-git-send-email-alan@signal11.us>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Feb_2011_12_47_30_+0100_SyiR/gWZILtkceNC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Feb_2011_12_47_30_+0100_SyiR/gWZILtkceNC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Jan 2011 03:04:36 -0500
Alan Ott <alan@signal11.us> wrote:

> This patch adds Feature Report support for USB and Bluetooth HID devices
> through hidraw.
>=20
> The first two patches prepare the bluetooth side for the change.
> 	a. Make sure the hidp_session() thread is started before
> 	   device's probe() functions are called.
> 	b. Wait for ACK/NAK on sent reports, and return proper
> 	   error codes.
> The third patch is the hidraw core and USB changes.

In particular, this third patch is a prerequisite for the bluez
sixaxis-cable plugin, originally written by Bastien Nocera (added to
CC) which I plan to submit when these changes are merged in mainline
linux.

[...]

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Tue__1_Feb_2011_12_47_30_+0100_SyiR/gWZILtkceNC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1H8tIACgkQ5xr2akVTsAHjwACeOTUYIzHZTiJUum+6V7FtMEvN
C+sAnjeBZ1nBbI+A7/ZZo6fGluN39I68
=aGvS
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Feb_2011_12_47_30_+0100_SyiR/gWZILtkceNC--
