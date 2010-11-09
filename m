Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab0KIC1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:27:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41168 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab0KIC1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:27:39 -0500
Date: Tue, 9 Nov 2010 13:27:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        Mike Frysinger <vapier@gentoo.org>
Subject: linux-next: manual merge of the trivial tree with the  tree
Message-Id: <20101109132725.2e17ae65.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Nov_2010_13_27_25_+1100_GDNCAHsE+vsc0EuK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Nov_2010_13_27_25_+1100_GDNCAHsE+vsc0EuK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/blackfin/mach-bf538/include/mach/defBF539.h,
arch/blackfin/mach-bf518/include/mach/defBF51x_base.h and
arch/blackfin/mach-bf527/include/mach/defBF52x_base.h between various
commits from the blackfin tree and commit
b595076a180a56d1bb170e6eceda6eb9d76f4cd3 ("tree-wide: fix comment/printk
typos") from the trivial tree.

I just used the versions from the blackfin tree for now since they moved
large amounts of code around and deleted the latter 2 files.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Nov_2010_13_27_25_+1100_GDNCAHsE+vsc0EuK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM2LGNAAoJEDMEi1NhKgbsf7oH/RevOXe/KC8gXeLct3SH66AI
NEQppZ+YEhcvodI6nhwBQcfdo980NvEaHChnFf36WsrqM7jdAlxdTWh2wlsum9IP
fozny3vemABu6sPKofYZIucW74D9W7fyYiqm8MOxaTaPAPUiplqu/0EYFgBPI3o4
FjIX9hawy1ayivoG1UUCD3imp/tyzfMpZp3dciFXXPLx354tQ+uG6dqLLdIpoUe0
evTAyDJ0gLdyFNcEvzICykn0q3a2C6IfJ3kxyDcByhZOoGm2+6T/4FXRYdZqnws9
ZgAnoVtQParvgRFCAzb1RKwHJU7nZoYRWEJlB59S9CKeKTC16kwqqOPxa/95HLQ=
=aTPR
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Nov_2010_13_27_25_+1100_GDNCAHsE+vsc0EuK--
