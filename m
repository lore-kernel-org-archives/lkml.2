Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab1EYAiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 20:38:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39614 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124Ab1EYAh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 20:37:59 -0400
Date: Wed, 25 May 2011 10:37:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antony Pavlov <antony@niisi.msk.ru>
Subject: linux-next: build warning in Linus' tree
Message-Id: <20110525103740.f8917fd8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_May_2011_10_37_40_+1000_otPgkjPJ2IPHqEqA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_May_2011_10_37_40_+1000_otPgkjPJ2IPHqEqA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

In Linus' tree, today's linux-next build (powerpc ppc64_defconfig)
produced this warning:

drivers/tty/serial/8250_pci.c:1457: warning: initialization from incompatib=
le pointer type

Introduced by commit d9a0fbfd7bc5 ("serial: 8250_pci: add support for
Cronyx Omega PCI multiserial board").

Sorry that I didn't notice this earlier.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_May_2011_10_37_40_+1000_otPgkjPJ2IPHqEqA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3E9UAAoJEDMEi1NhKgbst/AH/2wcnQLa1zXpXVvB3Wf373O2
yBdnesb2gduM/RR7fVun59/PbuRrYxVMrTygnDvZr2pHP17EwzmxuymndBgjsJcO
hshrtgqWYw8wlvrOevGHKQoxjwfPkRAL4NnT+ykEJJ8m2rBqL0BHicQMN5nOwkAQ
pkrEgQ3L0cmfgju4iousZB7Jy3/pvAfSl3BgqGirhjeeJCDQekIO41CsqltuXBT1
ERtjc808F3t8ElvmGvEkyz/6e1P5bL2sfKp8D53MQuUDMR6a4VTmjNX8M6FK+3lt
BFAkDwM49j2I8pGB9eVB3PgfVZ/q9HdpfQL9hfPxBfj9lZQYqTILSk+YcuRU20w=
=Esz7
-----END PGP SIGNATURE-----

--Signature=_Wed__25_May_2011_10_37_40_+1000_otPgkjPJ2IPHqEqA--
