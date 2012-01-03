Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2ACXsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 18:48:12 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:57714 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab2ACXsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 18:48:08 -0500
Date: Wed, 4 Jan 2012 10:47:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: interesting merges in the arm-soc tree
Message-Id: <20120104104758.26b0ca5268d10fbf7b95903a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__4_Jan_2012_10_47_58_+1100_jktLaPMR=U3BCjtO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Jan_2012_10_47_58_+1100_jktLaPMR=U3BCjtO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I noticed that the arm-soc tree has merged in the v4l-dvb and the
slave-dma trees today.   Is there some good reason for this?  It fixes a
few conflicts (but that is not excuse) and there may be dependencies in a
driver on the v4l-dvb tree (but maybe that means that that driver should
be merged via the v4l-dvb tree - it looks like the "at91/drivers" is
based on the v4l-dvb tree, so probably doesn't depend on anything else on
the arm-soc tree).

If nothing else, are you sure that neither of those merged trees will
rebase?  You have also just inherited any bugs in those two trees.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__4_Jan_2012_10_47_58_+1100_jktLaPMR=U3BCjtO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPA5OuAAoJEECxmPOUX5FEjAsP/0dB+ttTN81m/mlPYltcB0jr
z5peh+rtbi7UugLmbOdFBXF2r2Kl5YJaF3j6MjYZH5CJKriobyNZy4V2CVFZVXLQ
fhfiw6wrtNGz4onNMYVLaYZdlA++jAsLPChoh8kuspUBu0FK8qDE/3jxnKC8w4ob
Kzab49QBlj9mGiEwJAbEHf5DNhWOkFASg4ycvnd3iT+ZJSaZ8mUnZnKExeyhRwB+
JZJPkevtnVKlfbQhzKXp/JlzVNRe2qKX7LOFEHxjFjLHy3aZ99qjh21USCvV9pXJ
ms9B56+QgRkk8oNoaQHyRCDUu9J7kfowQQgTht38t7DK+gdjfmwITGVogxzxPdYa
6R/b9fEvdtAhqc+BMJedavJwFJZQGAO3CW81COkP80H+qtRKKOu+TN716KQFUtbT
ArcyMAx0kdYtunjeqi8hQUnV8pw5GwxrOMLxsErrG2JW9wyUJfuRuKdbIr3HagLP
1AEdnfNkAeBptWx8VbARYPmZNDOF8uz/0lN0G4tmRXzgJ+9PySVZrDpnw8dhUYAQ
yp6MHkz8PhbjDaZT3nL24D58Wq0VPd7HxDlz/MjQHVkjg320WwVseG2/kuemCP0Q
1XHbLpMout74+ru2rbP9QvRlX2FB0ezMvXG80Yv3AW5IZgj7JL4V+rxnD0tsjl2t
hsgbyGKNrnEzp6gH7tik
=oz5o
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Jan_2012_10_47_58_+1100_jktLaPMR=U3BCjtO--
