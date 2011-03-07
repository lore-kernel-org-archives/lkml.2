Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1CGB5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 20:57:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53645 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543Ab1CGB5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 20:57:11 -0500
Date: Mon, 7 Mar 2011 12:56:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20110307125659.0da117ba.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Mar_2011_12_56_59_+1100_jRkAfmzRO_B4uyW6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Mar_2011_12_56_59_+1100_jRkAfmzRO_B4uyW6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build
(x86_64_allmodconfig) failed like this:

sound/soc/codecs/tlv320aic32x4.c: In function 'aic32x4_set_bias_level':
sound/soc/codecs/tlv320aic32x4.c:605: error: 'struct snd_soc_codec' has no =
member named 'bias_level'

Caused by commit 1d471cd1261a44a3b28350bef7e5113a4609c106 ("ASoC: Add TI
tlv320aic32x4 codec support").

I have used the sound-asoc tree fomr next-20110304 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Mar_2011_12_56_59_+1100_jRkAfmzRO_B4uyW6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNdDtrAAoJEDMEi1NhKgbsz4oH/joamHWuN+nu/voqYd1drqI/
0xZUsFkn+2tGMbd4rXw7vYilkzudEqb08pLgAv2El3CFjAnX1GnYIfCC7ddnW2ye
s3Re2zIoMnUFzLTmRwfLUNEL4yTps2WO6B5AUEvvqVTDwjfl7K20tijTUrZuD1rD
86JREAV/JeYs5riiiKHQqUKPNSr1MIpTafPtzVlHiSmNU3Mfbkdm4xEI6HwpBfqI
CVkQ5clAiEYvopCCuefwjhcWJWdAVSmGcPPU/dey8LQzDfZlvicMvfbmMbGjrtWz
f8AIOFeES2t1X7hq91d0ESa01ALUXz8L7jFfOtHNqhCJFLMT15X4VIW1LgviKi8=
=DLu3
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Mar_2011_12_56_59_+1100_jRkAfmzRO_B4uyW6--
