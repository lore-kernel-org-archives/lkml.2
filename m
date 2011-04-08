Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab1DHEie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 00:38:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46913 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab1DHEid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 00:38:33 -0400
Date: Fri, 8 Apr 2011 14:38:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the sound tree with Linus' tree
Message-Id: <20110408143825.e15b444a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Apr_2011_14_38_25_+1000_Umb89KeEKh84u0DW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Apr_2011_14_38_25_+1000_Umb89KeEKh84u0DW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next merge of the sound tree got a conflict in
sound/soc/codecs/wm8994.c between commit 25985edcedea ("Fix common
misspellings") from Linus' tree and commit f701a2e594e6 ("ASoC: Factor
WM8958 DSP2 handling into separate file") from the sound tree.

The latter moved the code changed by the former into another file.  I did
not bother fixing the spelling errors there.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Apr_2011_14_38_25_+1000_Umb89KeEKh84u0DW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNnpFBAAoJEDMEi1NhKgbsjg0H/iUcJXCS7iZyawhThNGdUo3G
lqO3oA8PuqhMvZDZ5bZvxeKpiF+YfokXRUy/WU95nZ85tBs+MTLXTYyoIWBln2E0
yiTMTaAA1gw5cmhP1P/2IdOlYVrqMutxa5zDCIvqH1jgRHWMvRz2Rd6x/Bgo5q/U
s29Dj+vzpN4Cj5XdTj6hWXiPqYcx+w50GuSwJQ5/V0C58JwwgtKbPA6Gqhfjzkkn
3BxhxrMUVeAbasGWjRsdPF5Nj1gDEURpiS5kLsb5Wb2XFWVdniUbR6nzmDuxG0+l
ig1CgGTYvp/d2NHPS5FJVQtcIk7ZERyRQapWdccg0YXWOKLzsX9rCMHaT5zHMYo=
=sHac
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Apr_2011_14_38_25_+1000_Umb89KeEKh84u0DW--
