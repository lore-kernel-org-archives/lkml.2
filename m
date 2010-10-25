Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab0JYA5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 20:57:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50306 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab0JYA5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 20:57:44 -0400
Date: Mon, 25 Oct 2010 11:57:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: linux-next: build warning in Linus'  tree
Message-Id: <20101025115736.41d51abe.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Oct_2010_11_57_36_+1100_3iFMZMEu2KZkR6yS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Oct_2010_11_57_36_+1100_3iFMZMEu2KZkR6yS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

In building Linus' tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

arch/x86/oprofile/op_model_amd.c: In function 'ibs_eilvt_valid':
arch/x86/oprofile/op_model_amd.c:289: warning: 'offset' may be used uniniti=
alized in this function

.. and indeed it may be.

Introduced by commit 27afdf2008da0b8878a73e32e4eb12381b84e224 ("apic,
x86: Use BIOS settings for IBS and MCE threshold interrupt LVT
offsets").  Sorry I missed this earlier.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Oct_2010_11_57_36_+1100_3iFMZMEu2KZkR6yS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxNYAAAoJEDMEi1NhKgbsii8H/312EH1YIQzFKxRIBjSveIhB
DRMPaLrsEXAPSCFgkYFTZpXVoVmmMHsYnchwejpl9XhjDwNGAp0HBLVGaXe6pFqJ
AMHVdt1JVnuDnk3oW6cxKpoKqGHEbwPXEIsyl1Kp7aSSjDlLj3bxrxgbUf6qfAAH
GsCF0Zn366cIVwsnn/dWRun+4ZDxcBLQmDRg/aMXEIdOcos3bY56UdJY857Kx9TR
X8fTIYKDw7TSkUS7zeSplTTgfxWfpzIepFLDPboXePYj2LNu9aZ0Gh+5P7++amd2
vxiMsl0zTrODczExSHkUDJU0liCqLXazricXTvSfddiJ9wG+unShdp8cbnO1X1g=
=tHqI
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Oct_2010_11_57_36_+1100_3iFMZMEu2KZkR6yS--
