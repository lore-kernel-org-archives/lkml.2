Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab2EGF6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:58:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53951 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2EGF6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:58:41 -0400
Date: Mon, 7 May 2012 15:58:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: linux-next: manual merge of the staging tree with the tty tree
Message-Id: <20120507155831.a84a079857b24b7772333a37@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_May_2012_15_58_31_+1000_APjPxDLS=kppp7P5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_May_2012_15_58_31_+1000_APjPxDLS=kppp7P5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/serial/68360serial.c between commit d29f3ef39be4
("tty_lock: Localise the lock") from the tty tree and commit 60e6d2689c2a
("staging: evict abandoned 68360serial.c driver from the kernel") from
the staging tree.

The latter removed the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_May_2012_15_58_31_+1000_APjPxDLS=kppp7P5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPp2SHAAoJEECxmPOUX5FEA3kP+QHPA9hci30b30WG9lgIuriR
iHEa40u2GVYZs/zGcfioLuSZbl9txlu0o5dz7H4TLQQkVH/EDf9q7wQJOminWQK7
1igoLE78PrAm+XNBDTArZbFQxY3pSoH4+gcK9+N5bnNTvyLPPU8fc+kUWDPiAj5D
YlW5iQRa+igd5+jsDHriFMZIAIuDSlxxnaLZhzig01MvAcujVxpXg5HnaBadhYIe
n36naTYAaJJoHYzUGCy/vqLKdL0ku5fIXH483PUz9ropF0cF8lXmY+eUTUOFNq6U
jUlL0Tzfiyx589f5XmL68bSGIau+9eJ2kEO8atxhZXbLBqcBrN6KyH8CyTxHgQRc
5DcYivMMWemB4fgAtaJCSw9O5X1LjWolgj85RQ1eZ7HUX2NuXKNN0FdQZZAzlpUn
LVnVJiByhCO+zGFneY9KReOInjzEOsbfYcNeywDkoPj75L4UFSGHlgNUv7pheeEa
3JRor/5NqZl1JLX+VSIimSVxcIstnfOAMzOlfmc4QNTCjA4aAe7RZeF5Sz3ViP8A
c0kmcFwLQb62npxZTW9w2RGmjj6X13NhEGuu+7URVNmmFzyBWBI6Ws1yURYbMP0+
12UgnadAjqfnW2KjL8PQ1CZYPcYK1N0IFZMPrT9fGB3IY5UZf9ctZCYA/MTROqCW
SkqYxeaHoJ6K1G9IewC3
=7I1P
-----END PGP SIGNATURE-----

--Signature=_Mon__7_May_2012_15_58_31_+1000_APjPxDLS=kppp7P5--
