Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab1LOGiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:38:07 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:57771 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1LOGiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:38:04 -0500
Date: Thu, 15 Dec 2011 17:37:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20111215173754.87103f66f6188693933cb539@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Dec_2011_17_37_54_+1100_ZPOiJvA/ckhFVgNf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Dec_2011_17_37_54_+1100_ZPOiJvA/ckhFVgNf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/xen/xen-selfballoon.c:305:36: error: expected ')' before '(' token
drivers/xen/xen-selfballoon.c:327:42: error: expected ')' before '(' token
drivers/xen/xen-selfballoon.c:349:48: error: expected ')' before '(' token

etc ...

[Along with many warnings like:

drivers/xen/xen-selfballoon.c:284:8: warning: 'struct device_attribute' dec=
lared inside parameter list [enabled by default]
]

Presumably caused by commit drivers/xen/xen-selfballoon.c ("xen-balloon:
convert sysdev_class to a regular subsystem").

I have used the driver-core tree from next-20111213 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Dec_2011_17_37_54_+1100_ZPOiJvA/ckhFVgNf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6ZXCAAoJEECxmPOUX5FEkpwQAKZAIVt8txATWl3jM+spIEFo
jJfVbDjhG53tFVzzuJn+QoPr2P5tz1YnzAJCt1GWeSUcO00XcShFV/cXfuiRkv+i
h37+KfCEOyp30jPUZRDARCVdjyJPFwvzZ4NlU8zASncxPNPJpCGgypwYhsjK+COe
U2PU/pGx46i10AFfvYLPobOM8HoMKJQHMCgXW6vDDTBe+n+S0pd8EeKvmTd8ByIS
bQbyTiDGgRUeSBTubFjl2MKcYT/oAcD5MJUuQ5VtXoSQ4waBe367Qjs/aVgp5yWJ
jUXg9Kq84s7hZqdBbuyvwXdLqd6E38BfgCXrCdGgmZdEJVZIris1SaA3Yy0vQjmx
uffCx7xN4w6GcEyoBPSTWW36XUp2piUPWrCy5w07BJjHCy8nsbwjULcO3I6XuWLa
QQocxDaThTNgXNLaDEgP6DB+ZsX9t33M4rb2uSRgpvlOBJj/T9saLGjMcGUyyIcd
FST1K6VspKQdSqP5H/mzFdhAVUc4/sqNEEqi0JzjpnMcY4ASlmdidnWLio6/hH1Z
Dkxz6S8BFZzuH3Jjk9Gcwq566IDC7Huo8mdAeiSDdSyaQOituYZcIhZ0tXHJgQtF
x+RbkSlZLv/uSw4kibJ+IJlJEE/1WpJmBgwnVwpLcVww9UzHPwJ+i/hcKLcD5Xen
nU6An+E22ILHG6gktAKf
=fAi/
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Dec_2011_17_37_54_+1100_ZPOiJvA/ckhFVgNf--
