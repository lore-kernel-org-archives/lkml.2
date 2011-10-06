Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935661Ab1JFFbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 01:31:39 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:42558 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab1JFFbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 01:31:38 -0400
Date: Thu, 6 Oct 2011 16:31:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the moduleh tree with the staging tree
Message-Id: <20111006163120.1a1315643e927de4613cb1f9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Oct_2011_16_31_20_+1100_yUjBzxoXXlceKHkn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Oct_2011_16_31_20_+1100_yUjBzxoXXlceKHkn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/staging/iio/adc/ad7314.c between commit 48a2c3799b71
("staging:iio:adc:ad7314 removal. Supported via hwmon") from the staging
tree and commit 09ff337cbb48 ("staging: Add module.h to drivers/staging
users") from the moduleh tree.

The former removes this file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Oct_2011_16_31_20_+1100_yUjBzxoXXlceKHkn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjT0oAAoJEECxmPOUX5FEqKUP/1+/dVqWgRiaYf5xAkcr9X5b
Cmzl5UjCV14NIWFEbBjL0BVcaxZhy/AZAJh6RoTNm+M59CaZ8+BObfpZV1idrKBK
NQXFmhb/AQAOLRdsXJ6eL3MT7KwL9gGYA5d1Pev2WeIgHvRGwbin1un5acmmaN80
3nP3Ityb1B4Hs7YNkMspmAxOUhiudQGEehxde21Glzt4h7l1i1jU9Lda981xqM2o
RvCGp7I/zbXYgdt1v40RqvpNTrLIfD5xjZK1HgvS5XdVd+KAovkloVlJMSGImRUX
STA4IMwG683lOBLrIps5UYH78k187Id8pSw5aoGp8SO6Pi24vJZdGIUrRlZlPxIo
KtMu28YAKboXmZH6dcDlFdbXotLhxk8lrsPaegDj6UZAReNhoVJURks5wDxvLmna
ZGPG7YqoyvTRll8xer8k4SnCp1DUzTI2EI82Ybs4b1MkUxVgpjcJxWPXnA07ngGI
V4wDw3InVwYXzIT/QsjSdNy65oWKMWfs0NZahiqEmt08MHETIlXnm1j+U2L6aARm
CIPFKd9xfMdx7Ab8QQmXdP9FOJsPowdTxpuftQlR5YlM+VLe2Mr3A2o+8Ui4I+pB
lLDGDkjZ/gEmEctYixPBB/19eBZkuqR0/AI40G+9yWvexBmnhiAl4S4anpxEkL6J
7Sk0tqD6Md9D15LHfUWm
=rlFq
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Oct_2011_16_31_20_+1100_yUjBzxoXXlceKHkn--
