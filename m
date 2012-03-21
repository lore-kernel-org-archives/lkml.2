Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab2CUFce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 01:32:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33659 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab2CUFcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 01:32:33 -0400
Date: Wed, 21 Mar 2012 16:31:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Robert Richter <robert.richter@amd.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lin Ming <ming.m.lin@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: linux-next: manual merge of the oprofile tree with the tip tree
Message-Id: <20120321163151.83cad17d5524424938f7576c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Mar_2012_16_31_51_+1100_m+REZc=KQ6MDBYux"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Mar_2012_16_31_51_+1100_m+REZc=KQ6MDBYux
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Robert,

Today's linux-next merge of the oprofile tree got a conflict in
tools/perf/util/parse-events.c between commit 89812fc81f8d ("perf tools:
Add parser generator for events parsing") from the tip tree and commit
1e48600d2388 ("perf tool: Parse general/raw events from sysfs") from the
oprofile tree.

I have no idea how to fix this up, so I effectively dropped this patch
from the oprofile tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__21_Mar_2012_16_31_51_+1100_m+REZc=KQ6MDBYux
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPaWfHAAoJEECxmPOUX5FE9uIP/0nFM4HQFgm/Y01A+YXRUDGQ
+mBvWUXAXF52Oru+ao2kLX8DROTLhrS0WkcyXA21eag+Ez1drghZ7c+juyRuqtCR
CCq0fLWeNDKDOOqc7SkCuq+ThWoL89RpwBu8ZrcNJD0itLFn6Wi27DBwaaFh99dY
D3pxWIIBPlpiAVJP6RJIRp2GxGB1Nw0Pp2GbHm5+0a9GB9yl9S/qNaJA75lDqwYE
OJ8K8x5LE0zE15ljylLwj8A+x550yoaVnLRCN+C9vJHazLoLfx0CiseksaPBQYwB
a0GOwAUJBGhNwXMSUo1MhxnuUh647uKjLcAfIy5Vn05VQzegQPIqe5A9J3ZRIgAh
VCAGHQ0aehwPDSsbRgyKSHyB/alORSe9hbiOjAZZxJJ671GcP8dWhOYzYjMU4XeF
CV7W4H0DrdonnHgmtoazDbF5+KfxpKXeu6S316Puk3oOMr3qw++onMfp1XmQp3vk
VTt3Z6YHpX9Yxz+HSVWNgTpJZ4JK0wJWo1FuaOGJUB0LSDoPmiUUppZOv1v7iPUX
WKuwnXkysQlfMw8O9evpIPWrI6yJkvrXj029kIpIG7CU1Eb1zM6jH5HDLS2erEX9
2t1e/EF6f1axBNtCJwxqq+ncMPMpKcaDAWCQoLmK1eJDD85m1n7092boKN64viWy
8joJmZB9VmE4U4zubjhT
=xNex
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Mar_2012_16_31_51_+1100_m+REZc=KQ6MDBYux--
