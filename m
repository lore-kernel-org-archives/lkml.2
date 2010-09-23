Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab0IWCow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 22:44:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35873 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab0IWCov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 22:44:51 -0400
Date: Thu, 23 Sep 2010 12:44:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: linux-next: build failure after merge of the sound tree
Message-Id: <20100923124445.a2b5de42.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Sep_2010_12_44_45_+1000__9ppaa8lFL5RsKFX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Sep_2010_12_44_45_+1000__9ppaa8lFL5RsKFX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

After merging the sound tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/soc-cache.c: In function 'snd_soc_8_16_write':
sound/soc/soc-cache.c:207: error: 'struct snd_soc_codec' has no member name=
d 'reg_cache_size'

Caused by commit 0077ca0b5c986477e33451b797b6e7dc92a8bbc0 ("ASoC: Fix
multi-componentism") which looks like it was fixing something that didn't
need fixing (or maybe fixed it incorrectly)?  This commit is not in the
sound-asoc tree (but the commit it purports to be fixing is in both the
sound and sound-asoc trees) ...

I have used the version of the sound tree from next-20100921 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Sep_2010_12_44_45_+1000__9ppaa8lFL5RsKFX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMmr8dAAoJEDMEi1NhKgbsaSMH/2Ph5eBpgq4W6VND1Nh2DH/5
LLToBx31rUPzfFzFaAKr6+kHUTxUlkRO7ttzd5UZBBsWflfnjbdgPzDJPXZkwINF
ogd2QClUDa4TlCM+QxuKjKda+Yhkz5pEnfp4DUZPoB7RtF0cu7OITRbEbZCRsHwh
cOA6dSMgd8v9F0ypjw1oM5ouChv3ddNW6RKDC9HJ0eiXrh0pPzdAzTnhhw3/Ad2c
u7rwZoq9Wt31OoMAceU81N5KRNUY+g2upB3jooPfE6FFW5TAWHRL65iJsMp/Intp
H4rDJOfFXcHOVCYz6JCvj6xfY7p5CMm2dmf2r24WSsHSuV2+omDShLIyFvFY430=
=f8Qs
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Sep_2010_12_44_45_+1000__9ppaa8lFL5RsKFX--
