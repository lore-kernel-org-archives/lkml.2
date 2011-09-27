Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab1I0EX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 00:23:29 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:49093 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1I0EX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 00:23:27 -0400
Date: Tue, 27 Sep 2011 14:23:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the trivial tree with the v4l-dvb tree
Message-Id: <20110927142320.d0d8001ba975f88311855110@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Sep_2011_14_23_20_+1000_NKxlsMRJE4s47YF3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Sep_2011_14_23_20_+1000_NKxlsMRJE4s47YF3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/media/video/s5p-fimc/fimc-capture.c between commit 2319c539e39b
("[media] s5p-fimc: Remove sensor management code from FIMC capture
driver") from the v4l-dvb tree and commit 18df7b82e25c ("treewide:
Correct spelling of successfully in comments") from the trivial tree.

The former removed the code that the latter modified.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Sep_2011_14_23_20_+1000_NKxlsMRJE4s47YF3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOgU+4AAoJEDMEi1NhKgbs6oUH/0w1xiIe26OhjcQXZbS0XmXq
/LJLIGyA1JiyngJN1D1kQsaTmSSHvfmbeIikp+6oCBEnHW0L+5UkxWQ82tlkY/f6
54sPQUep5f8hmVwoGiOvCYv+fQIM6QffO0XvGH2EK73oNxxjqPOPRN8UNMt7eAxt
FVAj2KMoUV3MD1yaajUw/rkn2uZ9K5HmI9RfsYnLIZCiU5nARto1fcFKLtHmu6K5
QH1NmX3lHW0puTgtGOJJo77UW5k5KRUMneKwFDf+07zJHxEE8aPfbetDBGWyR/mh
IwcJhUnPAHTQYzdZF4M5rNtwH6uawQWg3ubTXJGzlsqXbTYag1dxcqHCcUB6evU=
=pF+L
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Sep_2011_14_23_20_+1000_NKxlsMRJE4s47YF3--
