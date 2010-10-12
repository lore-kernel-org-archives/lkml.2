Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0JLAR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 20:17:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35204 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab0JLAR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 20:17:27 -0400
Date: Tue, 12 Oct 2010 11:17:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        <linux1394-devel@lists.sourceforge.net>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: linux-next: manual merge of the net tree with the  tree
Message-Id: <20101012111716.0c54b093.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Oct_2010_11_17_16_+1100_+C5LqZvz0+wtXK6S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Oct_2010_11_17_16_+1100_+C5LqZvz0+wtXK6S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/ieee1394/eth1394.c between commit
66fa12c571d35e3cd62574c65f1785a460105397 ("ieee1394: remove the old IEEE
1394 driver stack") from the  tree and commit
01414802054c382072b6cb9a1bdc6e243c74b2d5 ("ethtool: Provide a default
implementation of ethtool_ops::get_drvinfo") from the net tree.

The former removes the file.  I just did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_Oct_2010_11_17_16_+1100_+C5LqZvz0+wtXK6S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMs6kMAAoJEDMEi1NhKgbsSbgH/RFadt+4RXVZ2xAzo7abYeuc
jwoMssEU8pGw8BDzu5p3o1cWn6bde6TotWByod6stT1qoh77dkzFc9D7HG+rPXE+
rsfwaRAy/zK49XwFg1VbO5M++iwXH8tEYSHeP6E/sKmAYIcclNRbI4Szna/Yyd8N
vm7rLh5+AYLkjSCneZY6EaFW5ukAEVabOe/oXU8zEjw+5UBbqAUOy7VQPB1YDfF1
nwqvpC8c2qDv/5WCJeWeSZ0XPS6zbWzgCq770x2IcXLDMzkiKBBjSKDKqNWXyGoD
EVaNKlC5W15vg6UZlIFlAedPCS2e4ZS68yIDv7gBhvU+lbSMQvsU8Q0RiDpwpEQ=
=xyoH
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Oct_2010_11_17_16_+1100_+C5LqZvz0+wtXK6S--
