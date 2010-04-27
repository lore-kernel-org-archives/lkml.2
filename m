Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab0D0EMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 00:12:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34142 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab0D0EM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 00:12:29 -0400
Date: Tue, 27 Apr 2010 14:12:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tobias Klauser <tklauser@distanz.ch>
Subject: linux-next: build failure after merge of the staging tree
Message-Id: <20100427141224.834a102a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Apr_2010_14_12_24_+1000_aM+4h1hVg_bLWcB9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Apr_2010_14_12_24_+1000_aM+4h1hVg_bLWcB9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "uart_console_device" [drivers/serial/altera_uart.ko] undefined!
ERROR: "uart_console_device" [drivers/serial/altera_jtaguart.ko] undefined!

Introduced by commits 76bdbd933febe791fee114e7bb6c42bbd1a3f4f3 ("serial:
Add driver for the Altera UART") and
11c59b34b299d7214b466cf799410a9a540476e3 ("serial: Add driver for the
Altera JTAG UART").

I have reverted those commits for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Apr_2010_14_12_24_+1000_aM+4h1hVg_bLWcB9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWZCgACgkQjjKRsyhoI8ws1gCbBEp+DoDZYjpwfJU637S360rE
P54AnjDu2aPvtSwghOfNApI1wFMCvand
=AGEW
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Apr_2010_14_12_24_+1000_aM+4h1hVg_bLWcB9--
