Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab0JXX7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 19:59:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46887 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab0JXX7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 19:59:07 -0400
Date: Mon, 25 Oct 2010 10:59:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error importing i2c quilt series
Message-Id: <20101025105900.83472a69.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Oct_2010_10_59_00_+1100_BeG5TeAYIIhAnzlS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Oct_2010_10_59_00_+1100_BeG5TeAYIIhAnzlS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

Trying to import today's i2c quilt series gave me these errors:

i2c-i801-add-intel-patsburg-device-id.patch
error: patch failed: include/linux/pci_ids.h:2444
error: include/linux/pci_ids.h: patch does not apply
Context reduced to (1/1) to apply fragment at 101
Context reduced to (1/1) to apply fragment at 45
error: patch failed: drivers/i2c/busses/i2c-i801.c:592
error: drivers/i2c/busses/i2c-i801.c: patch does not apply

I will use the i2c tree from next-20101022 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Oct_2010_10_59_00_+1100_BeG5TeAYIIhAnzlS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxMhEAAoJEDMEi1NhKgbsi2IIAIKZwOAgijvpED4bfiTKaksY
iv1kocJZbb+Dog9R/2Ohqgbqfkef//Azc582Qhz9FpLaYhCDZvzFRQBNCjOmArnA
+jrKc2nEUesAXEUCXtJsCBWKn+OATeTRKfiSE4NvM4+TGGQX7wNAYcmpuGLZXPGC
hnP5+od9Xl3SacVM8dJpGDrQTvkhQubZxizo5C0/yBm5oT9UBwBlL6BiFNmbIQsY
XBshM3hlW0lu0cEz62ax2cZgGeu/fCxV27+LxaXUKjAWl02XEqNoD6vZMjFywL9n
OLjZT6znuYvqcl9bDWhbE5sbvPy/SjGHhXTcJzhR/rIjtXvrdkjupcJLVx/09ts=
=zJnz
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Oct_2010_10_59_00_+1100_BeG5TeAYIIhAnzlS--
