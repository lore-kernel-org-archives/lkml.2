Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab2DSFOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 01:14:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58740 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2DSFOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 01:14:15 -0400
Date: Thu, 19 Apr 2012 15:14:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anatolij Gustschin <agust@denx.de>,
        Ramneek Mehresh <ramneek.mehresh@freescale.com>
Subject: linux-next: manual merge of the usb tree with the usb.current tree
Message-Id: <20120419151402.6f958fabc6bd96696b4cde3c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Apr_2012_15_14_02_+1000_2v_KOquA2/S8ZqVp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Apr_2012_15_14_02_+1000_2v_KOquA2/S8ZqVp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/host/ehci-fsl.c between commit f941f6922533 ("USB: ehci-fsl:
Fix kernel crash on mpc5121e") from the usb.current tree and commit
58c559e6509f ("fsl/usb: Add controller version based ULPI and UTMI phy
support") from the usb tree.

I fixed it up (using the pdata assignment from the latter commit) and
can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__19_Apr_2012_15_14_02_+1000_2v_KOquA2/S8ZqVp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPj58aAAoJEECxmPOUX5FERc8QAILFDgUcy3RHSlvzzqMkLTs4
xG6dXfUGHo2xzttTGUOi2TuEJqRR3XzQIkITbio7yooBhCAlb5AFM0/peoOTX9Fk
VPmtk9jilAGxeD5Ib0EC6Tw+gOWYCiZiRKWkUrxa71i/1jTG5Zr10CKfJACjwai5
iFkPXLR59tFAmAAMJjIc3HpghqhG+wvbmMitg/3h/OmBTsrqpS7GP/TuSUTU1wXt
e625YpyhyHftSk8xACUn8EDmQC1ekXAey/S7Ox7DQqrEwi4NRtKukFPW/KOt9p+K
Mrn1p7HA8gUIB20wogjhSPEwQFIpofgRWfcE6ThzZEXjiP2fVi15zNI7INin4FZ/
jwnj4hrXhdiGSUUoWebnStMi1VajvKv7OResg2ZvGWK8Chb0hBGG9v1o3o3l3QDG
ZVBh3y2hA+Fh6+vBVypH40i2ObdSI+rz7yP1OJDRYxbaHAfR/1YBygkxwOhKqUiq
8z7NzRgNFpC025fxYDi6i7v0YTkF6+OAVlYc1Db1SItu4296F0txvUemt8XyP2Hp
STyhmfqbVYuoQjIcQsWH2Sjz8Uq/Nt8uLU1V6v/HFa2U+EiR7qQTEmEm6A9suKh3
DPx09Hy/d94TcFr7e1ZRQmn0LjsvJEs4z4isNIQOHvYQrxpEt66D82BvrunYuur2
gMKoODN4tE4qr2qiQ0sH
=OGLd
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Apr_2012_15_14_02_+1000_2v_KOquA2/S8ZqVp--
