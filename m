Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab0IPFJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 01:09:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56156 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab0IPFJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 01:09:52 -0400
Date: Thu, 16 Sep 2010 15:09:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the final tree (sound tree
 related)
Message-Id: <20100916150948.cc9ebed8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Sep_2010_15_09_48_+1000_8Km+uXsqHjd8lRJ2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Sep_2010_15_09_48_+1000_8Km+uXsqHjd8lRJ2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) produced this warning:

sound/pci/hda/patch_conexant.c: In function 'cx_auto_parse_beep':
sound/pci/hda/patch_conexant.c:3565: warning: unused variable 'spec'

Introduced by commit 05f7349fc754f20cf92009934498d92435518141 ("ALSA: hda
- Preliminary support for new Conexant audio codecs").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Sep_2010_15_09_48_+1000_8Km+uXsqHjd8lRJ2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkaacAAoJEDMEi1NhKgbsOGwH/0wuhEoGaX1L6tGb2PF4Rosc
tfOZOscGACYgOpcqnnf52ka8FOA+8S8TqcvC3zHA8vAULDw9uH3fble0fY5UgWn6
G+GTCQg3R6/xODsZuYXSre0Jg0lhVTQxP74lTZv2UB43FHDyvaKl5nl3wv8UYS7O
6YK9VM9rbAzeHhcci1gPFxUhV19BopaNfZ068lwGfXrIo7/ndBfkqasi/nhAK22B
fdwL7sf5LoNUd2FdvMdCgMyUif6u0hdN/WhstDkpuJCr1Uj5cCfbSKBHuCDcluT4
j7Cr3SOxKmxV75ftWN7nhri7nqPo69O83n2u53dm4GVsaZEoVKneO08322gnpJU=
=mzQF
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Sep_2010_15_09_48_+1000_8Km+uXsqHjd8lRJ2--
