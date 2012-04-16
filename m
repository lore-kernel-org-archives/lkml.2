Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101Ab2DPF7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 01:59:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57770 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2DPF7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 01:59:17 -0400
Date: Mon, 16 Apr 2012 15:59:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tkhai Kirill <tkhai@yandex.ru>
Subject: linux-next: build failure after merge of the final tree (sparc-next
 tree related)
Message-Id: <20120416155907.32c0041caa002f72da4635b7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Apr_2012_15_59_07_+1000_HSfljrAXC4tUyZCe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Apr_2012_15_59_07_+1000_HSfljrAXC4tUyZCe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

arch/sparc/kernel/pcic.c: In function 'pci_time_init':
arch/sparc/kernel/pcic.c:741:2: error: 'timer_cs_period' undeclared (first =
use in this function)

Caused by commit 62f082830d63 ("sparc32: generic clockevent support").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__16_Apr_2012_15_59_07_+1000_HSfljrAXC4tUyZCe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPi7UrAAoJEECxmPOUX5FEqmcP/RaxBRvkhSxHiqjWdqhbWVAY
ScM2qPKMAsLT8W1YtGZyfNY3Hd37KXusWdg1+EoACfYPECC3+PUp7apynqnCRJw7
/bQjvYiX2FiFnBRRpK6cC0QuItGAvQPWUbf3vzonwVhUIbRkLnrgMA7wn73iX2+f
IyIjvcg2cIsALAgs1pqJl1fRjXmDcSAA/qjvgL2WTwNgMT50O5mLE1Bb6wuNzG0M
ggYQK1b14lZZ8O7Jv6/4DBELhuCg6xtkQtHm7ZDIua/UIl/BEHs5e7EBwIheNjrC
H4A/MHtUo2X8F/JP81MSFsbrEmat+3l07IiI+8TOe3XOm3tkr4YoUmUiaFZNh3Su
0rsEFQGJZ/L1fx8qcMUQJqg9w3Fmmp2y2JhfBdCIYAfyi1M/Kjp3NNn8l++DasXm
OQnwU8KIiimRRInfUsayzc/D5qGPeBiJoZ7CjetYJBY+yHTMjwONIOMTpOHCvB6n
egSlRXQY3SbgyItopbXV72wG9ULqm7/bQfbUJ/Mk0W28TeppRi+7RuR5fP03GTjE
LDYFGwaQ/y7kea0vxGIS2UnlTaDdgQ1RxEMH2Ar7k9xW5zmCssnPpr0tMzBGORMo
58esU6c2mjGdt7lozFp7wZXXJkOj6WPjqBkEPuLoqwS3PLDLRykudeau5zHSZ6hX
IPP4hVuclcCSaT9uvrKB
=+TIA
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Apr_2012_15_59_07_+1000_HSfljrAXC4tUyZCe--
