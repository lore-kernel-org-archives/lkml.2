Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961Ab2ACFId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 00:08:33 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:48899 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2ACFIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 00:08:32 -0500
Date: Tue, 3 Jan 2012 16:08:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20120103160813.d2a8575c1de3bad0acd42280@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jan_2012_16_08_13_+1100_qY/sm+ajoi_8FaXt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jan_2012_16_08_13_+1100_qY/sm+ajoi_8FaXt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in kernel/futex.c
between commit e6780f7243ed ("futex: Fix uninterruptible loop due to
gate_area") from the  tree and commit ab69f41ef93d ("futex: Fix
uninterruptible loop due to gate_area") from the tip tree.

OK, so these appear to be 2 different versions of the same fix.  I cannot
figure out which to use, so I just used the version from the tip
tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__3_Jan_2012_16_08_13_+1100_qY/sm+ajoi_8FaXt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPAo09AAoJEECxmPOUX5FEBAAP/0hlN7aW5Iz489LTKNAhfZhm
DcIe3/QFBrNEXYjLRPA/mgQL11CLQ75+lk4xywbR54pXMuDwQuVDmwowbTsmtKQ4
isumLVYxW4S109oLUpe6XG0uKJE+oCO1BvPOVAnWZn9nIW1wR/U8xkbil56tJZRk
e13eIDYAoDbar1S9wc48jqtGzPu5GfiaCE+KeX/S08qcZmYek/RsCdEnN3gyyHFZ
IwDZgUyOR4hpr/66+rfsz0Z6fUPnesvft4wbzcM/6xwG3KAtnJ9HddWrX1MIRGrv
ThWEz9jbv77tztbe9zaKcj3AiuClPwAOsh5OI+CAdU/zKKeqA5Pv3TjIMjML4/51
UqdNB1wilHSi/CVpzczc5peUHbX96ebw3ylSA4UCOQYqXBjqSBnLQvmZWTyr+TFN
JRxEBdsMBaWH6yCuMdLVkA7nIl5+KWBfnFP/8u1e7siFwNPoWx/3/kOhtr8L21iF
/cecQyhtWN2PfvTrhJjIfsq9rRzuAOfIwpITAcnoDKnU2dMrsbgOYEvOqjAQtmPa
+d0nocrSapWm9snZ/rjKGrpeoUlLffFAzyQPOGVJ2jXxzg9CpwEzmQC6Qev+1IGp
YSWrchVzbOTAOyzYK6ne76QsSWrS7wOteJTFVpGkwMG2ZzLEkJLiBjF3LhJEQJmh
WESdSFifHvrw2nqG80yq
=qqu6
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jan_2012_16_08_13_+1100_qY/sm+ajoi_8FaXt--
