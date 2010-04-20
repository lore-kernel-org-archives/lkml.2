Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab0DTRPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:15:15 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:60805 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab0DTRPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:15:12 -0400
Message-ID: <4BCDE103.7080709@web.de>
Date: Tue, 20 Apr 2010 19:14:43 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Amerigo Wang <xiyou.wangcong@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 4/5] uml: i386: Avoid redefinition of NR_syscalls
References: <cover.1271713955.git.jan.kiszka@web.de> <3e07ad1a38e88a22d7298deb88a8f3962b101998.1271713955.git.jan.kiszka@web.de> <20100420101056.GC5317@cr0.nay.redhat.com>
In-Reply-To: <20100420101056.GC5317@cr0.nay.redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE42528AEAB116ABBB9FB79BA"
X-Provags-ID: V01U2FsdGVkX19zsxf+7amwQAQFb8H7dn/rEYXkXQINjnya1GZb
	RQiAo9B/9UgOdD2O+9TmQDnYZKVz1iA96YJWRlXlqGPD1uGayD
	xG9s41z5k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE42528AEAB116ABBB9FB79BA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Amerigo Wang wrote:
> On Mon, Apr 19, 2010 at 11:53:07PM +0200, Jan Kiszka wrote:
>> The i386 subarch happens to pull in original NR_syscalls. Maybe we can=

>> make that work for all host arch, but for now just avoid the clash by
>> using an all-upper-case name.
>>
>=20
> Where?

Not sure if this answers your question:

  CC      arch/um/kernel/skas/syscall.o
/data/linux-2.6/arch/um/kernel/skas/syscall.c:13:1: warning:
"NR_syscalls" redefined
In file included from /data/linux-2.6/arch/x86/include/asm/unistd.h:3,
                 from
/data/linux-2.6/arch/um/sys-i386/shared/sysdep/syscalls.h:6,
                 from /data/linux-2.6/arch/um/kernel/skas/syscall.c:10:
/data/linux-2.6/arch/x86/include/asm/unistd_32.h:349:1: warning: this is
the location of the previous definition

Jan


--------------enigE42528AEAB116ABBB9FB79BA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkvN4QQACgkQitSsb3rl5xSL+ACeMsBiZ+haVHmcv3BDGYwCJiFh
qgAAoJiOHLlBKdEWx46Ey+zumz2y/IF/
=mzB9
-----END PGP SIGNATURE-----

--------------enigE42528AEAB116ABBB9FB79BA--
