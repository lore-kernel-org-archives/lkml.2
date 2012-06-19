Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab2FSEyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 00:54:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38648 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2FSEyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 00:54:17 -0400
Date: Tue, 19 Jun 2012 14:54:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jenny TC <jenny.tc@intel.com>
Subject: linux-next: build warning after merge of the battery tree
Message-Id: <20120619145408.4c68bff2ed75b52fdba66eff@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Jun_2012_14_54_08_+1000_XuMRex53BAudd2oI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Jun_2012_14_54_08_+1000_XuMRex53BAudd2oI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

After merging the battery tree, today's linux-next build (i386 defconfig)
produced this warning:

drivers/power/power_supply_core.c: In function 'psy_register_thermal':
drivers/power/power_supply_core.c:204:6: warning: passing argument 1 of 'th=
ermal_zone_device_register' discards 'const' qualifier from pointer target =
type [enabled by default]
include/linux/thermal.h:149:29: note: expected 'char *' but argument is of =
type 'const char *'

Introduced by commit 3be330bf8860 ("power_supply: Register battery as a
thermal zone").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__19_Jun_2012_14_54_08_+1000_XuMRex53BAudd2oI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4AXwAAoJEECxmPOUX5FEy+EP/0NcdqkOM+1vp1phhrmZ1Zc2
5V7NO7/wQnR1mX82qUOG8+zBywExmT8IC62Wi4bTaeEmOHDBozFA6d42ra6LWCMJ
W047sO5nwRsA64hZuVNuDF47+Ioqn4JKJD8KVL4dPZMDIroVYcYR5TMW5ELg+nct
oSLQM6s56CeqBG2g7vd/5fuRn4TtA2hZhq83mS9+RRpeeuyqI61O9bOgNJRsUNL2
kkw7TqTs5lRTPzX1zEnC0D3RIe2w4oCyZ88uHa+2vDiB/+XMI8KzQZU+9Kgr6NZg
TtSYFHKOe/eQY9NvWnTJpolcUL+UWnzZWV2PeMjB9Eln6CBsQC1STPR96ni/Nadw
aC0mRo/ykrCZ68vrj2/S1wX9fI4jAEtDaNB9hrakwWtBRgw1qXGPqnFIMfBFBXmD
AMelSES9DwSPKVNBdI4f1801SF5V/fD6uJ5Qeul90rwZMbSLjFUsrNwlAvjDxMka
Grq87nJufwMNnrsH1YQzhx8DLu1sTIzj8SkPpxEvpjPaj4MReQraCtVWlZBT0sze
0H+UraGMiNuhG9GbO3mN9pLVqYl6ssyPJdAyvVhl8EFYZDTygA5QgOFohG2iWzMq
8BKA1GbP6yjFt3fSZF36N7koM5/4a2C9SRP3PCOiQvPSiZ7ZCiAlKaKlLvpITtsy
XJ0vrUTythti+9b4+V4J
=8M+P
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Jun_2012_14_54_08_+1000_XuMRex53BAudd2oI--
