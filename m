Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1HKDLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 23:11:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53169 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab1HKDLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 23:11:42 -0400
Date: Thu, 11 Aug 2011 13:11:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20110811131129.f0d6226079d86e8f4a5ae920@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Aug_2011_13_11_29_+1000_uHLsX+uK_.xNv39B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Aug_2011_13_11_29_+1000_uHLsX+uK_.xNv39B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

sound/soc/codecs/snd-soc-wm8750: struct spi_device_id is 40 bytes.  The las=
t of 2 is:
0x77 0x6d 0x38 0x39 0x38 0x37 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 =
0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 =
0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00=20
FATAL: sound/soc/codecs/snd-soc-wm8750: struct spi_device_id is not termina=
ted with a NULL entry!

Caused by commit 40045a85df0e ("ASoC: Fix SPI driver binding for WM8987").

I have used the sound-asoc tree from next-20110809 again for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Aug_2011_13_11_29_+1000_uHLsX+uK_.xNv39B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOQ0hhAAoJEDMEi1NhKgbsHy8H+QG0O92tms5Kysc8RWH9W/zM
9Ov/LspxMnmZFrfJqUy0UFCcZhPxPgEZK08rMSuow6kgHcIY3nruV8u5TeA8HQZ+
OO49UfsS4x+gcCp2jO4H0fJer0JM601gbK+Fuj9XBXtz6WpwKwccjdmyMBND6Kgf
jGayRQpdoE15Vnd9TuoZunmeu/bEQgN+o7TBdHpZC6GMnzhVVflZygOS169k32uO
aWL3TH4xCDMmiRQ4RthmlwV74tYJoe5zQwrLOkx7psbDS36ONi7loRs9ibsd+6d9
4dvwPCkmlx1DBRFBhSTuds4MZXhC4qhIneLELoE0OAtzfJyU21TDlf+KnxFYp7E=
=C+DH
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Aug_2011_13_11_29_+1000_uHLsX+uK_.xNv39B--
