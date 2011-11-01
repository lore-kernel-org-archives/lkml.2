Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1KADnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 23:43:12 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:45887 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab1KADnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 23:43:10 -0400
Date: Tue, 1 Nov 2011 14:43:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: manual merge of the kbuild tree with the  tree
Message-Id: <20111101144300.4d9ea5834a874944bd87e823@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_14_43_00_+1100_fZCgycJOECBs4Nm+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_14_43_00_+1100_fZCgycJOECBs4Nm+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

Today's linux-next merge of the kbuild tree got a conflict in
drivers/net/ethernet/stmicro/stmmac/Kconfig (drivers/net/stmmac/Kconfig
in the kbuild tree) between commit 7ac6653a085b ("stmmac: Move the
STMicroelectronics driver") from the  tree and commit 2d3def0b73e3
("stmmac: drop unused Kconfig symbol") from the kbuild tree.

I just used the latter version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Nov_2011_14_43_00_+1100_fZCgycJOECBs4Nm+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr2rEAAoJEECxmPOUX5FEGV8P/2NqifpYSrCuIFJ2WCC6fnXk
BbEHaGoVU6csLh6BEuYySawdmSEWaqD83CY0nSwYM1icDxFlZnzln5Lmb02TKBlx
+9+mAQ30Da7Q+/xVJcKoHncNMUntwcjUQGJ6CnQVnIsEwRWVTCGEEBuP/xAvI3a2
gG6V/+fzDxPaEBkU4QJpK6ZQpWNQfoXrFnyXO1TQSfX4eV1MUD6BujUjC1OsGxQp
JIrI3AFaRlHdsncQ37R77vpMeb3HY0L3FCQxe6qN4z72clmoOeZmOuSuwPHTp/9K
okXuXBnIz7V2SbfXSzKnnOQugEBPRNJBxQoC32wGtlhLGkh7KI/7xwMIUcwnz9gG
r2RFSXNDR5z6nEV/USJv/TtsFYehKa88zB1stqLU7PdGL4H52W6nqzaHaHWU2yTm
cPIz9b72pLCFVwLBWhIoeoQGdr8YqR8wVuRKmqZOUF3SwflLwp8rU5S9tAltZaqf
p2cZCVBrlBaxDy0AfoQdlO9lpKNVbeOmYBhqKl+7qmLPz24/j4Pbm2wH6qYMEpXA
YZLfA4AlGXVAmP/iqXFf5Rh1IZr6Z9fjOFzD6lg9hqzGxr+JM/e85iesfFQlKWMe
xDCYg2eixoGe4mixUsHuKlIiyXObBdlH1kWNvZofCWZR1eNYm4jYoq5OJNgvBIHT
mhyl1nHD7xggbtmyQaQ3
=zJn+
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_14_43_00_+1100_fZCgycJOECBs4Nm+--
