Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab2AKCiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 21:38:12 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:52321 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901Ab2AKCiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 21:38:10 -0500
Date: Wed, 11 Jan 2012 13:38:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: linux-next: manual merge of the l2-mtd tree with Linus' tree
Message-Id: <20120111133803.e7033fe7c4250df71b14ba3f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Jan_2012_13_38_03_+1100_DRFWdL2jPSWWtCQU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Jan_2012_13_38_03_+1100_DRFWdL2jPSWWtCQU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
fs/jffs2/erase.c between commit 10934478e44d ("mtd: do use mtd->point
directly") from Linus' tree and commit aa64d929dfae ("jffs2: do not
initialize variable unnecessarily") from the l2-mtd tree.

The commit from Linus' tree above is also in the l2-mtd tree.  This is
because the l2-mtd tree commits were (at least partially) rebased before
being merged into Linus' tree.

I just used the l2-mtd tree version.  But this tree needs cleaning up to
represent what was actually merged upstream.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__11_Jan_2012_13_38_03_+1100_DRFWdL2jPSWWtCQU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPDPYLAAoJEECxmPOUX5FEGtAP/A7p0+aYIp+scv10oVIZIHix
TqyHU3/cWx5IypSYUATXMJF1/bGYvUvjsVCHYBCpsUV3VClN4uR1NfOe02bxAILj
KhMEp5xDwQtWFaIgCrrmRydCB56xToOSDPxuWYktoT4jSjiji/dpNkrkCHjOzDzv
I1Qa3osPc9zprKRB3709NcEu6CpCsSYg5lwEPi2yqwSxvPFkGvDfYsiNuC9sKnX3
cIdLbF7NEmV+RcYQ3tTF8q+k1ky7ATWnVHZ08HHrTbqAXabsmfaM7nLx0rSwQgXU
5WQvMCDOT/g4kPhLYfdMTQpI8aWZ6HYA0JrAH64YGv8ri/zcwShPllli5x3V4p8p
2Jr9n8fEukNfywtwY24025Bob2RGBIHSK+t4eWDC4q5YIzwsTP0gN6i/k+4QUNcV
htGo8LS/NvuWt//FBT17tsrCV07g5QJ0ChNS44Mty+TULzajZBjQ1C9IPM1aGPz8
kvErzJZqSdIgsypLODA5Q/YOJy6e1yNcTdCdNMSL14TMWb+BIDxPtS7vDzOSg6Z7
eul9p8ytQ5gX28jexF0R3Rg56QxzJhHEczA5HMBb4++Oq6uWuY4KTXvGnNh+YJ78
nDKWBa8IyEO1JSRIiJhe29BCjAsWCoJzVIBYYgflvtKuLcu/oysmqEYRXSZgemCS
DGOdA2Wp4i1F5KJ0MiQ0
=DZUK
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Jan_2012_13_38_03_+1100_DRFWdL2jPSWWtCQU--
