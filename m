Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab1DHFC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 01:02:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42033 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab1DHFC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 01:02:27 -0400
Date: Fri, 8 Apr 2011 15:02:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        John Stultz <johnstul@us.ibm.com>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20110408150214.78bc7871.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Apr_2011_15_02_14_+1000_8EwwBI+MywoliMIk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Apr_2011_15_02_14_+1000_8EwwBI+MywoliMIk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/ia64/kernel/cyclone.c between commit 25985edcedea ("Fix common
misspellings") from Linus' tree and commit d60c3041778c ("ia64: convert
to clocksource_register_hz/khz") from the tip tree.

The latter removes the line modified by the former, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Apr_2011_15_02_14_+1000_8EwwBI+MywoliMIk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNnpbWAAoJEDMEi1NhKgbsvR8H/j6RmJl7AWVnZim8j2psi0he
w4bAMHG7wRagZzNBDpWe0wvIUjkoTIe0Ikfvsc57qQg7rSmVeFTSjU6SeizHcKqo
JCY0dSMQdYG8S3OquGH5P439umQ2gCSoKqMZGz3o5b6/3pmLz48ctEinLmDmPBK5
9cJnMtHvzGl9/AzSl/Int+3saxj7HMJMJLV/YytJVujWb+Z4GMI1ERYULja+UNX2
4mbar3kywpKKGkRPTGV/vMQ4Ql1e1iPq/qczcoIqZ9GT8RSKeMqcV7cSrhEncrA1
F6QWwVZBVSuQJqPi/u9XR3p533bfOhWSRa81yyvfiqT89F6ny139NwnyGPPLh2c=
=Yotl
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Apr_2011_15_02_14_+1000_8EwwBI+MywoliMIk--
