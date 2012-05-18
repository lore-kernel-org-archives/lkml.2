Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030647Ab2ERCKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:10:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54888 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2ERCKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:10:36 -0400
Date: Fri, 18 May 2012 12:10:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: linux-next: manual merge of the isci tree with the scsi tree
Message-Id: <20120518121027.0f780260e88d034ea9aa0584@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_May_2012_12_10_27_+1000_Viv=k+5nLDU3=HRT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_May_2012_12_10_27_+1000_Viv=k+5nLDU3=HRT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

Today's linux-next merge of the isci tree got a conflict in
drivers/scsi/scsi.c between commit a7a20d103994 ("[SCSI] sd: limit the
scope of the async probe domain") from the scsi tree and commit
2eae65b32c9b ("scsi, sd: limit the scope of the async probe domain") from
the isci tree.

I used the version from the scsi tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__18_May_2012_12_10_27_+1000_Viv=k+5nLDU3=HRT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPta+TAAoJEECxmPOUX5FE6jEP/0nUqRluB3sIiUnmbugT9eXi
qPNlmyWzwfMAeuFm8PhB1PdExp2nnW8RFjrRaoHLrn/LdlQdoWfEaiWMg71zRs04
FRxYHqVGWpmThUvUSjAmiYGCWNWMBgR22Q4mbnCCD3YwBoFAiTZnnWgpLUfxjWUj
FoQrZBU5BNLFWUOHdrDZNxBhnTU4KmXMiurjzwgbMzHghQKgb0wKdCltWH0JAWCc
+VtFDefTHeIIk9+8Caq5QXrAjlVLjra58HIiuaVVO+eDCcRFvK/vx4hFdIjex3Fk
BKAajypfAzzKQRqvndSrM1WZzkjauPpz59Qt9t7DtFeD2R7/0GjjDOhd/l5QQZHM
XSqM/khBNHC+K8OEBdRp4qejlGFmqwlUBLNJKjzO4aiQq3D1Fwnj6H6Y/UqUTQ9D
98rY1bMzSS9LfwUAIl2YZD5U+hmiZAbyoGGgs+GAi/kHFttgCGggT9mbouLNrlPW
fOVmDHsy77E7+VmVPgM5oJjh/38+8hhdQFchlrdEsoTxvoRUPhQFqnvz5j71lff1
qK2G7wpQley/CINPBlPbgRuLKlmzoCYCQjtJJMcujNKBxkXVdHTLHjvZv64A4Jtu
nNpX2M84WtqIDU1zA5CMrQnQ0GlZldJrfDvc5mvhfVdJNjv85MkNn6hnFuthV9mZ
TvMb6rKJNJqNAYR9LX2b
=T2x5
-----END PGP SIGNATURE-----

--Signature=_Fri__18_May_2012_12_10_27_+1000_Viv=k+5nLDU3=HRT--
