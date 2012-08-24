Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2HXDtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 23:49:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48029 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2HXDt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 23:49:29 -0400
Date: Fri, 24 Aug 2012 13:49:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the drm tree
Message-Id: <20120824134918.8d57aa23aff53f3ee981e2df@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Aug_2012_13_49_18_+1000_G42uCVFAbSG31eIQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Aug_2012_13_49_18_+1000_G42uCVFAbSG31eIQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/gpu/drm/gma500/cdv_intel_display.c: In function 'cdv_intel_crtc_mod=
e_set':
drivers/gpu/drm/gma500/cdv_intel_display.c:1129:3: error: implicit declarat=
ion of function 'cdv_intel_dp_set_m_n' [-Werror=3Dimplicit-function-declara=
tion]

Introducd by commit 220801bdb53c ("gma500/cdv: add the bits that don't
need the new code") and exposed by commit f76c0dde78fb ("gma500/cdv: Fix
call to cdv_intel_dp_set_m_n").

I have used the drm tree form next-20120823 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__24_Aug_2012_13_49_18_+1000_G42uCVFAbSG31eIQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQNvm/AAoJEECxmPOUX5FEy1kQAIKbMNyYimNb2XKsbvbbLzyp
APUuylPHVFroop0sl0LHEbwb+JlJKcOE1zEs+tAfIcocooyJlo9hquiHuN/HcYJM
5185T3E+GJmTOAlPCx3M0R2Ruoy+VpSbS7+IfnV1o283UXLw6BmC21ACQJnYD3RB
Ndny5p18hPN0YMEfq/KUwxwN3xk9uNjgAdltE0hQfyj05+1jVBUSa3zc9OaNOHbY
vYE38aBz78+q0m/pvlldNhLqLickTifSR6yzGNdPWjV0GiE0QyZlrJmrZK5/rjMI
u1DVP69grVo2Ge7E+IFDLrAU7idezqwq7HY7jQGyQTps23+Hfn2cBj/mzMjKfyjQ
ipYz8Zk61E5DHTCblayji2DPmLtq6Fh+lmt1qc9boHWzrZ7NQBp9+UbKMZCIFoNY
O/9j7mEpppAMFmhSvgw+eVa42F8WYgjdzxHvdWs12z3lep1SNZ6s5suUBPLz2o9o
GjSHusIK910DNDDsrPkJxHJgt6NynersahcYLZLI3KvzUSXHyFrIlHal8BswNWxK
pw/Fe3WZ5xrNUR/5ws4bDu+lHyFboKNvlUSk+Flm3bExNlqrlUV8dPjFxHq1Ye/C
t1FmTK+xQGpEJOh3np+UbpzY7+famgf73/KsahKzsmrdzo/pRPm7TmiMFEGKto5V
dpVVRzsvCNmhaPr0X6bg
=xK/y
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Aug_2012_13_49_18_+1000_G42uCVFAbSG31eIQ--
