Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032Ab2K1FOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 00:14:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59285 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab2K1FOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 00:14:42 -0500
Date: Wed, 28 Nov 2012 16:14:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Kumar Amit Mehta <gmate.amit@gmail.com>
Subject: linux-next: manual merge of the staging tree with the tty tree
Message-Id: <20121128161430.e6719a4c3f55f12074b6cfc4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Nov_2012_16_14_30_+1100_.W.wuFjhYPCg=p/u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Nov_2012_16_14_30_+1100_.W.wuFjhYPCg=p/u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/dgrp/dgrp_tty.c between commit 3ba89e96610b ("staging:
dgrp: dgrp_tty.c: Remove the TIOCSSOFTCAR ioctl handler from dgrp
driver") from the tty tree and commit 8fdefcb0ab74 ("staging: dgrp:
remove TIOCGSOFTCAR and TIOCSSOFTCAR handling") from the staging tree.

I fixed it up (using the staging tree version - since it is a superset of
the tty tree version) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Nov_2012_16_14_30_+1100_.W.wuFjhYPCg=p/u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtZ22AAoJEECxmPOUX5FEvckP/1QEtrGb0N3w7e2kCFkeO3nP
IsG9AZtkysNglrW+oL8G0NX+brvMbtXvBQqhEyHGI4eiB5pwAc6vY5yyRgyt/DpZ
/gnUXJl9a+AZgu/nVpjbWXCpExkLvTJ+dFWDPeDf/KZfFuy2ZwdNwyxPMOTI+g/G
ZYGj2xthMQ/bPHfS++qv89SpyeKURb9IHwfS7F4kstLU58YiIhMNuHXyYTNIR1mC
73+iFups3GIL6RSwt2KS2JHV7cMiFmyOMX12KPxj3kSXiFwBBik5o3QCricpNWwB
FNB4kVhu7TSJqWV6yY4K23khRnYNABrVArFwHW/nPU++E8QaZaEZb1qgnmHCh3i+
yahw3o2MdpuaymhWIkIA2fK5trZjoFWqhowbugZEwECXy8cp2GdL4VVMbrEdArg/
b7WI7z+Xg7uHmcXgvRyE4e5OAnkVNl+k0akjJPRgPtankGsg4ixwn/Z8xeKqcBks
YIB2JFXmZkKkqwhR9iqRpZz0l2E7ne5AZCNKhkg6EnZL3XN18lIeEnKobtLP9XGd
kWcAOEcei6n6JlqK+DaLuenxJCyqmc5FgmFC498W9Z/boIgBI5srToV8NGHv/Ms0
c+SVJjq6avdsnHNY3oXhPY8NM+/Abd/RbDhqKJeMv5tnTL2k9xcTmJEfbcp3jSUQ
sciLAj8pMTx/DuCRghOn
=Wnjt
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Nov_2012_16_14_30_+1100_.W.wuFjhYPCg=p/u--
