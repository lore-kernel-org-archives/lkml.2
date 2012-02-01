Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab2BAFBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 00:01:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48569 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab2BAFBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 00:01:10 -0500
Date: Wed, 1 Feb 2012 16:00:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?B?IlNqdXIgQnLDpm5k?= =?UTF-8?B?ZWxhbmQi?= 
	<sjur.brandeland@stericsson.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the modem-shm tree
Message-Id: <20120201160057.7be520d38bf5d0dd6d29024d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__1_Feb_2012_16_00_57_+1100_P553fb2kmhI.npPi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Feb_2012_16_00_57_+1100_P553fb2kmhI.npPi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the modem-shm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

scripts/Makefile.headersinst:18: include/linux/shm/Kbuild: No such file or =
directory

Caused by commit fdefb6d63aa1 ("modem_shm: Channel config definitions for
ST-E M7400 driver").

I have used the xshm tree from next-20120131 instead for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__1_Feb_2012_16_00_57_+1100_P553fb2kmhI.npPi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPKMcJAAoJEECxmPOUX5FEwucQAKdDkC1xod360aQLPnnuioJ5
fG6Aryld4W8IThwoHeiPflaUXE9uwp3luQo3xMuZ7F2zJSUWc7SwdmbWbRweKVzb
iVL8Cy/gt0N/V7QD9XhsbldBqO9oZPa1XaaXiyyyOLzqu5L973PJ5SGGT4WMARxo
5Oj6hyJor1xVmB8SwTxYFiVDn2RN/UrO8G4zIdF42ppxfX3cgxZM0sZ3EA0DJN33
qSC0InuFgUWhNhmYVrTO1jpFiTtH1PthUD9Be1dydFekApEbFTtmaTKa2ZiklO3O
gpZ1CAzlo2GWIQKVDBimy7r5in2+QZHMPPP4/8LPq5a5K3zGCt5lMaKXdbYYh7HU
ddJ5/XpHmm/Uysp6jiMlI/eiASArbMcQMHziXXOCe4sRVO5U54BqXT9g3PR0AbhX
x6+VWvX7vpIuiCzPzJuMjFTSFpa8drkdOS4QBokfhktWDnGSUoqekEDyFAG5yqTc
ypxSRd0slS4gZVcXsQlOUHisnkmkhByLUHYAuMBP+Nr7E6RxWhU5SlkHWgKP8LwK
d25h5COT8UH4kC3wLUoQnGTbs84833uCr2U4y2beFxN73vFt4mapFUjLpJARSLSs
OjA/o/Y1ybPdK9BBJcPOyGv+MwLfCukwlharQ2Rs37EV+pxcxRSyJ9mypnXgoPuH
5e7JcsqBppRKekMUE7h6
=ES08
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Feb_2012_16_00_57_+1100_P553fb2kmhI.npPi--
