Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab2EHFIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 01:08:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60449 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab2EHFIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 01:08:51 -0400
Date: Tue, 8 May 2012 15:08:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build warning after merge of the drm tree
Message-Id: <20120508150839.66910d2ad92ec8889cc82a49@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_May_2012_15_08_39_+1000_DhNXapQ8BaUoG5PN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_May_2012_15_08_39_+1000_DhNXapQ8BaUoG5PN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/gpu/drm/gma500/opregion.c: In function 'asle_set_backlight':
drivers/gpu/drm/gma500/opregion.c:154:6: warning: unused variable 'max' [-W=
unused-variable]

Introduced by commit d839ede47a56 ("gma500: opregion and ACPI").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_May_2012_15_08_39_+1000_DhNXapQ8BaUoG5PN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPqKpXAAoJEECxmPOUX5FEwUcP+gNSCVbq3zwBWfWZMSt+4Qvw
kQCA7f3flOsz5wzazlhk4xNX+bJ+5VyyQovO2BtWR0E9uXidIsQ4EmSsSAcvqbOs
0hjYIkvW//DvOHCCRRsGp5auuK5DQFOCB+SkLoStNP2Ypk5Eqdppg1gXkbKk4UNH
5ExYwFQ0sbGn03FNO8a/bBCre+TELgxVXKShEc0TYja2SPgNJcXqStXGBh/7AkQr
zYm/0rY4o4d0qrvhIyOi91oVyP+e6uyvLMKP867wfV1nxvqp/12Xt0rufJgdgPVv
icj3XKVuNsb0y1wiiwJ8HXXdPibit9eLgvcLiheovTopvO771xJHrZi/iK8IqEKg
OmdimM7HBPwScxQ5vQYSA4FK1ui2viXxuaQI8Zb/lVS5LCcL1iaaBAAcMQ7rQ01D
kloTOzvrbgVd7fRfzqV+H2Ncu7Ta84riaofghyAW2XCHSd91r6um2+7gic8NTREh
uk2BUoHd3tPjJ0atWb9Vb57dgRr5ovxY5bX0RAmfari2EiWp/3pOER55jFrnJWTY
FRgQVeOcacKD/79akKukBzF8lA4T4H/E4Y+yqjp16CkcMiX2xhU6XmC/kB4X/jUv
XpCmBlgX+kKZSg6zR0XcHLDSNfffHXdoczT+5oaXwt4TQ+/lijDt3LDcCnQ2W8CV
CzK3V/g2H5zVkYFWYJzD
=wRYR
-----END PGP SIGNATURE-----

--Signature=_Tue__8_May_2012_15_08_39_+1000_DhNXapQ8BaUoG5PN--
