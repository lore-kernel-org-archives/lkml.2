Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2B0Abk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 19:31:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56171 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2B0Abi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 19:31:38 -0500
Date: Mon, 27 Feb 2012 11:31:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the pci tree with the mips tree
Message-Id: <20120227113129.c03c34ff7ea516f155cf0c87@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_Feb_2012_11_31_29_+1100_vTujrHiqiO5ZGod5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Feb_2012_11_31_29_+1100_vTujrHiqiO5ZGod5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

Today's linux-next merge of the pci tree got a conflict in
arch/mips/pci/pci.c between commit f79eaeb10849 ("MIPS: PCI: use
list_for_each_entry() for bus->devices traversal") from the mips tree and
commit 96a6b9ad05a2 ("mips/PCI: get rid of device resource fixups") from
the pci tree.

The latter appears to supersede the former, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__27_Feb_2012_11_31_29_+1100_vTujrHiqiO5ZGod5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPSs7hAAoJEECxmPOUX5FEmOIP/i7+mXVsHo0dgtj2wSVzpFX3
g0RJovZ6V7OjnRGuGFVQ0c5gNFb8jdBQWZMLbhB9gBQcooK9UfstU93DHTF+CPZP
ulHHJi1KVGrklD2eh3k3gCh84pJvUBVqti/NJiPi96PyEQaAfRreIcNH85RC0c99
Q/ij4XIt76PlIl9ONCH2gcY9JrWVre6861BtQ8+9e8kXkn1AeUqikgx6SbmSbdJY
EQMxQu6OmphEvY3+AZJA0stTRE+v9t9IQKKrwfPIXAgmEudpECgoCoIVs/RieZp2
NnM7rIKGhO0oH5B7iR5HVKxTkfUvypNUvXFAvDUPDX6HyGGOGE+rhksraVXu5+t1
H5v1PrSEzqIL8YlPtZB5R2f+NcBS49SJvK8ItfHxBcF12jK8DQtjuqYZns1YVUsn
ml9nOtUOHpLPIVYesR3O0/7kASN/lKpjRUDTm3X4GQrrQ73xYqTwo5SoTky3fC55
1sPkGKOVrxiIMTf+K/hrmITIXW9yvAyF5b+H2/FDybK7SJMbRHAcFonF19owTCGp
aDXLsFEZ+yiEyn0foda26Yakwq/FCTWgkJd+b/3+xTVdoSQsVK2TkTfVTNp/GGI8
UawYczzs8fN1QnofkqsLuEotY2WMb0l6qOfn2a22rLh9dhK3UpoeaIdMj7pj+dBN
3v2TPLKjcHUkZaO81ZX2
=pxnx
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Feb_2012_11_31_29_+1100_vTujrHiqiO5ZGod5--
