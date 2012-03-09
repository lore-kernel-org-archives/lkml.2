Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382Ab2CIBc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 20:32:27 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58038 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab2CIBcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 20:32:25 -0500
Date: Fri, 9 Mar 2012 12:32:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the pci tree with the powerpc tree
Message-Id: <20120309123216.82d231febae9ce73bc59f9b2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Mar_2012_12_32_16_+1100_3B0z1Ne=Q0.3qtL8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Mar_2012_12_32_16_+1100_3B0z1Ne=Q0.3qtL8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

Today's linux-next merge of the pci tree got a conflict in
arch/powerpc/platforms/iseries/pci.c between commit 8ee3e0d69623
("powerpc: Remove the main legacy iSerie platform code") from the powerpc
tree and commit 673c97562489 ("powerpc/PCI: replace pci_probe_only with
pci_flags") from the pci tree.

The former removed the file, so I did that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__9_Mar_2012_12_32_16_+1100_3B0z1Ne=Q0.3qtL8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWV2gAAoJEECxmPOUX5FEfOkQAJaKjqvQy+NIHbavLw2+Oqgv
MMV/Txj3SqTKAD/8d0jOuPiJZzf9oKJy2J3997XVsUc7AInGcyFQDCRNpvIMoCqT
3if91plX4k3vMnbCmfPNRL1/Ykiq6tEkv1V0Yriq35ynv6gcgHrPAV8IRclA6/89
zQYbFMHveDqJCbiIDFhMqTVSwVrXvAigg+dNYbYxeXYxxZ2SaaJvJbVXURfl4zyP
lIMqK/Vjd4gKFuSLD7gmKReduTt6XIpwHxXsKkPlr3q5m5shXhERi9s0LG1gFUYe
AJDxS2LtS45ZXFvri+Xx2d2EyiCF80APmEZ8hu/v/SLZ6e7FyqKG6luE5QX+svbE
wL2Lkc6x3EC9XrOqjeXtxt86L1pwg7XnSTA9CoQqPbDj0hwK+ILQhI/yrgNnwVTd
fzOk9m+vL0YPGUxTSPee+2E8Iu9FUWXillmbZjTGA+5lzjVtL0gqfOo2epPIQnc2
Ln5bLDdwj2JLfl9th8OMNg1NZyLngaxaePGedngzo7JqwIDklVkNIly4FxURqPTS
1E6uf/3lXBYt+2r8Ja2L9s0vowlIEqfn2XjGKzDu4Gn5LouvOXDhMV0cGziA14C8
09f+DGLXfcOuOiM7pkWKoCsLPAJ//eyhg65nPgz+opp+tjQTKXI+4yz/pcEfhJ68
KWg3sHdQD2t4R4NZj6YC
=iUuf
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Mar_2012_12_32_16_+1100_3B0z1Ne=Q0.3qtL8--
