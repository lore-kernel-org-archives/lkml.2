Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab0LZW6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 17:58:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40163 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab0LZW6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 17:58:22 -0500
Date: Mon, 27 Dec 2010 09:58:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Garzik <jgarzik@redhat.com>, Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Zhangjin <wuzhangjin@gmail.com>, Zhang Le <r0bertz@gentoo.org>,
        Chen Jie <chenj@lemote.com>
Subject: linux-next: build warning after merge of the Linus' tree
Message-Id: <20101227095812.0f727881.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__27_Dec_2010_09_58_12_+1100_t5mYniaBhfYpzPE."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Dec_2010_09_58_12_+1100_t5mYniaBhfYpzPE.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the Linus' tree, today's linux-next build (x86_64 allmodconfi=
g)
produced these warnings:

drivers/ata/pata_cs5536.c:47:1: warning: "rdmsr" redefined
In file included from arch/x86/include/asm/irqflags.h:60,
                 from include/linux/irqflags.h:15,
                 from arch/x86/include/asm/system.h:11,
                 from arch/x86/include/asm/processor.h:17,
                 from include/linux/prefetch.h:14,
                 from include/linux/list.h:7,
                 from include/linux/module.h:9,
                 from drivers/ata/pata_cs5536.c:33:
arch/x86/include/asm/paravirt.h:146:1: warning: this is the location of the=
 previous definition
drivers/ata/pata_cs5536.c:48:1: warning: "wrmsr" redefined
arch/x86/include/asm/paravirt.h:154:1: warning: this is the location of the=
 previous definition

Caused by commit 9272dcc232b84ccb027d6861077934055d42764d ("pata_cs5536:
Add support for non-X86_32 platforms").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__27_Dec_2010_09_58_12_+1100_t5mYniaBhfYpzPE.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNF8iEAAoJEDMEi1NhKgbsS4gIAJQxY29ae59u2xt7O0DjCZsD
JW3Dp+YxFQx11K+UYEroK+YEBmUIslPtIixEyrIQtFWfRVmRJdzWgy2NTtmyWly8
UG0sxIS8IbTEeCK3YZUV9Iic/Ug2y/YMH6ouRxuZ30jH2ADDZ0DHsGbrEKu0hnXS
rXsAVbmy+0Rd4PXjZXzdALgBLG2v2jOXptaqCoV5tHUuDch8cYQoenyAEeIVpD+1
B+1Y5UwmLBWA5WKdPTN7Zaw2CMx1pewX2hRhxeLfyxVnSQvgpKlsEXESE/rMfYLc
JQUdn6B6c5vABJvlWeXn9XggkKZq0CS1iGphfy3H7RY3DYOlSECgX8orYIXFj2U=
=fnK7
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Dec_2010_09_58_12_+1100_t5mYniaBhfYpzPE.--
