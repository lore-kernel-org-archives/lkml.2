Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab2DTE31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 00:29:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53821 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2DTE3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 00:29:00 -0400
Date: Fri, 20 Apr 2012 14:28:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the sound-asoc tree
Message-Id: <20120420142850.b276b5fa80e857f8c997e99b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Apr_2012_14_28_50_+1000_oB_/Iw3GBj+hZo1J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Apr_2012_14_28_50_+1000_oB_/Iw3GBj+hZo1J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

In file included from include/trace/ftrace.h:567:0,
                 from include/trace/define_trace.h:86,
                 from include/trace/events/asoc.h:410,
                 from sound/soc/soc-core.c:45:
include/trace/events/asoc.h: In function 'ftrace_raw_event_snd_soc_dapm_out=
put_path':
include/trace/events/asoc.h:246:1: warning: cast from pointer to integer of=
 different size [-Wpointer-to-int-cast]
include/trace/events/asoc.h: In function 'ftrace_raw_event_snd_soc_dapm_inp=
ut_path':
include/trace/events/asoc.h:275:1: warning: cast from pointer to integer of=
 different size [-Wpointer-to-int-cast]

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__20_Apr_2012_14_28_50_+1000_oB_/Iw3GBj+hZo1J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPkOYCAAoJEECxmPOUX5FEqzUP/jBwXqkn75lhEAuTsxX2umvZ
0nayJhiMsbrC8S4Egj3ievRsdWs8Jy2Uv6xE+m7I1NkUE9QkaOs6pVKvg8w1O9Gq
ezpN45cizYktCLGk4FgSRjkql9eHnrrQl6+swMwsHONDYgR1+ca30yFwlVR2QXyF
TesYBLbuHeQddCj+YWzKXje4fDOugJvU9nmgd+OpBtcp8TVY2II2ER81wq3EXok3
wFvcAe4B/61HMwVErZOuY5rMU5f19YRzyfdc0UDIySycSvFGRqBv64aPBlUFEiv8
wF4Uf9sji9vfMQCrNiCEEnsP/v87eA9LDfvh7rXG6b4RhTkq+bTir5y91vC8KDz6
NxDQ5XM2aKOlLfFIxGMmr/ugDj10WKQV0y/4JNgPAlcTiNw7JggzD9eV6hX5jW+S
8hiOUcN5TBxMPZv7LHQ6WCbKKvBK/4jObCtSRDcqV1B/9R/GwZkagduXhTJ3rwZq
sdm9WKxdHLvKUalZRTNG4XTL3SYE234tEbgLAUhZgYnCxKVNCkEsMMzXk0G90Aar
WffqYI3Xj10210x31KF2860hxTx/XPmUvsHssZT+7CjszNjzZtR2MUkQKUohdvQ3
1pFGEIpSRR7ZufhzuPgLxafoqHFF+xFSftj6ZpyUDNYm52qhORgp8Xb0d48dOtU9
PS924fXqsJx22vQ6pomm
=BPtV
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Apr_2012_14_28_50_+1000_oB_/Iw3GBj+hZo1J--
