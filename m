Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2LUCme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:42:34 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40480 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab2LUCmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:42:22 -0500
Date: Fri, 21 Dec 2012 13:42:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the signal tree with Linus' tree
Message-Id: <20121221134220.b351b922d3eab17b8e436b09@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Dec_2012_13_42_20_+1100_2feadVfYRKeSv+ox"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Dec_2012_13_42_20_+1100_2feadVfYRKeSv+ox
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/h8300/include/asm/signal.h between commit 1ec94e75def5 ("UAPI:
(Scripted) Disintegrate arch/h8300/include/asm") from Linus' tree and
commit 031b6566983a ("unify SS_ONSTACK/SS_DISABLE definitions") from the
signal tree.

I just used the former version, but removed the SS_* constants from the
uap version of the include files as well and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__21_Dec_2012_13_42_20_+1100_2feadVfYRKeSv+ox
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ08yMAAoJEECxmPOUX5FE4vkP/A0YHQQj9XZBEJvFe5eUi0HD
rAvD1BExTDEvsHFdE6ydIbjvp8zhibR2Ecwk+UVDnA0ZXVnjf6W1UkCbqxSiv5oz
QhcGGkdlcoxoQLldPaszlgKqy26a8lAMAHEGhSYNUtQgy91e7UK5+HkmCJF13BS1
3Q4Lh1/GkKza+JhPoniia6fnKNihT2oY4lHbuHtZOAs/enSrgpmwWlg2eBr1x8p5
eq9R1xv1nSFmrmbIUvcBnFLd+8iBrrUI1QBMsVBMpuZ53h4gFUj6wdLfNGrhTKdX
xsZebAXVt7swd3t/NSohxkddKLTLVbU7CfbZbqWTwX0ns6fgVUbDTZSfcqwx/E81
f6C1VlYTiTnBFN9yuhFqK0hJoKpGy8+xfm5Dwc2oOQsWKe3xV2D5efMYKP6G/uzt
BrT4J7DdRS6+PjzD0Zmw7AOAfNfykwcGkM++f94vBGSQQCsJkD+7Rs/p8RFtGwLW
9nPgsz8VYS83e94fP9ywoentsodlsA9ad0XZDffAUh/dmY/d3lc5pl8QUEfxjGRP
q7de6y6CV63M3wWQ/tZW0FyGMGTrywTePjuh9flIiZZ0mUxCtayldtek8vbFvUaw
KjvZlYp9p1qC6Yy1kkHTovbuxndSGsbT65YtpPDxa0sxh/STdP8X/jVyIV9Hiuei
1c1S7CahwgGYPyHHMkpU
=+a29
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Dec_2012_13_42_20_+1100_2feadVfYRKeSv+ox--
