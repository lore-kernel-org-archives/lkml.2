Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab2FRWB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 18:01:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59189 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2FRWB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 18:01:26 -0400
Date: Tue, 19 Jun 2012 08:01:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: Tree for Jun 18 (kmsg problems)
Message-Id: <20120619080109.b28055c1b32fb81027a9562b@canb.auug.org.au>
In-Reply-To: <4FDF61A7.3050601@xenotime.net>
References: <20120618165336.48345227c6b64c314326ae57@canb.auug.org.au>
	<4FDF61A7.3050601@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Jun_2012_08_01_09_+1000_eFMW1_t.IpEeMa0O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Jun_2012_08_01_09_+1000_eFMW1_t.IpEeMa0O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Adding Greg and Kay]

On Mon, 18 Jun 2012 10:13:11 -0700 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> on x86_64:
>=20
> arch/x86/kernel/reboot.o: In function `kmsg_dump_get_line':
> reboot.c:(.text+0xf0): multiple definition of `kmsg_dump_get_line'
> arch/x86/kernel/setup.o:setup.c:(.text+0x0): first defined here
> arch/x86/kernel/reboot.o: In function `kmsg_dump_get_buffer':
> reboot.c:(.text+0x100): multiple definition of `kmsg_dump_get_buffer'
> arch/x86/kernel/setup.o:setup.c:(.text+0x10): first defined here
> arch/x86/kernel/reboot.o: In function `kmsg_dump_rewind':
> reboot.c:(.text+0x110): multiple definition of `kmsg_dump_rewind'
> arch/x86/kernel/setup.o:setup.c:(.text+0x20): first defined here

Caused by commit e2ae715d66bf ("kmsg - kmsg_dump() use iterator to
receive log buffer content") from the driver-core.current tree.

This was reported a few days ago.  Why is it not fixed yet?  Especially
since it is in a branch that is supposedly "bug fixes"?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__19_Jun_2012_08_01_09_+1000_eFMW1_t.IpEeMa0O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP36UlAAoJEECxmPOUX5FEzCUP/2Y+t09o1af1KwFFyZawqJDp
1sjtD0YqxqRqBQCFImSbDnqa8c58Qa1sVjpwbebqz0DVavzvEv9eW8X8PzevVp/l
pYTTBh/1cpFttLPubeOqjFMYxGVB2VlR/QZvDotXZVNVKB2U4DE2C1HRj270/3j9
AoFT5SDs+VlrL465oeQs/6M3S/3YWRfe1n7N+rDWgjIg9/LToHUn2FL6btMtBeD1
dtS7SsVZAqTs4W4kY5vo7ue9bp2CrtDf8OiYRN/hSrAgZkeZ2y9/jF7neahYCcYU
VAwNVO8xcuR02PxOcDudq63qCjSo16jE/QQpjlfDk+JMdxn6a3wTM0RPrHLuqbZv
T1eFvUXQEbS5X4eOt3eFCiSTDlzuOrBZMtOjPgwvRVFDFCcjgkWBxc5Mj1dkEtvm
yJ16jbY2EgHCzshKG5N6N6Dx4ezoEXHk4Bblgc0Qs+467ci+1l359pEOUgCVLoW4
eoaczCGFC3MHTBeKtgwZiIHYslya7Ulud12e3m25+F0gaHvsS1AO3vkyhlBnVz9+
8QJChPmB0LqmeAQ7w+zSSq/XP0PEI0WPvE82WPLgIDsXLWvVIJmnGMQH/Y/YGSRn
fqF7OR9UEMADM3ki6QVQX/n+MxPCB3LGM6CZGbGUKhiXvkTi4LLs2jYrmwVYoq+Q
kNhjuc7Kzzh5CiBKy7OW
=t0/s
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Jun_2012_08_01_09_+1000_eFMW1_t.IpEeMa0O--
