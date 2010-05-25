Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab0EYBqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 21:46:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40552 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757682Ab0EYBqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 21:46:21 -0400
Date: Tue, 25 May 2010 11:46:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Jones <NeilJay@gmail.com>
Subject: linux-next: build warning in Linus'  tree
Message-Id: <20100525114614.fd61d822.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__25_May_2010_11_46_14_+1000_PTS0dIspDlqzk/=9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_May_2010_11_46_14_+1000_PTS0dIspDlqzk/=9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/net/usb/asix.c: In function 'asix_rx_fixup':
drivers/net/usb/asix.c:325: warning: cast from pointer to integer of differ=
ent size
drivers/net/usb/asix.c:354: warning: cast from pointer to integer of differ=
ent size

Introduced by commit 3f78d1f210ff89af77f042ab7f4a8fee39feb1c9
("drivers/net/usb/asix.c: Fix unaligned accesses").  This commit casts
skb->data to u32.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_May_2010_11_46_14_+1000_PTS0dIspDlqzk/=9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv7K+YACgkQjjKRsyhoI8y1WwCaA4fPBIcgEiHc220slTxhmHFj
kFgAoJzAjvCRRUg8jvuX5dSqFCfBMXXL
=WIpL
-----END PGP SIGNATURE-----

--Signature=_Tue__25_May_2010_11_46_14_+1000_PTS0dIspDlqzk/=9--
