Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab2IXF2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 01:28:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50500 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab2IXF2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 01:28:08 -0400
Date: Mon, 24 Sep 2012 15:27:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaun Ruffell <sruffell@digium.com>
Subject: linux-next: manual merge of the edac tree with Linus' tree
Message-Id: <20120924152757.eee2b749725e6bc08f7e7d4f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_15_27_57_+1000_dOywbGvd8WosKXs7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_15_27_57_+1000_dOywbGvd8WosKXs7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the edac tree got a conflict in drivers/edac/ed=
ac_mc.c between commit faa2ad09c01c ("edac_mc: edac_mc_free() cannot assume=
 mem_ctl_info is registered in sysfs") from Linus' tree and commit 12c3ab94=
22cc ("edac: edac_mc_free() cannot assume mem_ctl_info is registered in sys=
fs") from the edac tree.

Two versions of the same patch. I just used the version from the edac
tree and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Sep_2012_15_27_57_+1000_dOywbGvd8WosKXs7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQX+9dAAoJEECxmPOUX5FEte4P+gKYTsrjBg7MenncZNDzJcCB
pyX3lQrcZhkAvxKvb6d0w8SQGNT19xKb673oiUY3dYIyz5Ln9g/0CPAoOxydHex0
QW/o8WLtrsbstQHBuN8JQAQh7E1MVUCnETI9BfDnKmrhFHAdD25rQeWHJDuKSdBd
B101G7pTpuFHNTYYTT3TRqyP544xzMCbpiGsHJPLb90D+SjyN66Hn+J7h+PrR6f4
mp97RrYK58oEh73n+m0Vo7bbxIAHaW+o+NwSJwr82XfV+iN52Tfi5c6jcHO2Zq6R
xoviLkq8XgSqdUraezzm/YEq7qbfh1GQLUnaZJmGSxpk5XilECN/4wJdYbWHGIcq
aqiOKXS8N1SexC3OFTzu8HBCyH3pI5sojgGagOPiafKnkwnIzP0Q6E6/XcAuc3z0
vUolHR/JMN8TAvo1j70wbjyQ5OBRxnarBnwAoKjwxP6whzqM1oqV1ponM/h5D/ji
hNh6fS0VJsHOZ1m9dkz18rVjREcE3sJ7JZeJcGybHIual+jadIhPqFkJVRgCecmG
5qwl4wKYmh+jwqIhjavBdtF1V7DNMayFTP6Gp5Cx1CijNw6g6W/ooaQDW4ye27L3
ePy+PogF4lsHcdCIJrUmyIsp8vX+Gl2tqsRYzTlDFlH7Cui1BA7UbZiqJTmlHsQt
XYyRLXR3aF4a99zQz81q
=GPYe
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_15_27_57_+1000_dOywbGvd8WosKXs7--
