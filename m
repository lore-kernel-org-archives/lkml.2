Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab1K1ETI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 23:19:08 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:35019 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1K1ETH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 23:19:07 -0500
Date: Mon, 28 Nov 2011 15:18:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: linux-next: manual merge of the staging tree with Linus' tree
Message-Id: <20111128151857.d4ce49d38ed4983f8ba4d68e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Nov_2011_15_18_57_+1100_0AJ=+_imff9LC0yQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Nov_2011_15_18_57_+1100_0AJ=+_imff9LC0yQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/iio/industrialio-core.c between commit aaa0b4f00729
("iio: iio_event_getfd -- fix ev_int build failure") from Linus' tree and
commit f791cec85073 ("Subject: fix build breakage in
drivers/staging/iio/industrialio-core.c") from the staging tree.

The former was a more extensive fix (and is upstream), so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Nov_2011_15_18_57_+1100_0AJ=+_imff9LC0yQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO0wuxAAoJEECxmPOUX5FE3kMP/iY2CukbOQFhjWiyt/QH22ia
10VHtjdTERqRudnEZcbnHOr+rf+jsbW5fdE2vSyelc7mVqDNmlziHevyetqw+Mz4
e27K5RPiphb88gz83hSGzWpjpCgu0OmBLtxDe3X9JoeiYIxpJeF7PbAorDPGvY/A
OWq/zElgru3mHgGGQfwqkkAlvvA6iTnEpCxj4pZZ3AsjRPaYwOLJzZM0kAa4hPfO
gv2ahk2pIjRDQP8XLHCdO/VbO2NRqpZSy5lUhtGNIULZOgInfZ2AZc6HQfNhdvTE
6ynV/xk88/uHu6T2NtF0Jm9cNxZsqqLqw2pKDEKrdoAXludfcSr5yKdjCcFumdiL
KFSj1R0a0nK605/XCzougP4go41Y7VXQ5EcQlPyrzQkWSTBTBlqXwYdycHSTQL4A
d4sdm+NvWAGIwBPeGrHN2sufHAq2Pp0S4WFlL0j2iIxVagnWL2HrA6UzRvFaQCCB
tf0HtdTC5JESHA0TgPJorRsbLGmRVllSaMZbmKeAn1VfS+ER2CcPOU7QmZ4y6Rn6
KEpefjTIz0AsVgo3zK7ZiLH7hwInztB8RTUOsXW4xQauCe+/DrgOLCkslbDba3uw
omVn13yHGqJPqJdTZ5yxMQ7HfBNtflfGYIGkrySsBBNrALaWXUJzrLL99mWjeVIq
bQhl9KIjnE20OV3n6hVl
=fd7d
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Nov_2011_15_18_57_+1100_0AJ=+_imff9LC0yQ--
