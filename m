Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab2J3MLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:11:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57387 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932741Ab2J3ML0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:11:26 -0400
Date: Tue, 30 Oct 2012 12:11:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20121030121123.GN4511@opensource.wolfsonmicro.com>
References: <20121029114848.cf0297e997cbfc9c2198fa5d@canb.auug.org.au>
 <20121029181534.GH4511@opensource.wolfsonmicro.com>
 <20121030074631.9d148cb69a06a47d3dc78e65@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="20XocjIeMTCm4X0r"
Content-Disposition: inline
In-Reply-To: <20121030074631.9d148cb69a06a47d3dc78e65@canb.auug.org.au>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--20XocjIeMTCm4X0r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 30, 2012 at 07:46:31AM +1100, Stephen Rothwell wrote:

> Then you need to have a different branch being tested by Fenguang and
> friends to what you have in linux-next.   The stuff that you put into
> linux-next has to be at least build tested, so you should delay pushing
> it up to your linux-next included branch until after that is done.

Which is what I was doing, as I said I had thought I'd pushed up
something different to what was actually there.

> This case was particularly irritating because you were the developer of
> the patch that was broken which indicates that you are not even testing
> your own development work before pushing it out for others to work on top
> of.

I don't treat my own patches any differently to any other patches I push
out; in this case the issue was a mistaken fix for a merge issue cherry
picking the code out of a working branch into the public branch. =20

With a huge chunk of new device enablement like this it's just not
possible to do anything except build testing on the branches in -next,
there'll be at least some cross tree issues getting in the way of
actually running anything.  At that point all the issues with time spent
doing build tests apply; as I keep saying I will tend to do some if I
have time but it can fall by the wayside and they're not the tests
anyone else does.

--20XocjIeMTCm4X0r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQj8PYAAoJELSic+t+oim9h/oP+wTh/NVdBNYBSiT9/XiYUTyb
pnX2mbJ7nKGVj2dsrLmFI2UZ1V47ZDmW+lAg1RFggpij/Kg4NR3uhHk1Wc8mqcdZ
QlE4219BNKAOUVBRNqk0O+FGKAnJJ0DtA+G4yDT5SLd3Fciki5Ctj8eakPl/jmVA
+931vsQ4joTszrc7VDAAZNndE/ZQloyBZAJC38jaok6XMAZv3HUmy9FUV7+ba2ZJ
Y3djRj9ydpGzE0O/j/7D87BeM7NUfa4++waN/GlywqLKvBWpcLThDGW/uE8P2+Se
qTpg5VQNaphE8EWfGg+OotP80MXOcqU+FwflcbeyZVq4dL9Hv142daO4qiHR+zTw
oys/ocheXT2++N3jn8P8qnDjM2tWrk3TUWc3WQySVNM/MPgvNHh/3o7JkWT4MXfe
XnqSvv4wFRuTYteZA7mDG3LEdUfOpGqd3lpdVX0tXLAyJ5mpomfE+HmBAyEdr+Km
1MQCByZkI9nrC21r/BM9MBz9kwkyubKdU6tP8pffe88i4uZw3ChMQVtz2iBVDzxL
Cp35y9TFpDHorWsl7Udp2KCtYFCOP548TM3UofbZ7s25aww9Yf1F91zOC/m44xl+
kUhmnlFyCWmEFbDXFJO1BdVspRnTlwUQJMAbxhrEQn762LIhmzzoOpTQ+Hd0XBWR
qczrb+3z/TdB8upFIFNy
=lp3z
-----END PGP SIGNATURE-----

--20XocjIeMTCm4X0r--
