Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab0INAvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 20:51:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52135 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0INAvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 20:51:41 -0400
Date: Tue, 14 Sep 2010 10:51:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: linux-next: manual merge of the m68knommu tree with the m68k tree
Message-Id: <20100914105129.02eb5b13.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Sep_2010_10_51_29_+1000_LgIbFItBR.4UAXxe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Sep_2010_10_51_29_+1000_LgIbFItBR.4UAXxe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the m68knommu tree got a conflict in
arch/m68k/sun3/sun3ints.c between commit
72fe185cd9acbfc6e8a7afa884ae1152be706e52 ("m68k/m68knommu: Remove dead
SMP config option") from the m68k tree and commit
5313b581e4efc214c6132d32f580db6668e5c5a8 ("arch/m68k{,nommu}: Removing
dead SMP config option") from the m68knommu tree.

These appear to be the same patch with some formatting differences.  I
used the version from the m68k tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Sep_2010_10_51_29_+1000_LgIbFItBR.4UAXxe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMjscRAAoJEDMEi1NhKgbsGRMH/0x/HAYtv9qnNaFpdq4ljapS
Vtd1sEd3HfF6xBs5z0CmeHAiPs7X0EX9f3ji2DC2mZ6ti0LwfsJrVlOtspPguwdR
ARNfJsyzZ4BXiYLrev43/VWWCpqu6TWPhrnQ887SaCcmJtctX9bVv12xO/eYlRRL
6BfGkoN0v2q/F3MPbaBByd7xSXNSkUHXPhEh5ASmDYh76RyBIiMdNDDgdj7YYixS
049ujvmxmt35XBlfIGczqr53Bm0snLmKqNdKWMq2rfpIoqQSLSBYAnWXy8sYl05A
93PuaKrISd228dbdBCwOjpFOdjwLxJ6fI7CSL/x6fSvILa3svoW/eatlu1CrfRs=
=XzA0
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Sep_2010_10_51_29_+1000_LgIbFItBR.4UAXxe--
