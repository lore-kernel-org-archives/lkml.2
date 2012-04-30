Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab2D3EFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 00:05:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59306 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2D3EFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 00:05:36 -0400
Date: Mon, 30 Apr 2012 14:05:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the hid tree
Message-Id: <20120430140523.bdb69a1c0e7d23522a5759d7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__30_Apr_2012_14_05_23_+1000_pTZoXsZ08AjHoak2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_Apr_2012_14_05_23_+1000_pTZoXsZ08AjHoak2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

After merging the hid tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

In file included from drivers/hid/hid-core.c:37:0:
include/linux/hidraw.h: In function 'hidraw_report_event':
include/linux/hidraw.h:85:46: warning: no return statement in function retu=
rning non-void [-Wreturn-type]

Introduced by commit b6787242f327 ("HID: hidraw: add proper error
handling to raw event reporting").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__30_Apr_2012_14_05_23_+1000_pTZoXsZ08AjHoak2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPng+DAAoJEECxmPOUX5FEYMkP/1PyelvRsrJ60VeqFopVZai9
pK3q7R9Go7abZPhGsL5J7uqkQrF0KhoQCLA73MwDS/JsN/oPcxaVb1m6SOXZZgkc
GNLyofmBkaqu3cpfiefpSNldJ8W3+R2ojIHpDpNeljTwVwkOMoFs8MXmMlsp1Sos
3w/EPEuD9IiuFQ1MLmCN+byLCs8VHpmEyzH+GRncABJwVf+D2By2KFaMKQ7bFd20
OFrTarxOJZpBKq70JpIK1b06EWClQVutF/jDtqc4J2YDtFz06fY1KZk7uPoMtroU
4TiODuEWp9jOuPSTzSDVyX938E5UOz/Owsij+WXUD32k4+clcbZcBYokgaYpId+n
2MtAB0FyjEKnRPqq+YT4lQzBGr0iZYsnN+sx/8jcko8O4BMZ8IGbTc2PK3qHqpKj
su1xrlbgh88M9zuqKcpUrQGNLl663K3u+mSvhbePO468THY++zrIeHa9NnjHYYxr
8Q4rrhR9djnRbNwl0Kg0zoC1/6uU7m5UeKvaqb/DE4BsyiBdJqcEv76SUXefIHEF
1M0IYmwSvWOfGLTWHfGTx+viTeQICUp96KmuHQY2NPbcXb/BZlxlysbVqj4hw9TL
3UMZEhpShtSZghfAAEVC8bApvYXKSMrCOOl0cxeTfyYdF+fFpgwfzljTmQJGF7t/
BoEKsLA4F5uDLrXTYjTq
=sEKr
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Apr_2012_14_05_23_+1000_pTZoXsZ08AjHoak2--
