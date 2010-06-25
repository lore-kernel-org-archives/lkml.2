Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0FYDZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 23:25:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54715 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab0FYDZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 23:25:54 -0400
Date: Fri, 25 Jun 2010 13:25:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: linux-next: build warning after merge of the drivers-x86 tree
Message-Id: <20100625132545.50e226e3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__25_Jun_2010_13_25_45_+1000_=0J1HI6us3vCoBY3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Jun_2010_13_25_45_+1000_=0J1HI6us3vCoBY3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

After merging the drivers-x86 tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/platform/x86/Kconfig:542:warning: type of 'RAR_REGISTER' redefined =
from 'tristate' to 'boolean'

Caused by commit b8fd1646cc932c911c4d836f7fd9624c05722a2d ("rar: Move the
RAR driver into the right place as its now clean").

RAR_REGISTER is also still defined in
drivers/staging/rar_register/Kconfig ...  Also, that commit did not move
intel_rar_register.c from staging ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Jun_2010_13_25_45_+1000_=0J1HI6us3vCoBY3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMJCG5AAoJEDMEi1NhKgbsL9AH/iSPQSS83CwGoFXQWS+ejCiH
Zfy1IkHNILdezIvblT/J4VIh+JS3BXyE2KONODaGfjju0aSFXT1zw1JCYxgO4+Um
9xjdr7gZuSi6biyTCXYRSh7j1nbeKlIkMABfX21z23UR5mTtkV/tjWQu7wVfqkPZ
3D6hIo1A8purcipoG08A8rLhhk99FkahHBY/HpUrcPAg59spK2+CzQ6XgBhVeFDD
xqg6zVaB+AxonMgIvb5pFFDkTS6BpHtNWNj49TeoQ8fL8dK+5SwrjGBH4K3BRI4s
ujQ09CKxN7pmpXgUYhCaxJ/jVn2OH7tO//Qsu/001aN0Wsjt+bybAFqlBpEBrtw=
=y9oa
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Jun_2010_13_25_45_+1000_=0J1HI6us3vCoBY3--
