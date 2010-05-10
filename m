Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0EJB1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 21:27:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45724 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab0EJB1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 21:27:35 -0400
Date: Mon, 10 May 2010 11:27:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Christian Lamparter <chunkeey@googlemail.com>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20100510112729.c8a5527b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_May_2010_11_27_29_+1000_rAmnJOijfPtZQhAW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_May_2010_11_27_29_+1000_rAmnJOijfPtZQhAW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/ath/ar9170/main.c between commit
984b3f5746ed2cde3d184651dabf26980f2b66e5 ("bitops: rename for_each_bit()
to for_each_set_bit()") from Linus' tree and commit
f3926b49b7122f66f8f2a1da4ae3275b112ab3e7 ("ar9170usb: remove deprecated
aggregation code") from the wireless tree.

The latter just remove the code modified by the former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_May_2010_11_27_29_+1000_rAmnJOijfPtZQhAW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvnYQEACgkQjjKRsyhoI8wH+ACaAy7WDrs8v8zA6455kUjJeV2o
aYAAn01fyqmERNcqszTZVhR6mXGLyjrC
=Hcu2
-----END PGP SIGNATURE-----

--Signature=_Mon__10_May_2010_11_27_29_+1000_rAmnJOijfPtZQhAW--
