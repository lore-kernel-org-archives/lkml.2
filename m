Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2IQDlw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 23:41:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38129 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab2IQDlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 23:41:50 -0400
Date: Mon, 17 Sep 2012 13:41:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the target-updates tree
Message-Id: <20120917134142.c7948ae04bdeabe1a863e464@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_13_41_42_+1000_mEB.XR++DIlGUmy6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_13_41_42_+1000_mEB.XR++DIlGUmy6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

After merging the target-updates tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/target/target_core_transport.c: In function 'transport_get_sense_bu=
ffer':
drivers/target/target_core_transport.c:582:22: error: 'struct target_core_f=
abric_ops' has no member named 'set_fabric_sense_len'

I can only assume that this has been caused by the (largish) changes that
went into Linus' tree recently conflicting with changes in the
target-updates tree.

I have dropped the target-updates tree for today.  Please sort the mess out.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Sep_2012_13_41_42_+1000_mEB.XR++DIlGUmy6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVpv2AAoJEECxmPOUX5FEoAUQAIR7A1MTTrtKc2nqRry/XGz7
NWZnWIZ4+UVTZ41+npLyBCSg1SKq2GNU/33AD3cz2W9fm2G4ZiubeuZyyvXOQ0DK
dBTYqNtvBV4z8zRmaO8yPAB7sJNOsaBbzdWvLeiwQLKw0OXpYh3iYyMFlC/DXM8E
H73EbmR6ZtxrFAIr39MzS+xgoQ2p+Hr2DJypWNCpggmJBMcq/Qt6LgP47d8jll0V
eAdrmURNBZR0KIIBj4iUa4GWijl66wEixgyxvqDxbVTMeYi/+J4XtoRYQ8+VTGpP
hzZ8pAq4BdIWmbeDj9K1ecbTgoO1WxDH06ZhUXzfxWIX6HSoYIrJTPyxxucsG652
0sAKRHMH+5GsEZT5GnYo9MGk8KxOzOyqIA6UTj76JZ21zQS0M63qS7C2UaQbEvRH
y8MOiCHFkD+D+PC2V0E4rEoR7A3RgcvFVI3F+6xQQ+0PfZAxTLveHrD0A/COtrQ8
1MD+8P6nr2RqozlEONNWCA50gk1Lh5CKFmDMcWlkBoptjNDGj5mY5+YDQLcREJI0
P7l9+SPIbvpIpk7XOKdYcC9hfHG4EpTOSPiRWQn5DuBO40CimkxsgAAhkxPZ03HE
x1F71rn6QWxNs9e7/rl12SkHPysIPyHVrYT96re3mLN6xztzJ6egwbSWfKsfhaPf
GGK4JG86n5buwfvO0/zS
=ulPg
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_13_41_42_+1000_mEB.XR++DIlGUmy6--
