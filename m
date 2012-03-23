Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2CWDct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 23:32:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52042 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2CWDcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 23:32:46 -0400
Date: Fri, 23 Mar 2012 14:32:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: linux-next: manual merge of the mfd tree with Linus' tree
Message-Id: <20120323143237.9b5917955cb42951f0368ec4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__23_Mar_2012_14_32_37_+1100_4FRUJ3ty06d2KS3a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Mar_2012_14_32_37_+1100_4FRUJ3ty06d2KS3a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/mfd/twl-core.c between commits 5769089ac725 ("mfd: twl-core.c:
Fix the number of interrupts managed by twl4030"), 75294957be1d
("irq_domain: Remove 'new' irq_domain in favour of the ppc one") and
964dba283439 ("devicetree: Add empty of_platform_populate() for !
CONFIG_OF_ADDRESS (sparc)") from Linus' tree and commits 9e1786202704
("mfd: Make twl-core not depend on pdata->irq_base/end") and 78518ffa08fc
("mfd: Move twl-core IRQ allocation into twl[4030|6030]-irq files") from
the mfd tree.

I *think* that the right thing to do is to use the version from the mfd
tree ...

I do wonder why I only got this now (in the merge window) ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__23_Mar_2012_14_32_37_+1100_4FRUJ3ty06d2KS3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPa+7VAAoJEECxmPOUX5FEf5wP/1Us67YqHVnSO0uwjvgPTqw2
7uwRxruqzAFT0fgZo0CHfvgI1e0zOy2M57FVZxmWi78rfJyO3eNWJZ6YsGZQQsbY
Q8TFmy/IQHBV+k7afcO7pRpnbG8uqFck30CmSovd++JL0r616HgVMduPXfrR8Arn
Q6JVuIj/AnYlitF5OKvkW570pxO1wWOC0ZfbpjiYem1Ix6nFyIRCBtoEIHaUbGX5
IRCxLKv5D9SUvabLpYisM5Wdk2BkYmwUNl/ekzFtRub7FL86CGs0amPAfXmwbEvW
yj0tNQXYbfSMP6dtSZbgPjNFori7EamplckyToXGPY1vIMBc/NAtw0BxVOia+XgM
CTs3fkBu1W+QyMlYRk+lw8rF/3iNOc2UmsYdO+qHgX9VjSVd6oC/HRrLaymKW2gI
YmxO6RItrHKQy0QzUPD+yXXU/V9UtCSrOw/0jfXRJg492s+oiIsxY+/BGnpjgiTO
LhqJZ21u9EUwSEBUeJvMxwewkzh/9oGcPzE8BJZ1zfbcnTU9XktKxZKEHX0+57Kg
iY+4RUoUsvbTuHVlNevOu3lmIrFvTopbyg/KaenjwvkFI/34kwdLHWYJ7z6929x+
640yulMLMTGaUMvKfRSnWx7xXBpl8MD+tj6tNBwub4GljNwSdZMGuRs+BQPQIJ5A
jUmZlhE0HnQfXa/dNDX8
=xCvn
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Mar_2012_14_32_37_+1100_4FRUJ3ty06d2KS3a--
