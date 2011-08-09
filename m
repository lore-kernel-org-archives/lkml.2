Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab1HIDVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 23:21:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58302 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab1HIDVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 23:21:19 -0400
Date: Tue, 9 Aug 2011 13:21:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the regmap tree
Message-Id: <20110809132111.af88776afc00f9e87e1bd6a1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Aug_2011_13_21_11_+1000_e7RRg5vocPJby6fB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Aug_2011_13_21_11_+1000_e7RRg5vocPJby6fB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

After merging the regmap tree, today's linux-next build (x86_64
allmodconfig) produced these warning:

drivers/base/regmap/regmap-debugfs.c: In function 'regmap_map_read_file':
drivers/base/regmap/regmap-debugfs.c:71:6: warning: field precision should =
have type 'int', but argument 4 has type 'size_t'
drivers/base/regmap/regmap-debugfs.c:78:7: warning: field precision should =
have type 'int', but argument 4 has type 'size_t'

Introduced by commit 31244e396fa9 ("regmap: Provide register map dump via
debugfs").

In file included from include/trace/ftrace.h:296:0,
                 from include/trace/define_trace.h:96,
                 from include/trace/events/regmap.h:112,
                 from drivers/base/regmap/regmap.c:19:
include/trace/events/regmap.h: In function 'ftrace_raw_output_regmap_block':
include/trace/events/regmap.h:58:1: warning: format '%d' expects type 'int'=
, but argument 5 has type 'size_t'

Introduced by commit fb2736bbaee0 ("regmap: Add basic tracepoints").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Aug_2011_13_21_11_+1000_e7RRg5vocPJby6fB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOQKenAAoJEDMEi1NhKgbsHiYH/2ePAwtdnjlaNnoTJB/MAcZK
BsyqhHB405PAPFR0aNqncirF+IwuNJz8z0uv63Lg47prksA2raoziZ3Aofh7YS9M
SyraaujC165ipRLy9YGkeEMHepB9afhkwnTfBINLPxDsHZGhtFT61f/yVthqe/qL
+fNxfzfdRyIdbfc1XcYymfxiM4Y3Fzgc7OGRlnqDcOIgYYBfX8c96OQ4SW0rZun0
auHDVDIOkTvFS7Qjuuu+2KDcigw5AzD291qa5JCI5/y/UlPJ61MtndGQOl5YECxb
Ioivw9vz4XUZCpW2Xg29c3aWB52BIiOw8boAINKQ1Eu6KtChjU1iq/zZYMm8+7g=
=DS4z
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Aug_2011_13_21_11_+1000_e7RRg5vocPJby6fB--
