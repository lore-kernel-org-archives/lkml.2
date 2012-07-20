Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab2GTAdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 20:33:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57885 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab2GTAdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 20:33:08 -0400
Date: Fri, 20 Jul 2012 10:32:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the scsi tree with Linus' tree
Message-Id: <20120720103254.4a043ea94ef16992466a8b19@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Jul_2012_10_32_54_+1000_Ct/iwzepj84PZVJS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Jul_2012_10_32_54_+1000_Ct/iwzepj84PZVJS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the scsi tree got a conflict in
drivers/scsi/scsi_wait_scan.c between commit eea03c20ae38 ("Make
wait_for_device_probe() also do scsi_complete_async_scans()") from Linus'
tree and commit 01444e1106cb ("[SCSI] Remove scsi_wait_scan module") from
the scsi tree.

I just removed the file.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__20_Jul_2012_10_32_54_+1000_Ct/iwzepj84PZVJS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQCKc2AAoJEECxmPOUX5FE3XMP+wVoXncPzH4sj7GNA/2nDkuu
tH3DD0djmhTbFVwwXoyfN5Q38bLy5xjdb5cku/WiqBsVigsC60iU+dz9U0EbEXnJ
GqlBPmfsypLGybM6KDvV+WmpJCNdVckOBM3uOPoHeHayiRnU5KGmh40tPeJQyWS2
5mNxh8ZPn0sskXxTYgbVAPToe0Z9IRfw7qZAcZvWC8pVWz1MyJRclXoNPNDMK7ZH
H7VYTkqbfKXZd4ww6JtgyzV2PRDPpzgQaEmsvvDpbti+5lSeMveh/Qg4dX1wHxOc
Wi15bO22DGleGjhEjiVnBIKvJ1T0WGNbdani/xywjTFTkIjqLs+Onz4UO28Q5eBD
sRzIh9p8ggiuzystsIkyENJNnPCZzFf84mXpY49sFUoBAbKPMELZWheVab3FVH+o
wFdN451zHyyZFWZGspTImOh170wT8cSbzYlTFF0l2VkJOTrCwqwh7x05T4ncLlig
CesfTOB8HUOhFMOSeMuKhwpgEgbRg+nKfEwU+gY+kwVUfmwWwle/AiAYkFJDCUV8
HaSEgQWD7pEWYeR+fMmtc55y41ZVnaGF+PrCUxiAL0Dg3tzCpXLOAsEM5JGjeHHC
s3Bm9tzrQTACTAo/8OFg5C1VqaehejCTSI1dzhi3QgE7O1hg9+7DoZZiW0j8OL+K
BIbXJCvxHtNYC7kMgie1
=9ko3
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Jul_2012_10_32_54_+1000_Ct/iwzepj84PZVJS--
