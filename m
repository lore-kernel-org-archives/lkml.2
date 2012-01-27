Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2A0C7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 21:59:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56055 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab2A0C73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:59:29 -0500
Date: Fri, 27 Jan 2012 13:59:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Michael Buesch <m@bues.ch>, Joerg Roedel <joerg.roedel@amd.com>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20120127135912.e5f45bf1c4a99b114c18bf72@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Jan_2012_13_59_12_+1100_yyPkG7dRZ2PC++TB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Jan_2012_13_59_12_+1100_yyPkG7dRZ2PC++TB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/pci/xen-pcifront.c: In function 'pcifront_common_process':
drivers/pci/xen-pcifront.c:596:6: error: used struct type value where scala=
r is required

Caused by commit f3ff9247088a ("Remove useless get_driver()/put_driver()
calls").

Please build test this stuff ...

I have used the driver-core tree from next-20120125 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Jan_2012_13_59_12_+1100_yyPkG7dRZ2PC++TB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPIhMAAAoJEECxmPOUX5FEyY0P/0KeXr87U1FOJhjER2/Q2NP/
i2xWaDZKDNBAjVjC/zNN2iq3YomUaDvXEzuwY9BaBDxa6G9y0U6Uk6svwWdONqey
iWHAMtI8L4F4fYFaraeLNiDEvB6bv8HdO+jPWBtTcrJowTzqmUWjpTrfnCPmQuau
0vh/2krJQg82pthGeENeKVQEbZyMgbWh7V3u5OlhmQRBTsbLDuHpHfrMyptQq9un
D2DV/Adx28Z41gQ31Hp5gE5mEuCYESDo8NAEwYjKXxnoAqSSnbMw4bdw3Nkbqo4h
5IR6B+wlnKreEXC3c0wvAM6JlPmMzt3lK7sWs64emV8wLQvRaezScDzjtNc6NQTN
znhioD/PyL6cFbXnYxQNNsnXA7zNX14ATuZFRbUvABzek0ZKPLtcjXNgqXzoo15S
LKMG0prZ1uMQiIH9JYbNhpoj63pOakLJsD7cA7Tr2HjWwe7A2nZOyk4pIvDSzD4a
dTv6Pk6Q5ILyQjxqII8Hsy7YwDK04mRNmx2HiR7yVU8sQZwfBDzdtLufkBzPdNXl
rCIJgvJLrWIgCc1khTnZqHKljvA7MosPnjgaq/hV93nQe0Z83QmdR/ocbIG2fjqU
L5/aPX6K8MIlGwNsxxGWnsm9slZS2cVMZJdAvGqLUExx+CFWk0UJXC3ALuIaf/0I
7j7ZHHP6Kn9ky00GfP+j
=hjVn
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Jan_2012_13_59_12_+1100_yyPkG7dRZ2PC++TB--
