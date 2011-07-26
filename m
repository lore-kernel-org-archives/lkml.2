Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab1GZBqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:46:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48650 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab1GZBq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:46:26 -0400
Date: Tue, 26 Jul 2011 11:46:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Simek <michal.simek@petalogix.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: linux-next: manual merge of the microblaze tree with Linus' tree
Message-Id: <20110726114615.534c5501ac3d27d0459087df@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__26_Jul_2011_11_46_15_+1000_wf9usW4F=Zy1XH.h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Jul_2011_11_46_15_+1000_wf9usW4F=Zy1XH.h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

Today's linux-next merge of the microblaze tree got a conflict in
arch/microblaze/pci/pci_32.c between commit 98d9f30c820d ("pci/of: Match
PCI devices to OF nodes dynamically") from Linus' tree and commit
c9d761b7c4b6 ("microblaze: PCI fix typo fault in of_node pointer moving
into pci_bus") from the microblaze tree.

The former removed the line fixed up by the latter.  The file was then
removed in a later commit, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__26_Jul_2011_11_46_15_+1000_wf9usW4F=Zy1XH.h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOLhxnAAoJEDMEi1NhKgbsb0UH/29oKfW+/ZmhrEl67gBTdMSw
/R+n2eQ4qo5HsRFjrtyGADorbeIyxMoAcHiP1Q8qgGvPiXPmvhy+wGXZ2smJlsYs
FaGk11PFQuDFgZMnyoiHJ6sQZ6zoLrt1HRswQecxeEvTpJ8DxLhmVkzYmxZrrK0H
7orWp6YKrJ7gKrx3jHl9ipuHbmkVupbJeOJSAm52avnfbu6+aCB/Hclc+3umLHIF
x3N/oPIXkkGNjrnCW4BRvP/yLNJ+C0kRNdliOWdiHg9R63vq9hMHDBR6Pv9qnWZd
dGGxjiuxVIz7VJX/1ykv52EuEbdz8zEcumqR+chLxcHV4JN5TcE92n1CO8hINzA=
=+X9J
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Jul_2011_11_46_15_+1000_wf9usW4F=Zy1XH.h--
