Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0L0Xkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 18:40:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38985 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab0L0Xka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 18:40:30 -0500
Date: Tue, 28 Dec 2010 10:40:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20101228104024.fb0e9e34.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Dec_2010_10_40_24_+1100_rwTzY_/5iQbLn0IR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Dec_2010_10_40_24_+1100_rwTzY_/5iQbLn0IR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "__tracepoint_snd_soc_jack_irq" [sound/soc/codecs/snd-soc-wm8962.ko]=
 undefined!

In sound/soc/codecs/wm8962.c, the tracepoint is protected by
CONFIG_SOUND_SOC_WM8962_MODULE, it should be CONFIG_SND_SOC_WM8962_MODULE.

I have used the sound-asoc tree from next-20101221 again for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Dec_2010_10_40_24_+1100_rwTzY_/5iQbLn0IR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNGSPoAAoJEDMEi1NhKgbsgQwH/0hrYZhm6kIb+NUO4/fVDZ0F
v1oqnwOC6RoLIoricDTrkyFJHCLS3HbyqME+H0tBSVaZRLlQkXdGa/ba/hUPa2wv
xh6yKKhIUOqiCbdd77aowrMD3BO2BZaBtLfDLMf10gZRvqprgQuBCFJw5eCx7KTX
hmW8/l8khYSkbziom+bXYJy+2iRkgN9Q1StlNKCSRn5zymoI/HvrdQ2BOVcaoNbo
7DJVyqL5gHq7oxC7LGokYVWc7FWKgb0WKF/0tcNl8Xry+wQKVFfcasRtKYSIwBEX
4npvUZ3dsgW2cLo6db8qkIDuMBP4/ucqO8fgsj67aSdTc9LqIa8nzcQfn2KYAFA=
=TdLr
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Dec_2010_10_40_24_+1100_rwTzY_/5iQbLn0IR--
