Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab0FWQUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 12:20:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57782 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab0FWQUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:20:01 -0400
Date: Thu, 24 Jun 2010 02:19:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20100624021949.62910287.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Jun_2010_02_19_49_+1000_2nh7gepX9KZqOLG3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Jun_2010_02_19_49_+1000_2nh7gepX9KZqOLG3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, the next-20100616 and later linux-next
builds for most arm configs (including versatile_defconfig) failed like thi=
s:

In file included from include/linux/module.h:23,
                 from include/linux/device.h:23,
                 from include/linux/dma-mapping.h:4,
                 from arch/arm/kernel/asm-offsets.c:15:
include/trace/events/module.h:11: error: two or more data types in declarat=
ion=20

Reverting commit f0028612a8ffedcdafa8b7ae83ab090d8b0318b4 ("ARM: 6171/1:
module - simplify unwind table handling") (and
cecaa4c6b8173b02c9f7ecfdbbc81f573a7a9f33 ("ARM: 6172/1: module -
additional unwind tables for exit/devexit sections") that depends on it)
fixes this build error.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Jun_2010_02_19_49_+1000_2nh7gepX9KZqOLG3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwiNCUACgkQjjKRsyhoI8yOuQCgikZyNrxbN3xIuCvmkyAq0len
DbYAn3DpCPg6Jwc/4Qi5S5aSHq55dpAl
=01xo
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Jun_2010_02_19_49_+1000_2nh7gepX9KZqOLG3--
