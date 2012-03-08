Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab2CHG20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:28:26 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39199 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2CHG2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:28:23 -0500
Date: Thu, 8 Mar 2012 17:28:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Drake <dsd@laptop.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120308172808.6b611b842fba4e77fb8271bb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_17_28_08_+1100_MIR6rtEzPDTLAdYT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_17_28_08_+1100_MIR6rtEzPDTLAdYT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/platform/olpc/olpc-xo15-sci.c between commit d1f42e314c9c
("x86/olpc/xo15/sci: Enable lid close wakeup control") from the tip tree
and commit "x86, olpc-xo15-sci: enable lid close wakeup control through
sysfs" from the akpm tree.

I assume that these were meant to be the same patch, so I dropped the one
from the akpm tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_Mar_2012_17_28_08_+1100_MIR6rtEzPDTLAdYT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWFF4AAoJEECxmPOUX5FEHwEP/i7R3rtEBT7IxuIgkXwEG4oJ
1MnzVbCoBxZBBk/nH4JCxB8ntaqDcrW6LQgAAuG2UCb6gZOk4m5crTt0xi1RWEDJ
s6TdlgoBA80L+vxWUnt8mKYfmwbzLqKjD2FSPH21b4RsfausZwKtr5cNy1r61hCC
h18FL0ehi5JFcab1EVO0Yqu63unKzbMsPBmh2kBq69KByMoy7ZKmVkQCyk0kEJSz
wyQPwxLdtdLSHgiAL4unwL32gtzysi8i5a6G1ZvLlEsNxtoDJE18sNlpHarGEDLQ
2/LEpJWiY1DTxQGSD2peYrPJe59UBS+WPQNkhKQxFYwASybAo4SsTZGVqE8iAUgg
rEs/0syKkqscyZHnwCeC6huYiFnX2zCzF+sh4f4ueWIBUGTjjuM71EmCHmcSnm+h
yS19mx6kU/jqOs7fHyUtjfh+GgHLluEP8rOUwyHAqRda9QKHadiDTCY0oCuK73uq
CgjZSFUsXtJuv631QKGe6eFLm8mu9RsDRSuzrZcTF3onjjQCXinjp9LJnI+7/wOE
5McRDwH2YBieRJ6LgYTm/RyKUWdT9ZN4y/fqmQWSNbio+sIe0p8IhwHzurjSZpYd
Js2Z4aT7gA9EjrEey/AtvqbZwvsNtp+128L84qileDrzWPYIx7i2ywilxPseENBC
ApXWUUxw0qPU6jzHd5Fn
=1KQz
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_17_28_08_+1100_MIR6rtEzPDTLAdYT--
