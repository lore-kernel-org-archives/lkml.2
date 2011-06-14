Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab1FNDnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 23:43:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37632 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab1FNDnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 23:43:18 -0400
Date: Tue, 14 Jun 2011 13:43:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20110614134307.6f5392db.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Jun_2011_13_43_07_+1000_oYlsO1pJ4LOW93Mv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Jun_2011_13_43_07_+1000_oYlsO1pJ4LOW93Mv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/soc-dapm.c: In function 'is_connected_output_ep':
sound/soc/soc-dapm.c:596:11: error: 'struct snd_soc_dapm_path' has no membe=
r named 'weak'
sound/soc/soc-dapm.c: In function 'is_connected_input_ep':
sound/soc/soc-dapm.c:649:11: error: 'struct snd_soc_dapm_path' has no membe=
r named 'weak'
sound/soc/soc-dapm.c: In function 'dapm_supply_check_power':
sound/soc/soc-dapm.c:733:11: error: 'struct snd_soc_dapm_path' has no membe=
r named 'weak'
sound/soc/soc-dapm.c: In function 'snd_soc_dapm_weak_route':
sound/soc/soc-dapm.c:1848:8: error: 'struct snd_soc_dapm_path' has no membe=
r named 'weak'

Caused by commit bf3a9e137cf1 ("ASoC: Add weak routes for sidetone style pa=
ths").

I have used the sound-asoc from next-20110610 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Jun_2011_13_43_07_+1000_oYlsO1pJ4LOW93Mv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN9tjLAAoJEDMEi1NhKgbsUJcH/2DOrE2IJlXWJ7FJm/EU+iqz
uXO64uOr0x1hx4ez2c2kfrJC6RPk3lS+2nS3utpOTWiHTMVyfns7MutHhw2DgVYq
vo6A3fLOqsMaF+5OqxEGGoWrUFTbL1z0F63jW4maI/d/deduo7DHdW5GnEt3fKzq
4WDb/1IZZKqD1AXvpT6bFp8yE2B2jq3aoOwib/FYMRX/gduGq1fBqqf9sY5ZQY7u
Nv+hFtjIGSZybEPzlX4N/FWDbsEiuoC9TAkDPuX/3M3B+5mu6aFqEjm696nQ1MB9
ef4Mva0HV1QRtBkgeGNcnIT/NxNNZ2DCaYUOhJXS8mdHYiUYq/rZMrZl33+p6Ok=
=qF6q
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Jun_2011_13_43_07_+1000_oYlsO1pJ4LOW93Mv--
