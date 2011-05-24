Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab1EXDlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:41:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47390 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757011Ab1EXDlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:41:49 -0400
Date: Tue, 24 May 2011 13:41:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mandeep Singh Baines <msb@chromium.org>, Ingo Molnar <mingo@elte.hu>
Subject: linux-next: build warning in Lunus' tree
Message-Id: <20110524134129.8da27016.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_May_2011_13_41_29_+1000_+WiRM2v/H2dMuNO0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_May_2011_13_41_29_+1000_+WiRM2v/H2dMuNO0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

In Linus' tree, today's linux-next build (sparc64 defconfig)
produced this warning:

kernel/watchdog.c:102: warning: function declaration isn't a prototype

Introduced by commit 4eec42f39204 ("watchdog: Change the default timeout
and configure nmi watchdog period based").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_May_2011_13_41_29_+1000_+WiRM2v/H2dMuNO0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN2yjpAAoJEDMEi1NhKgbs0dsH/31Yti5QbaWV4PlYrLgnY58g
b/siwNKbfMv9SPUCOAKxVMcqcveMiBGLJJswlWp5WBJ6mM4blgnjDb26G7egjcoj
U8Uo9xRXdtpSUZ+Ku2fWeuDuoNFCBuaFea2Wty16eQxYz0CE3w2ljEA29AvVZ91D
8LCNAXSfLgh4p50kxtnicIZN8ana54DVyOWL7LYEmI0X7MpkMDnntmrbvuzJzEdh
sAa6g78T1AkzdHW7ZB33Jdzi57QElWOo7103ODyMyFdx/Vk5wCz3h9jes8W4QBhW
ntsedyAJ9Mrd+Xwx+m2fF7BLvVA9tkdmDjikD0dsWkIYEVBeuEwbZr9PsCsEU9Y=
=gYJZ
-----END PGP SIGNATURE-----

--Signature=_Tue__24_May_2011_13_41_29_+1000_+WiRM2v/H2dMuNO0--
