Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab2LCBEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 20:04:42 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52383 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab2LCBEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 20:04:41 -0500
Date: Mon, 3 Dec 2012 12:04:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland Dreier <roland@purestorage.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: linux-next: manual merge of the target-updates tree with Linus'
 tree
Message-Id: <20121203120429.e988d904019ac7ebd609e25e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Dec_2012_12_04_29_+1100_Nk19MFeqDeoNY5t_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Dec_2012_12_04_29_+1100_Nk19MFeqDeoNY5t_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

Today's linux-next merge of the target-updates tree got a conflict in
drivers/target/target_core_transport.c between commit 3ea160b3e8f0
("target: Fix handling of aborted commands") from Linus' tree and commit
019c4ca62148 ("target: kill dev->dev_task_attr_type") from the
target-updates tree.

I just use the target-updates tree version and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__3_Dec_2012_12_04_29_+1100_Nk19MFeqDeoNY5t_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQu/qdAAoJEECxmPOUX5FEUS4P/1FU/6kilyuhQHzVb9aOZAAs
LzvtNcEsZNCDK0N0s/Minrb/GvCAiAxqoDgHdsT6zEG29D3PYDJi6ejOT5BGhT9n
/ZsPTFlZ5qaMJhYkoGKfN1k6LsBgnEs223ePkT1YdQ3L7T+5t0SQYz89gLMTOtjM
nEsKkG21Vnycm8kNED6RxfONIoNl+myWBEoEPb62h43IaCIS/CBCvQnqQIOAzByE
m9xLLNN2gXKyH3m1ICt8R+AlcttmkDUGagOCqpW3QzsGBg+HmpC/I463lnY4p+Ja
tv7HeIuvtUHRUeSIzGYRJ8+oJZ8yFoHEsQDHvZGUgQNpJJ1/5TOufACvUS+o5gKH
1TXjbg7TQ5FvD2kIuITCPSvg8QDb6tqRpy7YdaICAKpoJeSxPHdUfoKP2XB+EzIU
bNb2TG3Z0/giTY5eg3BkGSB802/5Oh79acGF7q/4KpWRe0bZ/IiQdhQHqLA3nwrG
KhebvRgQfqxNjbKZBHs5yJ0lSLqkDqSTdbqVPm0V59SZCq4ZhFx+fRyVqW0Q8rKx
xx8qYUQeiQMIhWAbythV6eCXmVcp74PaDL5ixQu0cWG9oFUNm3S6qX+Un+uUC5yD
JTWJ7Muy0YcZAZZt3yFwkFtMzFSbOii7yXpHDSU/zNXQ4iIjEB5eGcBjqLYiH07C
KPqfGa3tHqPcTLwOj8Nm
=3Qm6
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Dec_2012_12_04_29_+1100_Nk19MFeqDeoNY5t_--
