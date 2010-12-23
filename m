Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0LWBC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 20:02:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48635 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab0LWBC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 20:02:56 -0500
Date: Thu, 23 Dec 2010 12:02:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20101223120243.1617cd40.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Dec_2010_12_02_43_+1100_YhqdFPTeCL+xw.yk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Dec_2010_12_02_43_+1100_YhqdFPTeCL+xw.yk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "__tracepoint_snd_soc_jack_irq" [sound/soc/codecs/snd-soc-wm8962.ko]=
 undefined!
ERROR: "__tracepoint_snd_soc_jack_irq" [sound/soc/codecs/snd-soc-wm8903.ko]=
 undefined!

Caused by commit 1c9e9795b5e2348df619fd6010d7583dc9b8c811 ("ASoC: Add
jack IRQ trace to 88pm860x driver").

I have used the sound-asoc tree from next-20101221 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Dec_2010_12_02_43_+1100_YhqdFPTeCL+xw.yk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNEp+zAAoJEDMEi1NhKgbs2yAIAIqvWjt1j2Q1/UV/LRXv+dc5
8Y8S0/hQhxKBJhzZBcZnJBpF6on0rPEbQqPpFB1bw5vFTQuzCeQtcQ2A1X2y1fuy
kHUV/HkBRwd5P+CS06egtrJ/WuE/WYQYd4GdVpKUkErlUt4GvYQQ/jIsjOPCTwYf
C1eZhGUIOXy2kYySrlado8wSATr8Dfh6tBhzpkusbbLQszCjeIQAaKJV0xwoU4eI
jh5ghp36uNr4OyLxM+E4AhNGSBkcdhu3RqgHuF1qXryJfhOkaOxhtgdA0TuJ0F4v
GhkS3J9ySKF2Vwd/MkuqnBAi6+lw1wVv/YdPbkj6pFxovDFmpVR2ro0MPyvwLyM=
=orr5
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Dec_2010_12_02_43_+1100_YhqdFPTeCL+xw.yk--
