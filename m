Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab2KEXbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:31:06 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42252 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877Ab2KEXFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:20 -0500
Date: Tue, 6 Nov 2012 10:05:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: build warning after merge of the pci-current tree
Message-Id: <20121106100508.e97458c690d9806f00ceb551@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Nov_2012_10_05_08_+1100_fmoIBVR9sF=vyFxy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Nov_2012_10_05_08_+1100_fmoIBVR9sF=vyFxy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

After merging the pci-current tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/acpi/pci_bind.c: In function 'acpi_pci_unbind':
drivers/acpi/pci_bind.c:48:2: warning: passing argument 1 of 'acpi_power_re=
source_unregister_device' from incompatible pointer type [enabled by defaul=
t]
include/acpi/acpi_bus.h:346:6: note: expected 'struct device *' but argumen=
t is of type 'struct pci_dev *'
drivers/acpi/pci_bind.c: In function 'acpi_pci_bind':
drivers/acpi/pci_bind.c:75:2: warning: passing argument 1 of 'acpi_power_re=
source_register_device' from incompatible pointer type [enabled by default]
include/acpi/acpi_bus.h:345:5: note: expected 'struct device *' but argumen=
t is of type 'struct pci_dev *'

Introduced by commit 942dd0958697 ("ACPI/PCI: Notify PCI devices when
their power resource is turned on").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__6_Nov_2012_10_05_08_+1100_fmoIBVR9sF=vyFxy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQmEYkAAoJEECxmPOUX5FE99QQAJ04nN2VVpU9pMD8Bxm34M74
amz5O8wiKJWv3HUntaWwaI89OTHVIF8JPlGj7QMuiaClZ/6cwdxuX1y7isa4m+pq
m25ivWamJ/lnBP1fK3K0lgzxPL8SND3F2YsIVGD+NfQj3Si6n7g4BcqL2rnxm5aq
btnRwqap866G8pTUsPY71jsGjM4EuxLFQnORXnjkDGWsEIX5JGf5z/oWm66mDNZT
OuCdHe7zJfxQrgsgoi9mVlMjgz0gDxjS9MzcxiQTkzSNpwKKJHOIIat/Ar0/1yOP
ME/JrbCLTfr9irnihg702Io91xPT/mdGSzf1iBtvUkwX/im3Iq7xy0AcHQo+eFDC
ufRcLKzLzJVy9O5yqAF91KZxz3lqyoZw7hAbkRn5eRmxpVtXI0ka1JuVOJYhcOgF
caDBmlBz2LhT/fsU06Dzp+Cd3/zNuf4ZPNgCdC31OC8wMMc8IqI5HQnSy+O4Ma5T
d6KZ4y0FRVyvAHnmz6owK6Qa86AS15gfgsnELh/iWhQiBRArKvgEW6IYkakvAU8p
kzur/FO5lkRY285N90eHtfvGoneAlUdKpBWXM313gtp3cK+khoiWtB9cLI41Y0+G
Yh3iH6jLySNk0mOBLumP6iKOP1lL0iSVI/x6qJ4M3U04i3+Yhi/dR8/o1WB+SPWQ
MvWFT+w5NwYjgfbWY1l/
=i+vs
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Nov_2012_10_05_08_+1100_fmoIBVR9sF=vyFxy--
