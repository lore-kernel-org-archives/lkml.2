Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1EBCS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 22:18:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41961 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab1EBCSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 22:18:24 -0400
Date: Mon, 2 May 2011 12:18:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: linux-next: build warning after merge of the kbuild tree
Message-Id: <20110502121817.645d544e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_May_2011_12_18_17_+1000_jAiTRfpCYlNAUFkN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_May_2011_12_18_17_+1000_jAiTRfpCYlNAUFkN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

After merging the kbuild tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

At top level:
cc1: warning: unrecognized command line option "-Wno-unused-but-set-variabl=
e"

Presumably caused by commit af0e5d565d2f ("kbuild: Disable
-Wunused-but-set-variable for gcc 4.6.0") though I don't see why.  I am
using gcc version 4.4.5.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_May_2011_12_18_17_+1000_jAiTRfpCYlNAUFkN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNvhRpAAoJEDMEi1NhKgbsR84H/2tCqes0QDi/NF8WCSn8PE1N
Nmt0wGxBTTFHwBCNH6yt+yCGXNUCLJAmfXI7oB3SYjcwlOE1hAqftwU+CmNy6e8W
ztWOmBkF8R+09jfMnT/kzYHcp5G1Xnlv0ZXt8XjKIOF3TwXnnuc+O0KoQty8TsTW
lIpggJS1luRSga3XGYJsOTbFx9maejA6Mh5wDDoB0Wr4uzt8iaBwUxl/vZvW6aPw
RxfjZ66/jO2JziwTOd8j20YFNxA3odl5uA7hTK3v4UJRVRZeCYkLrVr9ubyhlckN
TkpB3pgxA5zv7ry/3PFOxYPcJHQNE55r9sX7QVXzHR9TqKplIFC2sQU8+tXmkp8=
=eNkC
-----END PGP SIGNATURE-----

--Signature=_Mon__2_May_2011_12_18_17_+1000_jAiTRfpCYlNAUFkN--
