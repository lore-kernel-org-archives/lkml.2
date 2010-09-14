Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0INCyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 22:54:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54623 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab0INCyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 22:54:37 -0400
Date: Tue, 14 Sep 2010 12:54:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: linux-next: build failure after merge of the usb tree
Message-Id: <20100914125431.1603ffd1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Sep_2010_12_54_31_+1000_iF8kh3ztcdZ5Yis."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Sep_2010_12_54_31_+1000_iF8kh3ztcdZ5Yis.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

In file included from drivers/usb/gadget/ether.c:123:
drivers/usb/gadget/rndis.c: In function 'rndis_init':
drivers/usb/gadget/rndis.c:1163: error: expected ';' before 'if'

Caused by commit c8feb3bad134f927a624cc19da13f57627b905e2 ("USB: gadget:
rndis: fix up coding style issues in the file").

I used the version of the usb tree from next-20100913 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Sep_2010_12_54_31_+1000_iF8kh3ztcdZ5Yis.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMjuPnAAoJEDMEi1NhKgbsuf8H/A8/LQkfgLRWwXz8QqaQQUOi
PngsW5RZ23aX+Y6jq7XfccSWArrOLquKihDYcwF/rBZcNHKO4NFQ2/ALfPzTa1vJ
pr9iOV56KkQWDdZ/2iuMEb5gj3MQjsMsD4rdSttmc0cAiuzYYxKbKmLE/aAYrgg9
GjRXqzIjN3iTzMfrXg8pQkfqkfCJAuukqXtjJivhoBGnHnQag98NCxwx6IQoM16N
mYJE9N4WPhXsyk1ap7hPPHvG7erYbI5cDNm5A5SbnZgiu/MtMCEWLhocz80h9JQx
oSfapSkFRLVzLMpGshJTwdAf6dCs54ktrA5Sf4wFZxgf0FXRGWsGwrMsyPcBoK8=
=//Xp
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Sep_2010_12_54_31_+1000_iF8kh3ztcdZ5Yis.--
